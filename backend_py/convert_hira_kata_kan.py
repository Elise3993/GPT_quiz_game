import pykakasi

kanjis = ['東京', '横浜']



def convert_str(input_word):
    kks = pykakasi.kakasi()
    result = kks.convert(input_word)
    print(result[0]['kana'])

convert_str("とうきょう")