import 'package:flutter/material.dart';
import 'package:kyoai_ring/Structure/authentication.dart'; // Google認証ロジック

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();

    return Scaffold(
      appBar: AppBar(title: const Text('ログイン')),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.login),
          label: const Text('Googleでログイン'),
          onPressed: () async {
            final user = await _authService.signInWithGoogle();
            if (user != null) {
              Navigator.pushReplacementNamed(context, '/homepage'); // ホーム画面へ遷移
            } else {
              // エラー通知 (例: SnackBar)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ログインに失敗しました。')),
              );
            }
          },
        ),
      ),
    );
  }
}
