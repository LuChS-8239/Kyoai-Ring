import 'package:flutter/material.dart';
import 'package:test/selectnext.dart'; // SelectNextページをインポート

class Select extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.red, title: const Text('グループを選ぶ')),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft, // 左上に配置
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // 戻るアクション
                },
                child: const Text('戻る'),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight, // 右下に配置
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectNext(), // SelectNextページに遷移
                    ),
                  );
                },
                child: const Text('次へ'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
