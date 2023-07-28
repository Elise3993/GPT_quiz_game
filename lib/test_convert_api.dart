import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _textController = TextEditingController();
  String _katakana = '';
  String _furigana = '';

  void _callPythonAPI() async {
    final apiUrl = 'http://127.0.0.1:5000/convert'; // ローカルホストの場合
    final data = {'text': _textController.text};

    final response = await http.post(Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"}, body: json.encode(data));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      print(response.body);
      print(result);
      setState(() {
        _katakana = result['katakana'];
        _furigana = result['hiragana'];
      });
    } else {
      print("エラー: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('ふりがな・カタカナ変換'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _textController,
                decoration: InputDecoration(labelText: 'テキストを入力'),
              ),
              ElevatedButton(
                onPressed: _callPythonAPI,
                child: Text('変換する'),
              ),
              SizedBox(height: 20),
              Text('カタカナ: $_katakana'), // カタカナの変換結果を表示
              Text('ふりがな: $_furigana'), // ふりがなの変換結果を表示
            ],
          ),
        ),
      ),
    );
  }
}
