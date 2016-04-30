#-*- coding: utf8 -*-
# Convert .txt files in the same directory to dict-amis.json for moedict

import sys
import re

pat = "\[.*?(\d)\]"
reg = re.compile(pat)

JSON = {}

def removeStems(s):
    s = s.replace('。', '')                     # Dirty
    idx = s.find("(")
    if idx!= -1:
        s = s[:idx]
    return s.strip()


def ngtilde(s):
    import re
    from amis_stemmer import gnostic
    w1 = re.split(r"([\w:']+)", s.strip())
    w2 = map(gnostic, w1)
    return ''.join(w2)
    #return re.sub(r'([\w\']+)', r'`\1~', ng(s))

def synonyms(s):
    return s.replace('。', '').strip()

# 加入萌典前端使用的標記
# \ufff9: 阿美語例句
# \ufffa: 英文例句
# \ufffb: 漢語例句
def addsplt(s):
    return u'\ufff9'+s[0].decode('utf8')+u'\ufffa'+s[1].decode('utf8')+u'\ufffb'+s[2].decode('utf8')


def mkword(title, definitions, tag, stem):
    global JSON
    word = {'title': title, 
        'heteronyms': [{'definitions': definitions}]}
    if tag:
        word['tag'] = tag
    if stem:
        word['stem'] = stem
    if title in JSON:
        print "Add heteronym: " + title
        JSON[title]['heteronyms'].append({'definitions': definitions})
    else:
        JSON[title] = word

def mkdef(defi, examples, link):
    defdic = {}
    if len(examples) > 0:
        defdic['example'] = examples
        examples = []
    defdic['def'] = addsplt(['', '', defi])     # workaround 
    if link:
        defdic['synonyms'] = map(synonyms, link)
        # defdic['synonyms'] = map(ngtilde, link)
    return defdic

def readdict(fn):
    fp = open(fn, 'ru')
    title = None                                # 詞
    tag = None                                  # 疊文
    stem = None                                 # 字根
    state = None    
    num_words = 0
    for line in fp:
        l = line.replace('① ', '') \
             .replace('② ', '') \
             .replace('③ ', '') \
             .replace('④ ', '') \
             .replace('⑤ ', '') \
             .replace('⑥ ', '') \
             .replace('⑦ ', '') \
             .replace('⑧ ', '') \
             .replace('⑨ ', '')
        l = l.strip()

        if l == '' and title:                   # 寫入詞條
            num_words += 1
            defdic = mkdef(defi, examples, link)
            if len(defdic) > 0:
                definitions.append(defdic)
            mkword(title, definitions, tag, stem)
            title = None
            state = None
            tag = None
            stem = None
            definitions = []
            examples = []
            link = [] 
            defi = "" 
            continue
        if l == '':                             # 空白行
            continue
        if l[0] == '#':                         # 註解
            continue


        if state is None:                       # 詞
            stem_r = re.search(ur'\(.+\)', l)
            if stem_r:
                stem = l[stem_r.start() + 1:stem_r.end() - 1]
            else:
                stem = ''
            title = removeStems(l)
            definitions = []
            examples = []
            link = [] 
            defi = "" 
            state = 'd'
            continue

        if l[0:2] == '=>':                      # 相關詞
            state = 'l'
        if line[0:4] == '    ':                 # 例句
            state = 'e' + state
        
        if state == 'd':                        # 漢語定義
            tag_r = re.search(ur'\[.+\]', l)    # [疊2] [日語借詞] 這類
            if tag_r:
                tag = l[tag_r.start():tag_r.end()]
                l = l.replace(tag, '').replace('。。', '。')

            if defi!="":                        # 有上一個def
                defdic = mkdef(defi, examples, link)
                if len(defdic) > 0:
                    definitions.append(defdic)
                    examples = []
                    link = [] 
            
            defi = l;
            state = 'd'
            continue

        if state == 'ed':                       # 阿美語例句
            ex = [l, '', '']                    # workaround for addsplt
            state = 'a'
            continue
        if state == 'ea':                       # 漢文例句
            ex[2] = l
            examples.append(addsplt(ex))
            state = 'd'
            continue
        if state == 'l':                        # 相關詞
            link.append(l[2:])
            state = 'd'

    if title:
        num_words += 1
        defdic = mkdef(defi, examples, link )
        if len(defdic) > 0:
            definitions.append(defdic)
        mkword(title, definitions, tag, stem)
    fp.close()
    print 'Total %d words in %s' % (num_words, fn)

if __name__ == '__main__':
    import glob
    import json
    import re
    import codecs
    for fn in glob.iglob('*.txt'):
        print fn
        readdict(fn)
    f = codecs.open('dict-amis.json', mode='w', encoding='utf8')
    f.write(json.dumps(JSON.values(), indent=2, separators=(',', ':'), ensure_ascii = False, encoding="utf8"))
    f.close()
