import 'package:flutter/material.dart';

class selectnext extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 233, 13, 167),
          title: const Text('4')),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft, // ボタンを左上に配置
            child: Padding(
              padding: const EdgeInsets.all(16.0), // 余白を追加
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                }, // ボタンを押すと戻る
                child: const Text('戻る'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//import 'package:flutter/material.dart';

class SelectNext extends StatefulWidget {
  @override
  _SelectNextState createState() => _SelectNextState();
}

class _SelectNextState extends State<SelectNext> {
  // メッセージを管理するリスト
  List<String> messages = [];
  // テキストコントローラ
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // メッセージを送信する関数
  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        // 入力されたメッセージを追加
        messages.add(_controller.text);
      });
      // 入力フィールドをクリア
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 233, 13, 167),
        title: const Text('4'),
      ),
      body: Column(
        children: [
          Expanded(
            // メッセージリスト表示部分
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Align(
                    alignment: Alignment.centerRight, // メッセージを右寄せに
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(messages[index]),
                    ),
                  ),
                );
              },
            ),
          ),
          // SNSのチャット風の入力欄
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'メッセージを入力してください',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage, // メッセージ送信ボタン
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
