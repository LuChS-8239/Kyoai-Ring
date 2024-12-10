import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Googleログイン
  Future<User?> signInWithGoogle() async {
    try {
      // Googleログインのフロー開始
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // キャンセルされた場合

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Firebase認証の資格情報を作成
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebaseログイン
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user; // ログイン成功時のユーザー情報
    } catch (e) {
      print('Googleログイン失敗: $e');
      return null;
    }
  }

  // ログアウト
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
