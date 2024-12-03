import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'chat_screen.dart';

class Select extends StatefulWidget {
  const Select({super.key});

  @override
  SelectState createState() => SelectState();
}

class SelectState extends State<Select> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  List<String> _groupNames = [];

  @override
  void initState() {
    super.initState();
    _fetchGroups();
  }

  // グループ名をFirebaseから取得するメソッド
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
        title: const Text('作成されたグループ'),
      ),
      body: ListView.builder(
        itemCount: _groupNames.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_groupNames[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(groupName: _groupNames[index]),
                ),
              );
            },

          );
        },
      ),
    );
  }
}
