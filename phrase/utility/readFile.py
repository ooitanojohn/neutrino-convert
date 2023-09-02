import json

def getText(file_path:str):
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            text_data = file.read()
            return text_data
    except FileNotFoundError:
        print(f"指定されたファイル '{file_path}' が見つかりません。")
        exit(1)
    except Exception as e:
        print(f"エラーが発生しました: {str(e)}")
        exit(1)

def getJson(json_file_path):
    try:
        with open(json_file_path, 'r', encoding='utf-8') as file:

            data = json.load(file)
            return data
    except FileNotFoundError:
        print(f"指定されたファイル '{json_file_path}' が見つかりません。")
        exit(1)
    except Exception as e:
        print(f"エラーが発生しました: {str(e)}")
        exit(1)