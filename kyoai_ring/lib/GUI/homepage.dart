import 'package:flutter/material.dart';
import 'package:kyoai_ring/GUI/groupmake.dart';
import 'package:kyoai_ring/GUI/select.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Center(child: Text('Kyoai Ring')),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment(0.0, -0.3), // 真ん中より少し上に配置
            child: SizedBox(
              width: 200, // ボタンの幅
              height: 100, // ボタンの高さ
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Select(),
                    ),
                  );
                },
                child: const Text('グループ選択'),
              ),
            ),
          ),
          // 2つ目のボタン
          Align(
            alignment: const Alignment(0.0, 0.3), // 真ん中より少し下に配置
            child: SizedBox(
              width: 200, // ボタンの幅
              height: 100, // ボタンの高さ
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GroupMake(), // グループ作成画面へ遷移
                    ),
                  );
                },
                child: const Text('グループ作成'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}