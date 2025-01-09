import 'package:flutter/material.dart';
import 'loginui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class IconSelectionScreen extends StatefulWidget {
  const IconSelectionScreen({super.key});

  @override
  State<IconSelectionScreen> createState() => _IconSelectionScreenState();
}

class _IconSelectionScreenState extends State<IconSelectionScreen> {
  final List<String> _iconPaths = [
    'assets/icons/icon1.jpeg',
    'assets/icons/icon2.jpeg',
    'assets/icons/icon3.jpeg',
  ];

  String _selectedIcon = ''; // 現在選ばれているアイコンのパス

  @override
  void initState() {
    super.initState();
    _loadUserIcon(); // 初期表示時にアイコンをロード
  }

  // Firebaseから現在のユーザーアイコンをロード
  Future<void> _loadUserIcon() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      // Realtime Databaseからユーザー情報を取得
      final snapshot = await FirebaseDatabase.instance.ref('users/$userId/icon').get();
      if (snapshot.exists) {
        setState(() {
          _selectedIcon = snapshot.value as String;
        });
      }
    } catch (e) {
      print('エラー: $e');
    }
  }

  // アイコンを選択して保存
  Future<void> _selectIcon(String iconPath) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      // データベースにアイコンを保存
      await FirebaseDatabase.instance.ref('users/$userId').update({'icon': iconPath});

      setState(() {
        _selectedIcon = iconPath;
      });
    } catch (e) {
      print('エラー: $e');
    }
  }

  // ログアウト処理
  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('アイコン選択')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_selectedIcon.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: ClipOval(
                      child: Image.asset(
                        _selectedIcon,
                        width: 100.0,
                        height: 100.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                if (user != null) ...[
                  Text('名前: ${user.displayName ?? '匿名'}', style: const TextStyle(fontSize: 18)),
                  Text('メールアドレス: ${user.email ?? '未設定'}', style: const TextStyle(fontSize: 18)),
                ],
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: _iconPaths.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _selectIcon(_iconPaths[index]);
                    Navigator.pop(context); // 選択後に戻る場合
                  },
                  child: Image.asset(_iconPaths[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => _logout(context),
              child: const Text('ログアウト'),
            ),
          ),
        ],
      ),
    );
  }
}