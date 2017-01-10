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
    def __init__(self, pbar=None):
        self.pbar = pbar if pbar else tqdm

    def write(self, x):
        if len(x.rstrip()) > 0:
            self.pbar.write(x)

@contextlib.contextmanager
def stdout_redirect_to_tqdm(pbar=None):
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
        driver = self.driver
        next_post_url = driver.find_element(By.CLASS_NAME, "nav-next").find_element(By.TAG_NAME, "a").get_attribute('href')
        driver.get(next_post_url)
        print "You are at: %s" % next_post_url


    def go_to_previous_post(self, pbar=None):
        driver = self.driver
        previous_post_url = driver.find_element(By.CLASS_NAME, "nav-previous").find_element(By.TAG_NAME, "a").get_attribute('href')
        driver.get(previous_post_url)
        print "You are at: %s" % previous_post_url

    def get_post_data(self):
        driver = self.driver
        title = driver.find_element(By.CLASS_NAME, "entry-title").text
        author = driver.find_element(By.CLASS_NAME, "author").text
        date = driver.find_element(By.CLASS_NAME, "entry-date").text

        post_content = driver.find_element(By.CLASS_NAME, "entry-content")
        self.remap_urls(post_content)

        del post_content # just to make this explicit, we need a fresh reference after the remap urls
        post_content = driver.find_element(By.CLASS_NAME, "entry-content")

        post_content_html = post_content.get_attribute('outerHTML')

        return date, title, author, post_content_html



    def remap_urls(self, container, download=True):
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
        file_dir = os.path.join(self.repository_home, os.path.dirname(dst_path)[1:])
        dst_file = os.path.join(file_dir, os.path.basename(dst_path))

        if os.path.exists(dst_file):
            return

        os.system('mkdir -p "%s"' % file_dir)
        os.system('wget -c "%s" -O "%s"' % (download_url, dst_file))

    def port_post(self):
        driver = self.driver
        date, title, author, post_content_html = self.get_post_data()

        day, month, year = date.split("/")
        assert len(year) == 4

        file_dir = os.path.join(self.repository_home, self.destination_post_path_prefix[1:], year)
        os.system('mkdir -p "%s"' % file_dir)

        normalized_title = (' '.join(unidecode.unidecode_expect_ascii(title).replace("-", " ").split())).replace(" ", "-")
        file_name = "%s-%s-%s-%s.mk" % (year, month, day, normalized_title)

        post = Post_Template % dict(title=title,
                                    author=author, date=date,
                                    content = post_content_html)

        with open(os.path.join(file_dir, file_name), 'wt') as post_file:
            post_file.write(post.encode('utf8'))


Post_Template = '''---
layout: post
title: %(title)s
author: %(author)s
date: %(date)s
---
%(content)s
'''


if False:
    driver.get("http://7542.fi.uba.ar/2010/08") 
    driver.find_elements(By.CLASS_NAME, "entry-title")
    [e.find_element(By.TAG_NAME, "a") for e in driver.find_elements(By.CLASS_NAME, "entry-title")]
    post_links = [e.find_element(By.TAG_NAME, "a") for e in driver.find_elements(By.CLASS_NAME, "entry-title")]
    post_link = post_links[0]
    post_link.get_attribute('href')
    post_urls = [e.find_element(By.TAG_NAME, "a").get_attribute('href') for e in driver.find_elements(By.CLASS_NAME, "entry-title")]
    post_urls
    post_url = post_urls[0]
    post_url
    driver.get(post_url)
    driver.find_elements(By.CLASS_NAME, "entry-title")
    driver.find_elements(By.CLASS_NAME, "post")
    driver.find_elements(By.CLASS_NAME, "entry-title")
    e = driver.find_elements(By.CLASS_NAME, "entry-title")[0]
    e.text
    e = driver.find_elements(By.CLASS_NAME, "entry-title")[1]
    title = driver.find_element(By.CLASS_NAME, "entry-title").text
    title
    e = driver.find_elements(By.CLASS_NAME, "entry-date")[1]
    date = driver.find_element(By.CLASS_NAME, "entry-date").text
    date
    e = driver.find_elements(By.CLASS_NAME, "author")[1]
    e = driver.find_elements(By.CLASS_NAME, "author")[0]
    e.text
    author = driver.find_element(By.CLASS_NAME, "author").text
    author
    e = driver.find_elements(By.CLASS_NAME, "nav-previous")[1]
    driver.find_elements(By.CLASS_NAME, "nav-previous")
    previous_post_url = driver.find_element(By.CLASS_NAME, "nav-previous").find_element(By.TAG_NAME, "a").get_attribute('href')
    previous_post_url
    next_post_url = driver.find_element(By.CLASS_NAME, "nav-next").find_element(By.TAG_NAME, "a").get_attribute('href')
    next_post_url
    first_post_url = "http://7542.fi.uba.ar/trabajos-practicos/guia-entregas-tp-individual/"
    driver.get(first_post_url)
    post_content_html = driver.find_element(By.CLASS_NAME, "entry-content").get_attribute('outerHTML')
    print post_content_html
    post_content = driver.find_element(By.CLASS_NAME, "entry-content")
    links = post_content.find_elements(By.TAG_NAME, 'a')
    link = links[0]
    link
    link.text
    if True:
                  js_set_attr = '''arguments[0].%s = %s;
              return true;'''
    js_set_attr
    #driver.execute_script(js_set_attr % (
    link.href
    link.get_attribute('href')
    driver.execute_script(js_set_attr % ('http://example.com/trabajos-practicos/guia-entregas-tp-individual/', link)
    )
    js_set_attr
    driver.execute_script(js_set_attr % ('"http://example.com/trabajos-practicos/guia-entregas-tp-individual/"', link)
    )
    driver.execute_script(js_set_attr % ('"http://example.com/trabajos-practicos/guia-entregas-tp-individual/"', link))
    driver.execute_script(js_set_attr % ('"http://example.com/trabajos-practicos/guia-entregas-tp-individual/"', link))
    #js_set_attr % ('"http://example.com/trabajos-practicos/guia-entregas-tp-individual/"'
    js_set_attr % ('"http://example.com/trabajos-practicos/guia-entregas-tp-individual/"', "X")
    driver.execute_script(js_set_attr % ('href', '"http://example.com/trabajos-practicos/guia-entregas-tp-individual/"', link))
    driver.execute_script(js_set_attr % ('href', '"http://example.com/trabajos-practicos/guia-entregas-tp-individual/"'), link)
    link.get_attribute('href')
    post_content_html = driver.find_element(By.CLASS_NAME, "entry-content").get_attribute('outerHTML')
    post_content_html
    print post_content_html
    get_ipython().magic(u'save page_scrap 1-71')
