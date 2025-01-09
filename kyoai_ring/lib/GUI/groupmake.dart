import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'user_icons.dart';

class GroupMake extends StatefulWidget {
  const GroupMake({super.key});

  @override
  GroupMakeState createState() => GroupMakeState();
}

class GroupMakeState extends State<GroupMake> {
  final TextEditingController _groupNameController = TextEditingController();
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Firebaseで使用できない記号をリストにする
  static const List<String> _invalidCharacters = ['.', '#', '\$', '[', ']'];

  // グループ名にFirebaseで使えない記号が含まれていないか確認する
  bool _containsInvalidCharacters(String groupName) {
    for (var char in _invalidCharacters) {
      if (groupName.contains(char)) {
        return true;
      }
    }
    return false;
  }

  // グループ名をサニタイズする関数
  String sanitizeGroupName(String groupName) {
    return groupName
        .replaceAll('.', '_')
        .replaceAll('#', '_')
        .replaceAll('\$', '_')
        .replaceAll('[', '_')
        .replaceAll(']', '_');
  }

  // グループ作成処理（確認ダイアログを表示）
  void createGroup() async {
    final groupName = _groupNameController.text;

    // Firebaseで使用できない記号が含まれている場合はエラーを表示
    if (_containsInvalidCharacters(groupName)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('この名前のグループは作成できません。${_invalidCharacters.join(' ')} はグループ名に使用できません。'),
        ),
      );
      return; // グループ作成処理を中断
    }

    final sanitizedGroupName = sanitizeGroupName(groupName);
    if (sanitizedGroupName.isNotEmpty) {
      // 確認ダイアログの表示
      final shouldCreateGroup = await _showConfirmationDialog();
      if (shouldCreateGroup) { // nullの場合はfalseとみなす
        _database.child('groups').child(sanitizedGroupName).once().then((snapshot) {
          if (snapshot.snapshot.value == null) {
            // グループが存在しない場合、新しく作成
            _database.child('groups').child(sanitizedGroupName).set({
              'name': sanitizedGroupName,
              'createdAt': DateTime.now().millisecondsSinceEpoch,
              'timestamp': DateTime.now().millisecondsSinceEpoch,
            });
            _groupNameController.clear();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('グループが作成されました')));
          } else {
            // グループ名が既に存在する場合
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('このグループ名はすでに存在します')));
          }
        }).catchError((error) {
          print('エラー発生: $error');
        });
      }
    }
  }

  // 確認ダイアログを表示するメソッド
  Future<bool> _showConfirmationDialog() async {
    return (await showDialog<bool>(
      context: context,
      barrierDismissible: false, // ダイアログ外のタップで閉じないようにする
      builder: (context) {
        return AlertDialog(
          title: const Text('確認'),
          content: const Text('本当にグループを作成しますか？'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // いいえの場合
              },
              child: const Text('いいえ'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // はいの場合
              },
              child: const Text('はい'),
            ),
          ],
        );
      },
    )) ?? false; // nullの場合はfalseとみなす
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'グループ作成'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _groupNameController,
              decoration: const InputDecoration(
                labelText: 'グループ名を入力',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: createGroup,
              child: const Text('グループ作成'),
            ),
          ],
        ),
      ),
    );
  }
}