# coding: utf-8
import selenium
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
driver = webdriver.Firefox()
driver = webdriver.Firefox()
driver = webdriver.Firefox(executable_path="./geckodriver")
driver_from_github = "https://github.com/mozilla/geckodriver/releases"
driver.get("http://7542.fi.uba.ar/")
driver.get("http://7542.fi.uba.ar/2010/08") 
from selenium.webdriver.common.by import By
driver.find_elements(By.CLASS_NAME, "entry-title")
[e.find_element(By.TAG_NAME, "a") for e in driver.find_elements(By.CLASS_NAME, "entry-title")Ç
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
js_set_attr % ('"http://example.com/trabajos-prac
ticos/guia-entregas-tp-individual/"'
js_set_attr % ('"http://example.com/trabajos-practicos/guia-entregas-tp-individual/"', "X")
driver.execute_script(js_set_attr % ('href', '"http://example.com/trabajos-practicos/guia-entregas-tp-individual/"', link))
driver.execute_script(js_set_attr % ('href', '"http://example.com/trabajos-practicos/guia-entregas-tp-individual/"'), link)
link.get_attribute('href')
post_content_html = driver.find_element(By.CLASS_NAME, "entry-content").get_attribute('outerHTML')
post_content_html
print post_content_html
get_ipython().magic(u'save page_scrap 1-71')
