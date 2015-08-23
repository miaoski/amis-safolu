# -*- coding: utf8 -*-
# Convert RAW text file to dict phase 1
"""
'acfel    煙霧，燻煙。Mafiwfiw no fali ko 'acfel . 煙被風吹散。同 'acefol。
acek    ①  污穢，醜惡。②  令人惡心，嫌惡。Maacek kako to kadit. 我對髒很厭惡。參見 maacek。
"""


import re
import sys
import codecs
import unicodedata as ud

def replace_dots(x):
    x = x.replace(u'① ', '\n'+u'① ') \
         .replace(u'② ', '\n'+u'② ') \
         .replace(u'③ ', '\n'+u'③ ') \
         .replace(u'④ ', '\n'+u'④ ') \
         .replace(u'⑤ ', '\n'+u'⑤ ') \
         .replace(u'⑥ ', '\n'+u'⑥ ') \
         .replace(u'⑦ ', '\n'+u'⑦ ') \
         .replace(u'⑧ ', '\n'+u'⑧ ') \
         .replace(u'⑨ ', '\n'+u'⑨ ')
    return x

def main():
    f = codecs.open(sys.argv[1], 'r', 'utf-8')
    out = codecs.open('../dict/' + sys.argv[1], 'w', 'utf-8')
    for l in f.readlines():
        xs = re.split(r' {3,}', l.strip())
        body = replace_dots(xs[1])
        print xs[0].strip()
        print >>out, xs[0].strip()
        for circ in body.split('\n'):
            if len(circ) == 0:
                continue
            tups = []
            for m in re.finditer(r"[A-Za-z'^.,:?! ]{10,}", circ):    # 超過 10 個字母就當例句
                tups.append(m.start())
                tups.append(m.end())
            tups.append(len(circ))
            print circ[:tups[0]].strip()
            print >>out, circ[:tups[0]].strip()
            for t in zip(tups, tups[1:]):
                print '    ' + circ[t[0]:t[1]].strip()
                print >>out, '    ' + circ[t[0]:t[1]].strip()
        print
        print >>out, ''

if __name__ == '__main__':
    main()
