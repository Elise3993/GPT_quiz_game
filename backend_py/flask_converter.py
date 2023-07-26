from flask import Flask, request, jsonify
import pykakasi

app = Flask(__name__)

def convert_str(input_word):
    kks = pykakasi.kakasi()
    result = kks.convert(input_word)
    return [result[0]['hira'],result[0]['kana']]

@app.route('/convert', methods=['POST'])
def convert_text():
    data = request.get_json()
    text = data.get('text', '')

    hiragana, katakana = convert_str(text)
    print(hiragana)
    print(katakana)
    result = {
        'hiragana': hiragana,
        'katakana': katakana,
    }

    return jsonify(result)

if __name__ == '__main__':
    app.run(port=5000, debug=True)



