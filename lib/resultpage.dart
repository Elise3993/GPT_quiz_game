import 'package:flutter/material.dart';

//多分変数とか受け取って入れておくとこ全部finalをつけるらしい
//継承したクラスでwiget.(変数名)で取り出せる
class ResultPage extends StatefulWidget {
  const ResultPage({super.key, required this.ans});

  final String ans; //どっちを選択したかの情報、仮でsame/differentがStringで返ってくる

  @override
  State<StatefulWidget> createState() => _ResultPageState();
}

//上のやつを継承したクラス、画面を作るところ
class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Result Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const Expanded(flex: 1, child: SizedBox(height: 16)),
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  '選択された方：${widget.ans}', //ここで正解不正解を表示
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
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
}
