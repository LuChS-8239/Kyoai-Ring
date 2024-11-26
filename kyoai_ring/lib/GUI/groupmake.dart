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

  void createGroup() {
    if (_groupNameController.text.isNotEmpty){
      _database.child('groups').push().set({
        'name': _groupNameController.text,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      });
      _groupNameController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NoTitle'),
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
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.velocity.pixelsPerSecond.dx < 0) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 54, 244, 165),
          title: const Text('グループ作成'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // グループ名入力欄（グループ作成用）
                  const TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'グループ名を入力',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      // グループ追加ボタンの処理
                    },
                    child: const Text('追加'),
                  ),
                  // グループリスト表示部分
                  Expanded(  // ListView.builderをExpandedでラップ
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
            ),
          ],
        ),
      ),
    );
  }
}
