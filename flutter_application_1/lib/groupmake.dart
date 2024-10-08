import 'package:flutter/material.dart';

class GroupMake extends StatefulWidget {
  @override
  _GroupMakeState createState() => _GroupMakeState();
}

class _GroupMakeState extends State<GroupMake> {
  final TextEditingController _controller = TextEditingController();
  String _inputText = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addGroup() {
    setState(() {
      _inputText = _controller.text;
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.velocity.pixelsPerSecond.dx < 0) {
          // 左スワイプの処理
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 54, 244, 165),
          title: const Text('3'),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(),
            ),
            // 下部に入力フィールドと追加ボタン
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'グループ名を入力',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _addGroup,
                    child: const Text('追加'),
                  ),
                  if (_inputText.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        '追加したグループ名: $_inputText',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}