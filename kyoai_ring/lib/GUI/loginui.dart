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
            // Google認証を実行
            final user = await _authService.signInWithGoogle();
            if (user != null) {
              // メールアドレスのドメインを確認
              final email = user.email ?? '';
              if (email.endsWith('@c.kyoai.ac.jp')) {
                // ドメインが一致すればホーム画面へ遷移
                Navigator.pushReplacementNamed(context, '/homepage');
              } else {
                // ドメインが一致しない場合、エラーメッセージを表示
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('このメールアドレスではログインできません。')),
                );
              }
            } else {
              // ログイン失敗の場合
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
