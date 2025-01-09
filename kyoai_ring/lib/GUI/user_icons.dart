import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'icon_manager.dart'; // IconManagerをインポート
import 'profile_options.dart'; // アイコン選択画面をインポート

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({required this.title, Key? key}) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  void initState() {
    super.initState();
    _loadUserIcon();
  }

  Future<void> _loadUserIcon() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final userRef = FirebaseDatabase.instance.ref('users/$userId');
      final snapshot = await userRef.get();

      if (snapshot.exists && snapshot.value is Map) {
        final data = snapshot.value as Map;
        IconManager.selectedIcon.value = data['icon'] ?? '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title),
      actions: [
        GestureDetector(
          onTap: () async {
            final updatedIcon = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IconSelectionScreen(),
              ),
            );

            if (updatedIcon != null && updatedIcon is String) {
              IconManager.selectedIcon.value = updatedIcon;
            }
          },
          child: ValueListenableBuilder<String>(
            valueListenable: IconManager.selectedIcon,
            builder: (context, iconPath, child) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: iconPath.isNotEmpty
                    ? ClipOval(
                  child: Image.asset(
                    iconPath,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                )
                    : const Icon(Icons.person, size: 40),
              );
            },
          ),
        ),
      ],
    );
  }
}
