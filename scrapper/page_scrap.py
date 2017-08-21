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
import time

from contextlib import contextmanager

class DummyTqdmFile(object):
    ''' Helper class to log in the current 'progress bar' or in a global 'progress bar'.'''
    def __init__(self, pbar=None):
        self.pbar = pbar if pbar else tqdm

    def write(self, x):
        if len(x.rstrip()) > 0:
            self.pbar.write(x)

@contextmanager
def open_temporally(session, url):
    primary_driver = session.driver
    tries = 3
    while tries > 0:
        try:
            session._secondary_driver.get(url)
            break
        except:
            print "open failed... left %i tries" % tries
            tries -= 1
            session._secondary_driver.close()
            time.sleep(5)
            session._secondary_driver =  webdriver.Firefox(executable_path=session.selenium_driver_executable_path)
            time.sleep(10)

    try:
        # swap drivers
        session.driver = session._secondary_driver

        # do whatever you have to do on this page
        yield

    finally:
        session.driver = primary_driver

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

                       source_asset_path_prefix = '/wp-content/uploads/',
                       destination_asset_path_prefix = '/assets/',

                       destination_post_path_prefix = '/_posts/',
        
                       repository_home = os.path.join(os.path.dirname(os.path.abspath(__file__)), "../"),
                       
                       estimate_of_total_count_of_post_to_port=34
                    ):
        '''
            s = Session()
            s.open_firefox()  # this will use the selenium_driver_executable_path and open the source_site page.

            s.open_first_post() # open the first_post_url page and then move to the next post skip_post_count times (0 by default).

            s.go_to_next_post()       # open the next post page or the 
            s.go_to_previous_post()   # previous post page as you wish

            # then you can port the current web page ....
            s.port_post()  # port the current web page:
                           #  - remap the links to source_site to / (the current site)
                           #  - download and remap the assets from source_asset_path_prefix to destination_asset_path_prefix
                           #  - rewrite the code snippets
                           #
                           # save the ported post into destination_post_path_prefix

            # or port all the web pages in one shot!
            s.port_all_posts()
            '''

        self.first_post_url = first_post_url
        self.skip_post_count = skip_post_count

        self.selenium_driver_executable_path = selenium_driver_executable_path
        self.source_netloc = source_netloc
        
        self.source_site = source_site

        self.source_asset_path_prefix = source_asset_path_prefix
        self.destination_asset_path_prefix = destination_asset_path_prefix

        self.destination_post_path_prefix = destination_post_path_prefix

        self.repository_home = repository_home

        self.estimate_of_total_count_of_post_to_port = estimate_of_total_count_of_post_to_port


    def open_firefox(self):
        ''' Open a browser under the control of Selenium.
            You need a 'driver' to interact with the browser that you can 
            download it from "https://github.com/mozilla/geckodriver/releases"
            '''
        driver = webdriver.Firefox(executable_path=self.selenium_driver_executable_path)
        driver.get(self.source_site) # just to check if everything works
        driver.set_page_load_timeout(120)

        self.driver = driver

        self._secondary_driver =  webdriver.Firefox(executable_path=self.selenium_driver_executable_path)
        self._secondary_driver.get(self.source_site) 
        self._secondary_driver.set_page_load_timeout(120)

        return driver

    def close_browser(self):
        self.driver.close()
        self._secondary_driver.close()

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
        except:             # TODO improve this: this is a too relaxed condition
            return False

    def go_to_previous_post(self, pbar=None):
        ''' The inverse of go_to_next_post.'''
        driver = self.driver
        previous_post_url = driver.find_element(By.CLASS_NAME, "nav-previous").find_element(By.TAG_NAME, "a").get_attribute('href')
        driver.get(previous_post_url)
        print "You are at: %s" % previous_post_url

    def get_post_title_and_date(self):
        driver = self.driver
        title = driver.find_element(By.CLASS_NAME, "entry-title").text

        try:
            date = driver.find_element(By.CLASS_NAME, "entry-date").text
        except:
            date = "25/10/1985"

        return title, date

    def get_post_data(self):
        ''' Read from the current web page loaded in the browser all the relevant data of the post.
            Here is where you do the "real scrap":
                - the author of the post
                - its content of course!
                - its tags

            But it is likely that this implementation is incomplete, so:
                
                IMPROVE ME!!

            '''
        driver = self.driver
        try:
            author = driver.find_element(By.CLASS_NAME, "author").text
        except:
            author = 'admin'

        post_content = driver.find_element(By.CLASS_NAME, "entry-content")
        self.remap_urls(post_content)
        snippets = self.rewrite_code_snippets(post_content)

        del post_content # just to make this explicit, we need a fresh reference after the remap urls
        post_content = driver.find_element(By.CLASS_NAME, "entry-content")

        post_content_html = post_content.get_attribute('outerHTML')

        tags = []
        tag_links = driver.find_elements(By.CSS_SELECTOR, 'a[rel="category tag"]')
        for l in tag_links:
            tags.append(l.text)

        tags = ', '.join(tags)

        return author, snippets, post_content_html, tags



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
        
        print "Remapping %i links/urls" % len(links)
        for link in links:
            original_url = link.get_attribute('href')
            if original_url is None:
                continue

            src_url_parsed = urllib2.urlparse.urlparse(original_url)

            if src_url_parsed.netloc != self.source_netloc or src_url_parsed.scheme == "https": # https is for sercom
                continue # skip it, we map only our internal 'self.source_netloc' urls, not the other ones.

            if src_url_parsed.path.startswith(self.source_asset_path_prefix):
                download_url = original_url
                dst_path = src_url_parsed.path.replace(self.source_asset_path_prefix, self.destination_asset_path_prefix, 1)
                
                if download:
                    self.download_asset(download_url, dst_path)

            else:
                with open_temporally(self, original_url):
                    refered_title, refered_date = self.get_post_title_and_date()
                    _, _, dst_path = self.get_year_filename_and_urlpath(refered_title, refered_date)

            dst_url_parsed = urllib2.urlparse.ParseResult(
                                        scheme='',
                                        netloc='',

                                        path=dst_path,

                                        params=src_url_parsed.params, 
                                        query=src_url_parsed.query, 
                                        fragment=src_url_parsed.fragment)

            new_url = dst_url_parsed.geturl()

            driver.execute_script(js_set_attr % ('href', '"%s"' % new_url), link)

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
        js_remove_attr = '''arguments[0].removeAttribute("%s"); return true;'''
        snippet_containers = post_content.find_elements_by_css_selector(".syntaxhighlighter")

        print "Rewritting %i code snippets" % len(snippet_containers)
        rewritten_snippets = []
        for idx, container in enumerate(snippet_containers):
            snippet = container.find_element_by_css_selector(".code").text

            highlighted_syntax_block = '```cpp\n%s\n```' % snippet
            idented_block = '\n'.join((' ' * 8) + line  for line in highlighted_syntax_block.split('\n'))

            highlighted_syntax_snippet = '\n' + (' ' * 4) + '- |\n%s\n' % idented_block

            include_snippet_tag = "'{{page.snippets[%i] | markdownify }}'" % idx
            self.driver.execute_script(js_set_attr % ('innerHTML', include_snippet_tag), container)

            self.driver.execute_script(js_remove_attr % ('class'), container)
            self.driver.execute_script(js_remove_attr % ('id'), container)

            rewritten_snippets.append(highlighted_syntax_snippet)

        if rewritten_snippets:
            return "".join(rewritten_snippets)
        else:
            return 'none\n'


    def get_normalize_title(self, title):
        return (' '.join(unidecode.unidecode_expect_ascii(title).replace("-", " ").split())).replace(" ", "-").replace("/", "-")

    def port_post(self):
        ''' Scrap the current web page (post) using get_post_data and create a new post
            with the syntaxis required by githubpages.

            If the template used in githubpages is changed it is possible that this method
            will require a few improvements.

            '''
        driver = self.driver

        title, date = self.get_post_title_and_date()

        author, snippets, post_content_html, tags = self.get_post_data()
        year, file_name, _ = self.get_year_filename_and_urlpath(title, date)

        file_dir = os.path.join(self.repository_home, self.destination_post_path_prefix[1:], year)
        os.system('mkdir -p "%s"' % file_dir)

        post = Post_Template % dict(title=title,
                                    author=author, date=date,
                                    snippets=snippets,
                                    content = post_content_html, 
                                    tags = tags)

        with open(os.path.join(file_dir, file_name), 'wt') as post_file:
            post_file.write(post.encode('utf8'))

    def get_year_filename_and_urlpath(self, title, date):
        normalized_title = self.get_normalize_title(title)

        day, month, year = date.split("/")
        assert len(year) == 4
        
        file_name = "%s-%s-%s-%s.md" % (year, month, day, normalized_title)
        webpage_url_path = "/%s/%s/%s/%s.html" % (year, month, day, normalized_title)

        return year, file_name, webpage_url_path

    def port_all_posts(self):
        with tqdm(total=self.estimate_of_total_count_of_post_to_port, unit='Post', unit_scale=True) as pbar, \
                stdout_redirect_to_tqdm(pbar):
            
            self.port_post()
            pbar.update(1)

            has_next = self.try_go_to_next_post()
            while has_next:
                self.port_post()
                pbar.update(1)

                has_next = self.try_go_to_next_post()

            print("[DONE]")



Post_Template = '''---
layout: post
title: %(title)s
author: %(author)s
date: %(date)s
tags: [%(tags)s]
snippets: %(snippets)s
---
%(content)s
'''


