# -*- coding: utf8 -*-
# Make index.json

import glob
import codecs
import json
from moedict import removeStems, getStem

INDEX = []
STEMS = []

title = None
state = None
for fn in glob.iglob('[0-9][0-9]-*.txt'):
    fp = open(fn)
    print fn
    for line in fp:
        l = line.strip()
        if l == '' and title:       # 寫入詞條
            INDEX.append(title.lower())
            title = None
            state = None
            continue
        if l == '':
            continue
        if l[0] == '#':
            continue
        xs = l.split()              # 處理 word'a = word'b
        if state is None and len(xs) == 3 and xs[1] == '=':
            title = xs[0].strip()
            INDEX.append(title.lower())
            title = None
            continue
        if state is None:           # 詞
            stem = getStem(l)
            if stem:
                STEMS.append(stem.lower())
                if stem.find('(') > -1:
                    print '!!!', l
            title = removeStems(l)
            if title == '':
                print 'Wrong!', l
            state = 't'
if title:
    INDEX.append(title.lower())

INDEX = set(INDEX)                  # dedup
INDEX = list(INDEX)
STEMS = set(STEMS)
STEMS = list(STEMS)

f = codecs.open('index.json', mode='w', encoding='utf8')
x = json.dumps(INDEX, indent=2, separators=(',', ':'), ensure_ascii = False)
try:
    f.write(x)
except UnicodeDecodeError as e:
    print x[e.start-20:e.start+20]
    raise
f.close()

f = codecs.open('stems.json', mode='w', encoding='utf8')
x = json.dumps(STEMS, indent=2, separators=(',', ':'), ensure_ascii = False)
try:
    f.write(x)
except UnicodeDecodeError as e:
    print x[e.start-20:e.start+20]
    raise
f.close()
