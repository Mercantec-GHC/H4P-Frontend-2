import "package:flutter/material.dart";
import "home_page.dart";
import "../components/my_appbar.dart";
import "../components/my_textfield.dart";
import "../components/my_button.dart";
import 'package:http/http.dart' as http;

class CreateChallengePage extends StatelessWidget {
  CreateChallengePage({super.key});

  final challengeTitleController = TextEditingController();
  final challengeDescriptionController = TextEditingController();
  final challengeTargetDistanceController = TextEditingController();

  void createChallenge(BuildContext context) async {
    final String title = challengeTitleController.text;
    final String description = challengeDescriptionController.text;
    final String targetDistance = challengeTargetDistanceController.text;

    final response = await http.post(
      Uri.parse(
          'https://fiskeprojekt-gruppe2.vercel.app/api/competitions/create'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'title': Uri.encodeComponent(title),
        'description': Uri.encodeComponent(description),
        'targetDistance': Uri.encodeComponent(targetDistance),
      },
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Challenge created')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create challenge')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6cbabc),
      appBar: CustomAppBar(title: 'Create Challenge Page'),
      body: SafeArea(
        child: Center(
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
              const SizedBox(height: 50),
              Text(
                "Opret Challenge",
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 25),
              const SizedBox(height: 25),
              MyTextField(
                controller: challengeTitleController,
                hintText: "Title",
                obscureText: false,
              ),
              const SizedBox(height: 25),
              MyTextField(
                controller: challengeDescriptionController,
                hintText: "Description",
                obscureText: false,
              ),
              const SizedBox(height: 25),
              MyTextField(
                controller: challengeTargetDistanceController,
                hintText: "Distance",
                obscureText: false,
              ),
              const SizedBox(height: 25),
              MyButton(
                onTap: () => createChallenge(context),
                text: "Create Challenge",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
