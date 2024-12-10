import 'package:flutter/material.dart';
import 'GUI/homepage.dart';
import 'package:kyoai_ring/GUI/loginui.dart'; // Google認証サービス
import 'package:kyoai_ring/Structure/login.dart'; // ログイン画面
import 'package:firebase_core/firebase_core.dart';
import 'Structure/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kyori-Ring',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // 初期ルートをログイン画面に設定
      initialRoute: '/',
      routes: {
        '/': (context) =>  LoginScreen(),
        '/homepage': (context) => const Homepage(), // ログイン成功時に遷移
      },
    );
  }
}
