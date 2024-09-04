import "package:fiske_fitness_app/pages/login_page.dart";
import "package:flutter/material.dart";
import "../components/my_textfield.dart";
import "../components/my_button.dart";
import 'package:http/http.dart' as http;

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void registerUser(BuildContext context) async {
    final String email = emailController.text;
    final String password = passwordController.text;

    final response = await http.post(
      Uri.parse('https://fiskeprojekt-gruppe2.vercel.app/api/users/create'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'email': Uri.encodeComponent(email),
        'password': Uri.encodeComponent(password),
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
                "Opret en bruger her, for at begynde at bruge FiskeFitness™",
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 25),
              MyTextField(
                controller: emailController,
                hintText: "E-mail",
                obscureText: false,
              ),
              const SizedBox(height: 25),
              MyTextField(
                controller: passwordController,
                hintText: "Password",
                obscureText: true,
              ),
              const SizedBox(height: 25),
              MyButton(
                onTap: () => registerUser(context),
                text: "Register",
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already a member?",
                    style: TextStyle(color: Color(0xff333333)),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text(
                      "Login here",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
