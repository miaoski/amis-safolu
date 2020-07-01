# 建立字典檔

辭典檔案在： [txt/dict-amis.json](https://github.com/miaoski/amis-safolu/blob/master/txt/dict-amis.json)

## 指令

需要配合 amis-moedict repo 裡的指令執行。

```
$ git clone git@github.com:g0v/amis-moedict.git amis-moedict
$ git clone git@github.com:miaoski/amis-safolu.git amis-safolu # 以上兩個 repo 資料夾請放到同一個目錄下
$ cd amis-moedict
$ ln -sf ../amis-safolu/txt/dict-amis-safolu.json dict-amis-safolu.json
$ node json2prefix.js s
$ node autolink.js s > s.txt
$ perl link2pack.pl s < s.txt
$ cp ../amis-safolu/txt/index.json           s/index.json
$ python ../amis-safolu/txt/revdict.py
$ mv revdict-*.txt                           s/
$ cp ../amis-safolu/txt/amis-ch-mapping.json s/ch-mapping.json
$ ruby ../amis-safolu/txt/stem-mapping.rb
$ cp ../amis-safolu/tmp/amis-stem-words.json s/stem-words.json
```
