import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String?> callAPIHiraToKanji(String message) async {
  var url = Uri.parse(
      'http://www.google.com/transliterate?langpair=ja-Hira|ja&text=$message,');

  var response = await http.get(url);

  if (response.statusCode == 200) {
    // リクエストが成功した場合の処理
    print('Response data: ${response.body}');
  } else {
    // リクエストが失敗した場合の処理
    print('Request failed with status: ${response.statusCode}');
  }

  return setResponce(response.body);
}

String? setResponce(var apiResponce) {
  try {
    var jsonResponse = jsonDecode(apiResponce);
    // JSONデータから必要な情報を取得
    var translatedText =
        jsonResponse[0][1][0]; //[0][1][0-5]に変換候補が入る。5個未満のときもある。

    return translatedText;
  } catch (e) {
    print('Error decoding JSON: $e');
    // JSONデコードエラーの場合に適切な処理を行う
  }
  return null;
}
