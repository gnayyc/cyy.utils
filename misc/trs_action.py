#!/usr/bin/env python3

import requests
from lxml import etree
import re

from configparser import ConfigParser
import os

import urllib

cfg = ConfigParser()
cfg.read('/home/ubuntu/.trs.conf')
tg_token = cfg['default']['tg_token']
tg_chatid = cfg['default']['tg_chatid']


requests.packages.urllib3.disable_warnings()
requests.packages.urllib3.util.ssl_.DEFAULT_CIPHERS += ':HIGH:!DH:!aNULL'

try:
    requests.packages.urllib3.contrib.pyopenssl.util.ssl_.DEFAULT_CIPHERS += ':HIGH:!DH:!aNULL'
except AttributeError:
    # no pyopenssl support used / needed / available
    pass

rsroc = "https://www.rsroc.org.tw"

url = "https://www.rsroc.org.tw/action/"
response = requests.get(url)
content = response.content.decode()
html = etree.HTML(content)
tt = html.xpath('//td[@class="today"]//a/text()')
actions = html.xpath('//td[@class="today"]//a/@href')

debug = False
if debug == True:
    url = "https://www.rsroc.org.tw/action/"
    response = requests.get(url)
    content = response.content.decode()
    html = etree.HTML(content)
    tt = html.xpath('(//a[contains(text(), "[線上直播]")])[3]//../..//a/text()')
    actions = html.xpath('(//a[contains(text(), "[線上直播]")])[3]//../..//a/@href')

for i in range(0, len(tt)):
    match = re.search("^\\[線上直播\\].*", tt[i])
    if match:
        tg_cmd = "curl 'https://api.telegram.org/bot%s/sendmessage?chat_id=%s&text=%s'" % (tg_token, tg_chatid, urllib.parse.quote(rsroc + actions[i]))
        os.system(tg_cmd)
        print()
        print('    [%s](%s)' % (tt[i], rsroc + actions[i]))
        # url = "https://www.rsroc.org.tw/action/actions_onlinedetail.asp?EType=&id=11626"
        response = requests.get(rsroc + actions[i])
        content = response.content.decode()
        html = etree.HTML(content)
        registry_url = html.xpath('//div[@class="url"]/a/@href')
        #checkin_url = html.xpath('//a[contains(@href, "forms.gle")]/@href')
        checkin_url = html.xpath('//a[contains(text(), "線上積分登錄")]/@href')
        t = re.search('積分登錄時間 (\d{4})\/(\d{2})\/(\d{2}).*(\d{2}):(\d{2}) ~ (\d{2}):(\d{2})', content)
        if checkin_url and t:
            y = t.group(1)
            m = t.group(2)
            d = t.group(3)
            h = t.group(4)
            m = t.group(5)
            h2 = t.group(6)
            m2 = t.group(7)
            #echo '/home/ubuntu/trs_action.py'|at 0745
            tg_cmd = "curl 'https://api.telegram.org/bot%s/sendmessage?chat_id=%s&text=%s'" % (tg_token, tg_chatid, urllib.parse.quote(checkin_url[0]))
            #os.system(tg_cmd)
            at_cmd = "echo '%s'| at %s%s" % (tg_cmd, h, m)
            os.system(at_cmd)
        t = re.search('放射線專科醫師教育積分', content)
        if t:
            print(t.group(0))

