import 'package:flutter/material.dart';
import 'package:flutter_application_1/groupmake.dart';
import 'package:flutter_application_1/select.dart'; // グループ作成用のページをインポート

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Center(child: const Text('Kyoai Ring')), // タイトルを中央に配置
      ),
      body: Stack(
        children: [
          // 1つ目のボタン
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
                      builder: (context) => Select(), // グループ選択画面へ遷移
                    ),
                  );
                },
                child: Text('グループ選択'),
              ),
            ),
          ),
          // 2つ目のボタン
          Align(
            alignment: Alignment(0.0, 0.3), // 真ん中より少し下に配置
            child: SizedBox(
              width: 200, // ボタンの幅
              height: 100, // ボタンの高さ
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupMake(), // グループ作成画面へ遷移
                    ),
                  );
                },
                child: Text('グループ作成'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}