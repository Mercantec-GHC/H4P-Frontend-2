import "package:fiske_fitness_app/pages/create_challenge_page.dart";
import "package:flutter/material.dart";
import "login_page.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "../components/my_button.dart";

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<String> _getJwtToken() async {
    final storage = FlutterSecureStorage();
    String? jwt = await storage.read(key: 'jwt');
    return jwt ?? 'No jwt';
  }

  Future<String> _getUsername() async {
    final storage = FlutterSecureStorage();
    String? username = await storage.read(key: 'username');
    return username ?? 'Guest';
  }

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
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 560),
              MyButton(
                onTap: () => {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateChallengePage()),
                  ),
                },
                text: "Create Challenge",
              ),
            ],
          )),
          Positioned(
            top: kToolbarHeight - 40,
            left: 16,
            child: FutureBuilder<String>(
              future: _getJwtToken(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('Error loading username');
                } else {
                  return Text(
                    '${snapshot.data}',
                    style:
                        const TextStyle(fontSize: 16, color: Color(0xFF333333)),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}




/*
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<String> _getUsername() async {
    final storage = FlutterSecureStorage();
    String? username = await storage.read(key: 'username');
    return username ?? 'Guest';
  }

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
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<String>(
              future: _getUsername(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('Error loading username');
                } else {
                  return Text(
                    'Logged in as: ${snapshot.data}',
                    style:
                        const TextStyle(fontSize: 24, color: Color(0xFF333333)),
                  );
                }
              },
            ),
            SizedBox(height: 50),
            MyButton(
              onTap: () => {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                ),
              },
              text: "Create Challenge",
            ),
          ],
        ),
      ),
    );
  }
}
*/








/*
Text("LOGGED IN!",
                style: TextStyle(fontSize: 24, color: Colors.white)),
*/