import "package:fiske_fitness_app/pages/login_page.dart";
import "package:flutter/material.dart";
import "../components/my_textfield.dart";
import "../components/my_button.dart";
import 'package:http/http.dart' as http;

class ChooseUsernamePage extends StatelessWidget {
  ChooseUsernamePage({super.key});

  final usernameController = TextEditingController();

  void chooseUsername(BuildContext context) async {
    final String username = usernameController.text;

    final response = await http.post(
      Uri.parse('https://fiskeprojekt-gruppe2.vercel.app/api/users/create'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'username': Uri.encodeComponent(username),
      },
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signup successful')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign up')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6cbabc),
      appBar: AppBar(
        backgroundColor: const Color(0xFFcacdce),
        title: Text('Choose your username'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
                context); // Pops the current page from the navigation stack
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  'lib/images/fiske_logo.png',
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 50),
              Text(
                "Vælg dit brugernavn her...",
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 25),
              MyTextField(
                controller: usernameController,
                hintText: "Username",
                obscureText: false,
              ),
              const SizedBox(height: 25),
              MyButton(
                onTap: () => chooseUsername(context),
                text: "Register",
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
