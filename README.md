# amis-safolu 阿美語萌典—蔡中涵大辭典 字典檔

## Warning for Deprecated Repo
蔡中涵字典的來源已經改到 https://github.com/g0v/amis-moedict/tree/master/docs/s 了。最新的修改必須從那個 repo 取得。
因此本 repo 的內容在 2022.3.20 之後 freeze 。造成不便敬請原諒。

## 環境

* Ruby v2.6+
* bundler v2.0.1
* ActiveRecord v6.0.3.2
* SQLite3

## 轉換 docx 到 html

透過 https://soffice.sheethub.net 轉換 docx 到 html。

```
$ cd tmp/docx目錄
$ ruby ../../docx-to-html.rb
```

## 轉換 html 存到 sqlite

需要依序執行。

```
$ ruby parsing.rb # 從 html 存到 RawContent
$ ruby parsing-terms.rb # 從 RawContent 建立單詞和詞幹
$ ruby parsing-content.rb # 從 RawContent 建立定義、例句和關連詞
$ ruby clean-dummy-in-db.rb # 將資料庫裡的已知垃圾資訊清除
```

## 從 sqlite 產生 json 單詞檔案

需要依序執行。

```
$ ruby generate-moedict-json.rb # 產生阿美語萌典需要的 json
$ ruby generate-ufff-code-to-example.rb # 將 \ufff9, \ufffa, \ufffb 加入例句
$ ruby link-json-to-terms.rb # 將定義、例句和關連詞的內容，用 `~ 包住，連結到對應詞
$ ruby generate-json-from-sqlite.rb # 產生單詞 json 檔案
```

## 操作 model table

使用 ActiveRecord gem 來操作，目前專案使用 v6.0.1，相關指令放在 Rakefile。

```
$ rake g:migration YOUR_MIGRATION
$ rake db:migrate
$ rake db:rollback
$ rake db:schema
```

使用 Annotate gem 的指令，將 table schema 更新到 model 檔案裡。

```
$ annotate --models --model-dir models
```

# 致謝

感謝 cpyang 將 PDF 原稿轉為 TXT 檔。

舊版說明請看 [PREV_README](PREV_README.md)

# License

蔡中涵委員 g0v 阿美語萌典計劃使用本字典，以 CC BY-NC 授權宣告。
