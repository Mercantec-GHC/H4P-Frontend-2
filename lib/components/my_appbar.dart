import 'package:flutter/material.dart';
import "../pages/edit_profile_page.dart";
import "../pages/home_page.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "../pages/login_page.dart";

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isHomePage;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.isHomePage = false,
  }) : super(key: key);

  void _logout(BuildContext context) async {
    final storage = FlutterSecureStorage();

    await storage.deleteAll();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFcacdce),
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF333333),
        ),
      ),
      leading: isHomePage
          ? null // Don't show the home button on the homepage
          : IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'logout') {
              _logout(context);
            } else if (value == 'editProfile') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfilePage()),
              );
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem<String>(
                value: 'editProfile',
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 8),
                    Text('Edit Profile'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ];
          },
        ),
      ],
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
