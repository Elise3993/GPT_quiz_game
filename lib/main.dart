import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

import 'env/env.dart';
import 'gamepage.dart';

void main() {
  runApp(const MyApp());
}

//ツリーの一番上になるところ。よくわかってない
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Association Game',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 57, 162, 134)),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Association Game Page'));
  }
}

//多分変数とか受け取って入れておくとこ全部finalをつけるらしい
//継承したクラスでwiget.(変数名)で取り出せる
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//上のやつを継承したクラス、画面を作るところ
class _MyHomePageState extends State<MyHomePage> {
  String textInput = '';
  String textOutput = '';
  bool _isLoading = false; // ローディングインジケータの表示状態を管理
  final apiKey = Env.key; //APIキー

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).colorScheme.inversePrimary, //多分MyAppから色とってきてる
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Expanded(
              //Expandedは余白の割り当てみたいなやつ
              flex: 1, //ぜんぶのExpandでflex:flex:flexの比率で割り当てられる
              child: Center(
                //ここでは１：１：１
                child: Text(
                  '単語を入力してね', //ここに文字${変数名}で変数を表示できる
                  style: TextStyle(
                      //文字の色とか大きさとか。条件分岐、変数で扱うこともできるらしい
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
              ),
              
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: TextField(
                  //入力できるやつ
                  onChanged: (text) {
                    //入力があった時に実行textに格納
                    setState(() {
                      textInput = text;
                    });
                  },
                  decoration: const InputDecoration(
                    //枠とか文字とか
                    labelText: '入力してください',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            const Expanded(flex: 1, child: SizedBox(height: 16)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading ? null : () async {
          // ChatGPTのAPIを利用
          setState(() {
            _isLoading = true; // リクエスト開始時にローディングインジケータを表示
          });
          // GPTから類似の単語を取得
          var textOutput = await callAPI(textInput);
          // プレイヤーが入力した単語、GPTが出力した単語のどちらかをランダムに選択する
          var textAns= chooseWord(textInput, textOutput);
          // GPTからtextAnsについて説名してもらう
          var chatGPTText = await callApiGameText(textInput, textOutput,textAns);

          setState(() {
            FocusScope.of(context).unfocus();
            _isLoading = false; // リクエスト開始時にローディングインジケータを表示
          });
          //ボタンを押したら画面遷移
          Navigator.push(
            //画面はスタックになっていて重ねていくらしい
            context, //使い方はNavigetorで調べたらすぐわかると思う
            MaterialPageRoute(
              builder: (context) => GamePage(
                  inputText: textInput, //引数入れてコンストラクタで実行。引数を次のページで格納
                  outputText: textOutput,
                  ansText: textAns,
                  gptText: chatGPTText),
            ),
          );
        },
        child: const Icon(Icons.navigate_next),
      ),
      // ぐるぐるを表示する条件に応じて、この位置を調整することも可能です。
      // 例えば、`floatingActionButtonLocation` を `FloatingActionButtonLocation.endFloat` にすると、画面下部にぐるぐるが表示されます。
      // デフォルトは `FloatingActionButtonLocation.endFloat` です。
      persistentFooterButtons: _isLoading
          ? [
              // ローディング中はぐるぐるを表示
              CircularProgressIndicator(),
            ]
          : null,
    );
  }


  Future<String> callAPI(String apiText) async {
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
            {'role': 'user', 'content': '$apiTextと似た一般名詞を一つ出力せよ'}
          ]
        },
      ),
    );
    final body = response.bodyBytes;
    final jsonString = utf8.decode(body);
    final json = jsonDecode(jsonString);
    final choices = json['choices'];
    final content = choices[0]['message']['content'];

    return content;
  }

  Future<String> callApiGameText(String apiText_1, String apiText_2,String ansText) async {
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
                  '$ansTextの説明を書くこと。$apiText_1と$apiText_2を出力に入れないこと。どちらの単語かわからないようにすること。60トークン以上80トークン以下で出力'
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
  }

  // プレイヤーが入力した単語と
  // GPTが出力した単語の
  // 2種類の内のどちらか選ぶ
  String chooseWord(String inputText,String outputText){
    var random = math.Random();

    String ansText = ""; 
    if(random.nextBool()) ansText = inputText; 
    else ansText = outputText;

    return ansText;
  }

}
