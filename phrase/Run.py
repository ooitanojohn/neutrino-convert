import sys
from utility import readFile, trimScore, config
from api import ConvertToMuseScoreFormat

# 第一引数に変換されたjsonのパスを指定
if len(sys.argv) < 2:
    print("テキストファイルのパスが提供されていません。")
    sys.exit(1)

text_data = trimScore.concatenate_json_elements(sys.argv[1])

# 追加の楽譜文字変換情報は省略可能
if len(sys.argv) == 3:
    json_file_path = sys.argv[2]
    json_data = readFile.getJson(json_file_path)
else:
    json_data = {"entries": []}

# musescoreに貼り付けられる形式の文字列を取得
response = ConvertToMuseScoreFormat.post(text_data, json_data)
print(response)
