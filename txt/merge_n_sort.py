################################################################
# Module: merge_n_sort
# Merge 2 sorted dictionaries into one.
# - Items in dictionary must be saperated by "\n\n",
# - The first line in item will be taken as the word to compare.
# - Dismiss "'" character
################################################################
from sys import argv

def tokenize(content):
    l = content.strip().split("\n\n")
    if "" in l: l.remove("")
    l = [i.strip() for i in l]

    ll = []
    for item in l:
        tmp = item.strip().split('\n')[0].replace('\'', '')
        if '(' in tmp: 
            tmp = tmp[:tmp.find('(')].strip()
        ll.append(tmp)

    #ll = [item.strip().split('\n')[0] for item in l]
    #print ll
    return (ll, l) 

def output_res(fd, content):
    fd.write(content)
    fd.write("\n\n")

def compare(word1, word2):
    print word1
    print word2
    print "-------"
    ptr1 = 0
    ptr2 = 0
    len1 = len(word1)
    len2 = len(word2)
    
    if word1[ptr1] == '\'': ptr1 += 1
    if word2[ptr2] == '\'': ptr2 += 1
    
    while True:
        
        fail = False

        # word2 > word1
        if len1 <= ptr1:
            if len2 <= ptr2: return 0
            else: return 1
        # word2 > word1
        if len2 <= ptr2: return -1 
       
        if word1[ptr1] == '\'': 
            ptr1 += 1
            fail = True
        if word2[ptr2] == '\'': 
            ptr2 += 1
            fail = True
        if fail: continue

        if word1[ptr1] < word2[ptr2]: return 1 
        elif word1[ptr1] > word2[ptr2]: return -1
        else:
            ptr1 += 1
            ptr2 += 1

if __name__ == '__main__':
    if len(argv) < 4:
        print('usage: python %s [file1] [file2] [out file]' % argv[0])
        exit(0)

    f1 = argv[1]
    f2 = argv[2]
    outf = argv[3]

    fd1 = open(f1, "r")
    fd2 = open(f2, "r")
    fdout = open(outf, "w")

    content1 = fd1.read()
    content2 = fd2.read()
    fd1.close()
    fd2.close()

    (keys1, tokens1) = tokenize(content1)
    (keys2, tokens2) = tokenize(content2)
    

#    print keys1
#    print keys2

    idx1 = 0    
    idx2 = 0
    tlen1 = len(keys1)
    tlen2 = len(keys2)
    
    while True:
        if idx1 >= tlen1: break;
        if idx2 >= tlen2: break;

        res = cmp( keys1[idx1], keys2[idx2] )
        print "%s | %s" %(keys1[idx1], keys2[idx2])
        #res = compare( keys1[idx1], keys2[idx2] )
        if res <= 0:
            print "output 1"
            print tokens1[idx1]
            output_res(fdout, tokens1[idx1])
            idx1 += 1
            if res == 0:
                print "dup: %s" % keys2[idx2]
                idx2 += 1
        elif res > 0:
            print "output 2"
            print tokens2[idx2]
            output_res(fdout, tokens2[idx2])
            idx2 += 1
           

        print "------"

    while idx1 < tlen1:
        output_res(fdout, tokens1[idx1])
        idx1 += 1 
    while idx2 < tlen2:
        output_res(fdout, tokens2[idx2])
        idx2 += 1 

    fdout.close()

