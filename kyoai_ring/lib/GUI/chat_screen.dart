import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatScreen extends StatefulWidget {
  final String groupName;
  const ChatScreen({super.key, required this.groupName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      _database
          .child('groups')
          .child(widget.groupName)
          .child('messages')
          .push()
          .set({
        'text': message,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
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

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return ListTile(
                      title: Text(message['text'] ?? ''),
                      subtitle: Text(
                        DateTime.fromMillisecondsSinceEpoch(
                            message['timestamp'])
                            .toLocal()
                            .toString(),
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
