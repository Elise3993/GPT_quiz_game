import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  final apiKey = 'YOUR_API_KEY';

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
                  'お題を入力してね', //ここに文字${変数名}で変数を表示できる
                  style: TextStyle(
                      //文字の色とか大きさとか。条件分岐、変数で扱うこともできるらしい
                      fontSize: 24,
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
        onPressed: () async {
          var textOutput = await callAPI(textInput);
          //ボタンを押したら画面遷移
          Navigator.push(
            //画面はスタックになっていて重ねていくらしい
            context, //使い方はNavigetorで調べたらすぐわかると思う
            MaterialPageRoute(
              builder: (context) => GamePage(
                inputText: textInput, //引数入れてコンストラクタで実行。引数を次のページで格納
                outputText: textOutput,
              ),
            ),
          );
        },
        child: const Icon(Icons.navigate_next),
      ),
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
}
