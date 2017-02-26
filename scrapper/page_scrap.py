# coding: utf-8
import selenium
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
import urllib2
import contextlib
import sys
import traceback
import os
from tqdm import tqdm
import unidecode

class DummyTqdmFile(object):
    ''' Helper class to log in the current 'progress bar' or in a global 'progress bar'.'''
    def __init__(self, pbar=None):
        self.pbar = pbar if pbar else tqdm

    def write(self, x):
        if len(x.rstrip()) > 0:
            self.pbar.write(x)

@contextlib.contextmanager
def stdout_redirect_to_tqdm(pbar=None):
    ''' Helper function to redirect all the prints to tqdm. In this way, when tqdm is 
        showing in the console its progress bar, the prints to the raw stdout will not
        collide each other.
        When the prints are handled by tqdm itself, he will know how to print all the stuffs
        along with the progress bar.
        '''
    save_stdout = sys.stdout
    try:
        sys.stdout = DummyTqdmFile(pbar)
        yield save_stdout

    except Exception as exc:
        raise exc

    finally:
        sys.stdout = save_stdout

class Session(object):
    def __init__(self, first_post_url = "http://7542.fi.uba.ar/trabajos-practicos/guia-entregas-tp-individual/",
                       skip_post_count = 0,

                       selenium_driver_executable_path="./geckodriver",
                       source_netloc = "7542.fi.uba.ar",

                       source_site ="http://7542.fi.uba.ar/",
                       destination_site = 'https://taller-de-programacion.github.io',

                       source_asset_path_prefix = '/wp-content/uploads/',
                       destination_asset_path_prefix = '/assets/',

                       destination_post_path_prefix = '/_posts/',
        
                       repository_home = os.path.join(os.path.dirname(os.path.abspath(__file__)), "../")
                    ):
        '''
            s = Session()
            s.open_firefox()  # this will use the selenium_driver_executable_path and open the source_site page.

            s.open_first_post() # open the first_post_url page and then move to the next post skip_post_count times (0 by default).

            s.go_to_next_post()       # open the next post page or the 
            s.go_to_previous_post()   # previous post page as you wish

            s.port_post()  # port the current web page to the destination_site:
                           #  - remap the links to source_site to destination_site
                           #  - download and remap the assets from source_asset_path_prefix to destination_asset_path_prefix
                           #  - rewrite the code snippets
                           #
                           # save the ported post into destination_post_path_prefix
            '''

        self.first_post_url = first_post_url
        self.skip_post_count = skip_post_count

        self.selenium_driver_executable_path = selenium_driver_executable_path
        self.source_netloc = source_netloc
        
        self.source_site = source_site
        self.destination_site = destination_site

        self.source_asset_path_prefix = source_asset_path_prefix
        self.destination_asset_path_prefix = destination_asset_path_prefix

        self.destination_post_path_prefix = destination_post_path_prefix

        self.repository_home = repository_home


    def open_firefox(self):
        ''' Open a browser under the control of Selenium.
            You need a 'driver' to interact with the browser that you can 
            download it from "https://github.com/mozilla/geckodriver/releases"
            '''
        driver = webdriver.Firefox(executable_path=self.selenium_driver_executable_path)
        driver.get(self.source_site) # just to check if everything works

        self.driver = driver
        return driver

    def close_browser(self):
        self.driver.close()

    def open_first_post(self):
        ''' Go to the 'first_post_url' url using the browser. Then, skip up to 'skip_post_count' posts.
            From there you should be ready to scrap the site.
            The skip_post_count parameter will enable you to control from where to start without to rewrite
            the 'first_post_url' url.
            '''
        driver = self.driver
        driver.get(self.first_post_url)

        print "You are at: %s" % self.first_post_url
        if self.skip_post_count:
            print "Skipping the first %i pages" % self.skip_post_count
            with tqdm(total=self.skip_post_count, unit='Posts', unit_scale=True) as pbar, \
                    stdout_redirect_to_tqdm(pbar):

                for i in range(self.skip_post_count):
                    self.go_to_next_post(pbar)
                    pbar.update(1)

    def go_to_next_post(self, pbar=None):
        ''' Given a browser with a post page opened in it, go to the next post page. Simple.'''
        driver = self.driver
        next_post_url = driver.find_element(By.CLASS_NAME, "nav-next").find_element(By.TAG_NAME, "a").get_attribute('href')
        driver.get(next_post_url)
        print "You are at: %s" % next_post_url

    def try_go_to_next_post(self, pbar=None):
        try:
            self.go_to_next_post(pbar)
            return True
        except:
            return False

    def go_to_previous_post(self, pbar=None):
        ''' The inverse of go_to_next_post.'''
        driver = self.driver
        previous_post_url = driver.find_element(By.CLASS_NAME, "nav-previous").find_element(By.TAG_NAME, "a").get_attribute('href')
        driver.get(previous_post_url)
        print "You are at: %s" % previous_post_url

    def get_post_data(self):
        ''' Read from the current web page loaded in the browser all the relevant data of the post.
            Here is where you do the "real scrap":
                - get the title of the post
                - the author of the post
                - the date of the post
                - its content of course!

            But it is likely that this implementation is incomplete, so:
                
                IMPROVE ME!!

            '''
        driver = self.driver
        title = driver.find_element(By.CLASS_NAME, "entry-title").text
        author = driver.find_element(By.CLASS_NAME, "author").text
        date = driver.find_element(By.CLASS_NAME, "entry-date").text

        post_content = driver.find_element(By.CLASS_NAME, "entry-content")
        self.remap_urls(post_content)
        snippets = self.rewrite_code_snippets(post_content)

        del post_content # just to make this explicit, we need a fresh reference after the remap urls
        post_content = driver.find_element(By.CLASS_NAME, "entry-content")

        post_content_html = post_content.get_attribute('outerHTML')

        return date, title, author, snippets, post_content_html



    def remap_urls(self, container, download=True):
        ''' Remap the urls that are in the page in the Browser taking urls relative to the
            Wordpress site and transforming them into urls relative to the new githubpage site.

            This is done **in** the browser, modifing the webpage in real time. This is done in
            this way so we can request to the browser the html of the page later and that html
            will contain the remapped urls.
            Otherwise we would have to parse and modify the html by ourselves: no way!

            This implementation if far from perfect or complete. It handles relative urls and
            download links but it is likely that this will need more love, so
                
                IMPROVE ME!!

            '''
        driver = self.driver
        js_set_attr = '''arguments[0].%s = %s; return true;'''

        links = container.find_elements(By.TAG_NAME, 'a')
        dst_url_parsed_template = urllib2.urlparse.urlparse(self.destination_site)
        
        with tqdm(total=len(links), unit='Link', unit_scale=True) as pbar, \
                stdout_redirect_to_tqdm(pbar):

            for link in links:
                original_url = link.get_attribute('href')
                if original_url is None:
                    pbar.update(1)
                    continue

                src_url_parsed = urllib2.urlparse.urlparse(original_url)

                if src_url_parsed.netloc != self.source_netloc:
                    pbar.update(1) # skip it, we map only our internal 'self.source_netloc' urls, not the other ones.
                    continue

                if src_url_parsed.path.startswith(self.source_asset_path_prefix):
                    download_url = original_url
                    dst_path = src_url_parsed.path.replace(self.source_asset_path_prefix, self.destination_asset_path_prefix, 1)
                    
                    if download:
                        self.download_asset(download_url, dst_path)

                else:
                    dst_path = src_url_parsed.path


                dst_url_parsed = urllib2.urlparse.ParseResult(
                                            scheme=dst_url_parsed_template.scheme, 
                                            netloc=dst_url_parsed_template.netloc, 

                                            path=dst_path,

                                            params=src_url_parsed.params, 
                                            query=src_url_parsed.query, 
                                            fragment=src_url_parsed.fragment)

                new_url = dst_url_parsed.geturl()

                driver.execute_script(js_set_attr % ('href', '"%s"' % new_url), link)
                pbar.update(1)

    def download_asset(self, download_url, dst_path):
        ''' Helper method to download an asset from the scrapped site. '''
        file_dir = os.path.join(self.repository_home, os.path.dirname(dst_path)[1:])
        dst_file = os.path.join(file_dir, os.path.basename(dst_path))

        if os.path.exists(dst_file):
            return

        os.system('mkdir -p "%s"' % file_dir)
        os.system('wget -c "%s" -O "%s"' % (download_url, dst_file))

    def rewrite_code_snippets(self, post_content):
        js_set_attr = '''arguments[0].%s = %s; return true;'''
        snippet_containers = post_content.find_elements_by_css_selector(".syntaxhighlighter")

        rewritten_snippets = []
        for idx, container in enumerate(snippet_containers):
            snippet = container.find_element_by_css_selector(".code").text

            highlighted_syntax_block = '```cpp\n%s\n```' % snippet
            idented_block = '\n'.join((' ' * 8) + line  for line in highlighted_syntax_block.split('\n'))

            highlighted_syntax_snippet = '\n' + (' ' * 4) + '- |\n%s\n' % idented_block

            include_snippet_tag = "'{{page.snippets[%i] | markdownify }}'" % idx
            self.driver.execute_script(js_set_attr % ('innerHTML', include_snippet_tag), container)
            self.driver.execute_script(js_set_attr % ('className', "''"), container)


            rewritten_snippets.append(highlighted_syntax_snippet)

        if rewritten_snippets:
            return "".join(rewritten_snippets)
        else:
            return 'none\n'


    def port_post(self):
        ''' Scrap the current web page (post) using get_post_data and create a new post
            with the syntaxis required by githubpages.

            If the template used in githubpages is changed it is possible that this method
            will require a few improvements.

            '''
        driver = self.driver
        date, title, author, snippets, post_content_html = self.get_post_data()

        day, month, year = date.split("/")
        assert len(year) == 4

        file_dir = os.path.join(self.repository_home, self.destination_post_path_prefix[1:], year)
        os.system('mkdir -p "%s"' % file_dir)

        normalized_title = (' '.join(unidecode.unidecode_expect_ascii(title).replace("-", " ").split())).replace(" ", "-").replace("/", "-")
        file_name = "%s-%s-%s-%s.mk" % (year, month, day, normalized_title)

        post = Post_Template % dict(title=title,
                                    author=author, date=date,
                                    snippets=snippets,
                                    content = post_content_html)

        with open(os.path.join(file_dir, file_name), 'wt') as post_file:
            post_file.write(post.encode('utf8'))

    def port_all_posts(self):
        self.port_post()

        has_next = self.try_go_to_next_post()
        while has_next:
            self.port_post()
            has_next = self.try_go_to_next_post()



Post_Template = '''---
layout: post
title: %(title)s
author: %(author)s
date: %(date)s
snippets: %(snippets)s
---
%(content)s
'''


