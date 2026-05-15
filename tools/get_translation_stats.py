#!/bin/python3

# pip install py-markdown-table

# выводит табличку по типу такой:
# https://gist.github.com/artem78/5bdf434bdf771de06472809e76a76d01
# не считает переводы названий клавиш

import os, re
from pprint import pp
#from sys import exit
from py_markdown_table.markdown_table import markdown_table
from datetime import datetime
import requests
from markdown_it.rules_inline.backticks import regex
#from packaging.version import Version
#import urllib.parse
import configparser
import glob

    
def get_stats_data():
    global LANG_DIR
    global ENG_LANG_CODE
    #return [{'file_name': 'ru.ini', 'lang_name': 'Russian', 'translated': 50, 'total': 100},
    #        {'file_name': 'en.ini', 'lang_name': 'English', 'translated': 98, 'total': 100}]
    res = []
    
    files = sorted(glob.glob(os.path.join(LANG_DIR, '??.ini')))
    #pp(files)
    total_count = -1
    
    for filename in files:
        lang_ini = configparser.ConfigParser()
        lang_ini.read(filename, 'utf-8')
        translations = lang_ini['translation']
        
        # кол-во переводов названий клавиш
        translated_keys_count = len(list(filter(lambda x: x.startswith('key'), list(translations.keys()))))
        
        res.append({
            'file_name': os.path.basename(filename),
            'lang_name': lang_ini['info']['LangName'],
            'translated': len(lang_ini['translation']),
            'translated_keys': translated_keys_count,
            'total': -1, # заполним позднее
        })
        
        # общее кол-во строк определяем из английского
        if os.path.basename(filename) == ENG_LANG_CODE + '.ini':
            total_count = len(translations)
            
    # ставим total
    #map(lambda r: r['total'] = total_count, res)
    for k, v in enumerate(res):
        res[k]['total']=total_count

    #pp(res)
    return res
    
def print_md_table(stats):
    data = []
    for s in stats:
        #pp(s)

        #sv = s['translated_up_to_ver']
        #try:
        #    sv = tuple_to_ver(ver_to_tuple(sv)) # сокращ.

        #    if (compare_vers(s['translated_up_to_ver'], latest_version) == 0):
        #        sv = '**' + sv + ' (Latest)**'
        #except:
        #    sv = '???'
        
        data.append({
            #'Filename': s['file_name'],
            'Filename': '[lang/{0}](/lang/{0})'.format(s['file_name']),
            'Language': s['lang_name'],
            'Translated strings': '{}/{}  ![](https://geps.dev/progress/{})' .format(
                #s['changed'],
                s['translated'] - s['translated_keys'], # не учитываем кол-во переводов клавиш
                s['total'],
                #s['changed_percent']
                #s['translated_percent']
                round((s['translated'] - s['translated_keys']) / s['total'] * 100, 1) # не учитываем кол-во переводов клавиш
            )#,
            #'Translated up to the version': sv
            # '''"vX.XX" if s['changed'] < s['total'] else "**Latest**"'''
            
        })
    print(markdown_table(data).set_params(row_sep = 'markdown', quote=False).get_markdown())



ENG_LANG_CODE = 'en'
LANG_DIR = '../lang'

stats = get_stats_data()
print_md_table(stats)
print()
print('*(Data updated at ' + str(datetime.now().date()) + ')*')
