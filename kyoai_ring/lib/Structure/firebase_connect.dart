import 'package:firebase_database/firebase_database.dart';

Future<void> sendMessage(String text, String userId) async {
  DatabaseReference messagesRef = FirebaseDatabase.instance.ref("messages");
  
  await messagesRef.push().set({
    'text': text,
    'userId': userId,
    'timestamp': DateTime.now().millisecondsSinceEpoch,
  });
}