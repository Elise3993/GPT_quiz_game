//import 'dart:convert';
//import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:gpt_word_quiz/resultpage.dart';

//多分変数とか受け取って入れておくとこ全部finalをつけるらしい
//継承したクラスでwiget.(変数名)で取り出せる
class GamePage extends StatefulWidget {
  const GamePage(
      {super.key,
      required this.inputText,
      required this.outputText,
      required this.gptText}); //引数を受け取る一つ目はよくわからんけど二つ目で変数を格納

  final String inputText; //ここに入る
  final String outputText;
  final String gptText;

  @override
  State<StatefulWidget> createState() => _GamePageState();
}

//上のやつを継承したクラス、画面を作るところ
class _GamePageState extends State<GamePage> {
  //String gptOutput = '';

  //final apiKey = 'YOUR_API_KEY';

  /*@override
  void initState() {
    super.initState();
    Future(() async {
      gptOutput = await callApiGameText(widget.inputText, widget.outputText);
      print(gptOutput);
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Game Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  widget.gptText, //ここにchatgptの文章を入れる予定、${変数名}で表示すればいいと思う
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ResultPage(
                            ans: 'same',
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 255, 156, 7),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      side: const BorderSide(
                          color: Color.fromARGB(255, 255, 156, 7), width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('${widget.inputText}である'),
                  ),
                  const SizedBox(width: 8), //空白みたいなやつ
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ResultPage(
                            ans: 'different',
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 255, 156, 7),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      side: const BorderSide(
                          color: Color.fromARGB(255, 255, 156, 7), width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('${widget.outputText}でない'),
                  )
                ],
              )),
            ),
            const Expanded(flex: 1, child: SizedBox(height: 16)),
          ],
        ),
      ),
    );
  }

  /*Future<String> callApiGameText(String apiText_1, String apiText_2) async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode(
        <String, dynamic>{
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              'role': 'user',
              'content':
                  '$apiText_1と似た一般名詞を一つ出力せよ' //$apiText_1の説明を書くこと。$apiText_1と$apiText_2を出力に入れないこと。どちらの単語かわからないようにすること。60トークン以上80トークン以下で出力
            }
          ]
        },
      ),
    );
    final body = response.bodyBytes;
    final jsonString = utf8.decode(body);
    final json = jsonDecode(jsonString);
    final choices = json['choices'];
    final content = choices[0]['message']['content'];
    print(content);
    return content;
  }*/
}
