import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'user_icons.dart';

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

  // メッセージを送信する処理
  void _sendMessage() async {
    final message = _messageController.text.trim();
    final user = _auth.currentUser;

    if (user == null) {
      // ログインしていない場合、警告を表示
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ログインしてください。')),
      );
      return;
    }

    if (message.isNotEmpty) {
      try {
        await _database
            .child('groups')
            .child(widget.groupName)
            .child('messages')
            .push()
            .set({
          'text': message,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'senderName': user.displayName ?? '匿名',
          'senderUid': user.uid,
        });
        _messageController.clear(); // 入力欄をクリア
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('送信失敗: $error')),
        );
      }
    }
  }

  // タイムスタンプをフォーマット
  String formatTimestamp(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal();
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }

  // メッセージリストを構築
  Widget _buildChatMessage(Map messageData, bool isOwnMessage) {
    return Align(
      alignment: isOwnMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: isOwnMessage ? Colors.blueAccent : Colors.grey[300],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isOwnMessage)
                Row(
                  children: [
                    // 発言者のアイコン
                    FutureBuilder(
                      future: _getUserIcon(messageData['senderUid']), // アイコンを取得
                      builder: (context, AsyncSnapshot<String?> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        final iconName = snapshot.data ?? ''; // アイコン名
                        return CircleAvatar(
                          backgroundImage: iconName.isNotEmpty
                              ? AssetImage('$iconName')  // アプリ内のアイコンフォルダから選択
                              : const AssetImage('assets/default_icon.png'),  // デフォルトアイコン
                          radius: 20.0,
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    Text(
                      messageData['senderName'] ?? '匿名',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              Text(messageData['text'] ?? ''),
              Text(
                formatTimestamp(messageData['timestamp']),
                style: TextStyle(fontSize: 10.0, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ユーザーのアイコンを取得するメソッド
  Future<String?> _getUserIcon(String userId) async {
    final snapshot = await _database.child('users/$userId/icon').once();
    if (snapshot.snapshot.value != null) {
      return snapshot.snapshot.value as String?;
    }
    return null; // アイコンがなければnullを返す
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '${widget.groupName}のチャット'),
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
                if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
                  return const Center(child: Text('メッセージがありません。'));
                }

                // FirebaseのデータをMapとして取得
                final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                final messages = data.entries.map((entry) {
                  return {
                    'key': entry.key,
                    ...entry.value as Map<dynamic, dynamic>,
                  };
                }).toList();

                // タイムスタンプでソート
                messages.sort((a, b) =>
                    (a['timestamp'] as int).compareTo(b['timestamp'] as int));

                final user = _auth.currentUser;

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isOwnMessage = message['senderUid'] == user?.uid;
                    return _buildChatMessage(message, isOwnMessage);
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
