from sys import argv

if __name__ == '__main__':
    
    with open(argv[1], "r") as fd:
        items = fd.read().split("\n\n")
        if "" in items: items.remove("")
        
        item_dict = {}
        keys = []
        for i in items:
            tmp = i.split('\n')[0].replace('\'', '').replace('^', '').lower()
            if "(" in tmp: 
                tmp = tmp[:tmp.find("(")]
                tmp = tmp.strip()
            if tmp not in keys: 
                keys.append(tmp)
                item_dict[tmp] = i.strip()

        #print keys

        skeys = sorted(keys)

        for k in skeys:
            if k == "": continue
            print k
            print item_dict[k]
            print ""

    fd.close()
