import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

Future<void> saveUserData(String iconPath) async {
  try {
    // 現在ログイン中のユーザーIDを取得
    final userId = FirebaseAuth.instance.currentUser!.uid;

    // Realtime Databaseのインスタンスを取得
    final databaseRef = FirebaseDatabase.instance.ref();

    // データを保存
    await databaseRef.child('users/$userId').set({
      'icon': iconPath, // アイコンのパスまたはURL
      'updatedAt': DateTime.now().toIso8601String(), // 更新日時
    });
  } catch (e) {
    print('エラー: $e');
  }
}
