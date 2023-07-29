import 'package:flutter/material.dart';

//多分変数とか受け取って入れておくとこ全部finalをつけるらしい
//継承したクラスでwiget.(変数名)で取り出せる
class ResultPage extends StatefulWidget {
  const ResultPage(
      {super.key,
      required this.isCorrect,
      required this.inputText,
      required this.outputText,
      required this.ansText});

  final bool isCorrect;
  final String inputText; // プレイヤーが入力した単語
  final String outputText; // GPTが出力した単語
  final String ansText; // 選択された単語

  @override
  State<StatefulWidget> createState() => _ResultPageState();
}

//上のやつを継承したクラス、画面を作るところ
class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('あそワード'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Center(
                child: ifResult(widget.isCorrect),
              ),
            ),
            // ここより以下マジで適当なのでUI考える人よろしくお願いします
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black38,
                    width: 4,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'あなたが入力した単語 : ${widget.inputText}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'GPTが出力した単語 : ${widget.outputText}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'GPTが説明した単語 : ${widget.ansText}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                  child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil(((route) => route.isFirst));
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 255, 156, 7),
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                  side: const BorderSide(
                      color: Color.fromARGB(255, 255, 156, 7), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('リトライ'),
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget ifResult(bool isCorrect) {
    if (isCorrect) {
      return const Text(
        '正解!!', //ここで正解不正解を表示
        style: TextStyle(
          fontSize: 80,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      );
    } else {
      return const Text(
        '不正解...', //ここで正解不正解を表示
        style: TextStyle(
          fontSize: 80,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      );
    }
  }
}
