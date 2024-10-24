import 'package:flutter/material.dart';
import 'package:flutter_application_1/selectnext.dart'; // SelectNextページをインポート

class Select extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('グループ選択'),
      ),
      body: Stack(
        children: [
          GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.velocity.pixelsPerSecond.dx > 0) {
                // 右スワイプの処理
                Navigator.pop(context);
              }
            },
            child: Container(
              // 背景に色を追加して視覚的なエリアを持たせる
              color: Colors.transparent, // 背景を透明に設定
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