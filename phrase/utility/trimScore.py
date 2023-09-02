import json

# 形態素解析され単語ごとに分割された日本語のテキストを結合する
# ただし、一番目の要素は無視する
# また、"？"と"！"は空文字に置換する
# "は"は"わ"に変換する
def concatenate_json_elements(json_file_path):
    try:
        with open(json_file_path, 'r', encoding='utf-8') as file:

            data = json.load(file)

            if len(data) < 2:
                return "JSONデータに十分な要素が含まれていません。"

            elements_to_concatenate = data[1:]
            result_elements = []

            for element in elements_to_concatenate:
                modified_element = element.replace("?", "").replace("!", "")
                modified_element = modified_element.replace("は", "わ")
                modified_element = modified_element.replace("君", "きみ")
                result_elements.append(modified_element)

            result_string = ''.join(result_elements)

            return result_string
    except Exception as e:
        return str(e)
