import 'package:flutter/material.dart';
import 'package:kyoai_ring/GUI/selectnext.dart'; // SelectNextページをインポート

class Select extends StatelessWidget {
  const Select({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}