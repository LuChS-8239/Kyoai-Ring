import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart'; // DateFormatを使用するためのimport

class ChatScreen extends StatefulWidget {
  final String groupName;
  const ChatScreen({super.key, required this.groupName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _sendMessage() async {
    final message = _messageController.text.trim();
    final user = _auth.currentUser;

    if (user == null) {
      // ログインしていない場合、エラーメッセージを表示して送信を中止
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ログインしてください。')),
      );
      return;
    }

    if (message.isNotEmpty) {
      _database
          .child('groups')
          .child(widget.groupName)
          .child('messages')
          .push()
          .set({
        'text': message,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'senderName': user.displayName ?? '匿名',
        'senderUid': user.uid,
      }).then((_) {
        _messageController.clear();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('送信失敗: $error')),
        );
      });
    }
  }

  String sanitizeMessage(String message) {
    return message
        .replaceAll('.', '_')
        .replaceAll('#', '_')
        .replaceAll('\$', '_')
        .replaceAll('[', '_')
        .replaceAll(']', '_');
  }

  String formatTimestamp(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal();
    return DateFormat('yyyy-MM-dd HH:mm').format(date); // 年-月-日 時:分
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.groupName} のチャット'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _database
                  .child('groups')
                  .child(widget.groupName)
                  .child('messages')
                  .orderByChild('timestamp')
                  .onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('エラーが発生しました。'));
                }
                if (!snapshot.hasData ||
                    snapshot.data?.snapshot.value == null) {
                  return const Center(child: Text('メッセージがありません。'));
                }

                // FirebaseのデータをMapとして取得
                final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                final messages = data.entries
                    .map((entry) => {
                  'key': entry.key,
                  ...entry.value as Map<dynamic, dynamic>,
                })
                    .toList();

                // タイムスタンプでソート
                messages.sort((a, b) =>
                    (a['timestamp'] as int).compareTo(b['timestamp'] as int));

                final user = _auth.currentUser; // 現在のユーザーを取得

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isOwnMessage = message['senderUid'] == user?.uid;

                    return Align(
                      alignment: isOwnMessage
                          ? Alignment.centerRight // 自分のメッセージは右寄せ
                          : Alignment.centerLeft, // 他者のメッセージは左寄せ
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 10.0,
                          ),
                          decoration: BoxDecoration(
                            color: isOwnMessage
                                ? Colors.blueAccent
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!isOwnMessage)
                                Text(
                                  message['senderName'] ?? '匿名', // 発言者名
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              Text(message['text'] ?? ''),
                              Text(
                                formatTimestamp(message['timestamp']),
                                style: TextStyle(
                                  fontSize: 10.0,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // メッセージ入力部分
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'メッセージを入力',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _sendMessage,
                  child: const Text('送信'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
