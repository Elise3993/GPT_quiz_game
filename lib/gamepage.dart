//import 'dart:convert';
//import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:gpt_word_quiz/resultpage.dart';
import 'dart:math' as math;

//多分変数とか受け取って入れておくとこ全部finalをつけるらしい
//継承したクラスでwiget.(変数名)で取り出せる
class GamePage extends StatefulWidget {
  const GamePage(
      {super.key,
      required this.inputText,
      required this.outputText,
      required this.ansText,
      required this.gptText}); //引数を受け取る一つ目はよくわからんけど二つ目で変数を格納

  final String inputText; // プレイヤーの入力ワード
  final String outputText; // GPTの出力ワード
  final String ansText; // 正解として選ばれたワード
  final String gptText; // GPTがansTextについて説明した文章

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

  // 伏字処理後のgptのテキスト
  String hidedGptText = "";

  // 次に送りたい変数
  late String _inputText; // プレイヤーの入力ワード
  late String _outputText; // GPTの出力ワード
  late String _ansText;

  @override
  void initState() {
    super.initState();

    _inputText = widget.inputText;
    _outputText = widget.outputText;
    _ansText = widget.ansText;

    // デバッグ用に表示
    print("GPTが出力した単語 : " + widget.outputText);
    print("答えの単語 : " + widget.ansText);
    //入力and出力単語隠し
    hidedGptText =
        hideKeyWord(widget.inputText, widget.outputText, widget.gptText);
  }

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
              flex: 4,
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  border: Border.all(
                    color: Colors.black38,
                    width: 4,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Center(
                      child: Text(
                        hidedGptText, //ここにchatgptの文章を入れる予定、${変数名}で表示すればいいと思う
                        style: const TextStyle(
                          fontSize: 24,
                          // fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                  ),
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
                          builder: (context) => ResultPage(
                            isCorrect: checkPlayersAnswer(_inputText, _ansText),
                            inputText: _inputText,
                            outputText: _outputText,
                            ansText: _ansText,
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
                          horizontal: 32, vertical: 24),
                      side: const BorderSide(
                          color: Color.fromARGB(255, 255, 156, 7), width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('${widget.inputText}である'),
                  ),
                  const SizedBox(width: 22), //空白みたいなやつ
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultPage(
                            isCorrect:
                                checkPlayersAnswer(_outputText, _ansText),
                            inputText: _inputText,
                            outputText: _outputText,
                            ansText: _ansText,
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
                          horizontal: 32, vertical: 24),
                      side: const BorderSide(
                          color: Color.fromARGB(255, 255, 156, 7), width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('${widget.inputText}でない'),
                  ),
                ],
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // GPTの説明テキスト中のキーワードをすべて***で隠す
  String hideKeyWord(String input_str, String output_str, String gptText) {
    final random = math.Random();
    final masks = ['***', '+++', '###', '!!!', '%%%', '&&&', '@@@'];
    final input_index = random.nextInt(masks.length);
    var output_index = random.nextInt(masks.length);
    while (input_index == output_index) {
      output_index = random.nextInt(masks.length);
    }
    var input_maskedText = gptText.replaceAll(input_str, masks[input_index]);
    return input_maskedText.replaceAll(output_str, masks[output_index]);
  }

  // 正誤チェックを行う
  // chosenTextはプレイヤーが選んだ選択の単語
  // ansTextはランダムに選ばれた正解の単語
  bool checkPlayersAnswer(String chosenText, String ansText) {
    return chosenText == ansText;
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
