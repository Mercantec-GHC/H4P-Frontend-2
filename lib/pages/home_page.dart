import "package:fiske_fitness_app/pages/create_challenge_page.dart";
import "package:fiske_fitness_app/pages/geolocation_page.dart";
import "package:flutter/material.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "../components/my_button.dart";
import "../components/my_appbar.dart";
import "my_challenges_page.dart";

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  /*
  Future<String> _getJwtToken() async {
    final storage = FlutterSecureStorage();
    String? jwt = await storage.read(key: 'jwt');
    return jwt ?? 'No jwt';
  }
  */

  Future<String> _getUsername() async {
    final storage = FlutterSecureStorage();
    String? email = await storage.read(key: 'email');
    return email ?? 'Guest';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6cbabc),
      appBar: CustomAppBar(
        title: 'Hjælp! Jeg er en fisk!',
        isHomePage: true,
      ),
      body: Stack(
        children: [
          Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  'lib/images/fiske_logo.png',
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 300),
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
              SizedBox(height: 20),
              MyButton(
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChallengePage()),
                  ),
                },
                text: "My Challenges",
              ),
              SizedBox(height: 20),
              MyButton(
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LocationPage()),
                  ),
                },
                text: "Geolocator",
              ),
            ],
          )),
          Positioned(
            top: kToolbarHeight - 40,
            left: 0.0,
            right: 0.0,
            child: FutureBuilder<String>(
              future: _getUsername(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('Error loading username');
                } else {
                  return Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Logged in as: ${snapshot.data}",
                      style: const TextStyle(
                          fontSize: 16, color: Color(0xFF333333)),
                    ),
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
