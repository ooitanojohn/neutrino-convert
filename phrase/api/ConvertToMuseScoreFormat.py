import json
import sys
sys.path.append('../')
from urllib import request
from utility import config

APPID = config.APP_ID
URL = "https://jlp.yahooapis.jp/MAService/V2/parse"

# Yahoo! Japan Web APIの形態素解析APIを利用して、日本語のテキストを解析する
# ひらがなのみの文字列を返す
def post(query : str, context: any = None):
    headers = {
        "Content-Type": "application/json",
        "User-Agent": "Yahoo AppID: {}".format(APPID),
    }
    param_dic = {
        "id": "1234-1",
        "jsonrpc": "2.0",
        "method": "jlp.maservice.parse",
        "params": {
            "q": query,
            "context": context,
        }
    }
    params = json.dumps(param_dic).encode()
    req = request.Request(URL, params, headers)
    with request.urlopen(req) as res:
        body = res.read()
    parsed_data = json.loads(body)

    # result.tokens配列から各要素の二番目の要素を取得し、空白で結合する
    tokens = parsed_data["result"]["tokens"]
    merge_string = ''.join([token[1] for token in tokens])

    # 促音・拗音・小書き文字の処理
    result_string = merge_string[0]
    for i in range(1, len(merge_string)):
        if merge_string[i] in ('ゃ', 'ゅ', 'ょ', 'っ'):
            result_string += merge_string[i]
        else:
            result_string += ' ' + merge_string[i]
    return result_string