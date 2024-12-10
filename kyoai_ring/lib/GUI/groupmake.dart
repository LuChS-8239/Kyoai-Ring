import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class GroupMake extends StatefulWidget {
  const GroupMake({super.key});

  @override
  GroupMakeState createState() => GroupMakeState();
}

class GroupMakeState extends State<GroupMake> {
  final TextEditingController _groupNameController = TextEditingController();
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // グループ名をサニタイズする関数
  String sanitizeGroupName(String groupName) {
    return groupName
        .replaceAll('.', '_')
        .replaceAll('#', '_')
        .replaceAll('\$', '_')
        .replaceAll('[', '_')
        .replaceAll(']', '_');
  }

  void createGroup() {
    final groupName = sanitizeGroupName(_groupNameController.text);
    if (groupName.isNotEmpty) {
      _database.child('groups').child(groupName).once().then((snapshot) {
        if (snapshot.snapshot.value == null) {
          // グループが存在しない場合、新しく作成
          _database.child('groups').child(groupName).set({
            'name': groupName,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('グループ作成'),
      ),
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

class GroupListScreen extends StatefulWidget {
  const GroupListScreen({super.key});

  @override
  GroupListScreenState createState() => GroupListScreenState();
}

class GroupListScreenState extends State<GroupListScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  List<String> _groupNames = [];

  @override
  void initState() {
    super.initState();
    _fetchGroups();
  }

  // グループ情報を取得するメソッド
  void _fetchGroups() {
    _database.child('groups').onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        List<String> groups = [];
        data.forEach((key, value) {
          final groupName = value['name'] ?? 'Unnamed Group';
          groups.add(groupName);
        });
        setState(() {
          _groupNames = groups;
        });
      } else {
        print("データが存在しません");
      }
    }).onError((error) {
      print('データ取得エラー: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 54, 244, 165),
        title: const Text('グループ一覧'),
      ),
      body: Column(
        children: [
          // グループリスト表示部分
          Expanded(
            child: ListView.builder(
              itemCount: _groupNames.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_groupNames[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
