import "package:flutter/material.dart";
import "home_page.dart";
import "../components/my_appbar.dart";
import "../components/my_textfield.dart";
import "../components/my_button.dart";
import 'package:http/http.dart' as http;
import "package:flutter_secure_storage/flutter_secure_storage.dart";

class CreateChallengePage extends StatefulWidget {
  const CreateChallengePage({Key? key}) : super(key: key);

  @override
  _CreateChallengePageState createState() => _CreateChallengePageState();
}

class _CreateChallengePageState extends State<CreateChallengePage> {
  final TextEditingController _challengeTitleController =
      TextEditingController();
  final TextEditingController _challengeDescriptionController =
      TextEditingController();
  final TextEditingController _challengeTargetDistanceController =
      TextEditingController();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  bool _isLoading = false;

  @override
  void dispose() {
    _challengeTitleController.dispose();
    _challengeDescriptionController.dispose();
    _challengeTargetDistanceController.dispose();
    super.dispose();
  }

  Future<void> _createChallenge(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    final String title = _challengeTitleController.text;
    final String description = _challengeDescriptionController.text;
    final String targetDistance = _challengeTargetDistanceController.text;

    final String? jwtToken = await _storage.read(key: 'jwt');

    try {
      final response = await http.post(
        Uri.parse(
            'https://fiskeprojekt-gruppe2.vercel.app/api/competitions/create'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $jwtToken',
        },
        body: {
          'title': title,
          'description': description,
          'targetDistance': targetDistance,
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Challenge created successfully')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create challenge')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6cbabc),
      appBar: CustomAppBar(title: 'Create Challenge Page'),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
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
                const Text(
                  "Opret Challenge",
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: _challengeTitleController,
                  hintText: "Title",
                  obscureText: false,
                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: _challengeDescriptionController,
                  hintText: "Description",
                  obscureText: false,
                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: _challengeTargetDistanceController,
                  hintText: "Distance",
                  obscureText: false,
                ),
                const SizedBox(height: 25),
                _isLoading
                    ? const CircularProgressIndicator()
                    : MyButton(
                        onTap: () => _createChallenge(context),
                        text: "Create Challenge",
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
