import "package:flutter/material.dart";
import "login_page.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "home_page.dart";

class CreateChallengePage extends StatelessWidget {
  const CreateChallengePage({super.key});

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
    return Scaffold(
      backgroundColor: Color(0xFF6cbabc),
      appBar: AppBar(
        backgroundColor: Color(0xFFcacdce),
        title: Text(
          'Hjælp! Jeg er en fisk?',
          style: TextStyle(
            color: Color(0xFF333333),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF333333)),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _logout(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: const [
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
      ),
    );
  }
}
