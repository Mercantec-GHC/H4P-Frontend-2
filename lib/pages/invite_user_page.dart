import 'package:flutter/material.dart';
import "../components/my_challenge_box.dart";
import "../components/my_button.dart";
import "../components/my_textfield.dart";

class InviteUsersPage extends StatelessWidget {
  final Challenge challenge;

  const InviteUsersPage({Key? key, required this.challenge}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();

    return Scaffold(
      backgroundColor: Color(0xFF6cbabc),
      appBar: AppBar(
        backgroundColor: const Color(0xFFcacdce),
        title: Text('Invite user to ${challenge.title}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Invite user to challenge: ${challenge.title}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0),
            MyTextField(
              controller: usernameController,
              hintText: "Invite User By Username",
              obscureText: false,
            ),
            SizedBox(height: 20.0),
            MyButton(
              onTap: () {
                final username = usernameController.text;
                // Simulate inviting the user (in a real app, you'd integrate a backend call here)
                print('Inviting $username to the challenge.');
                // After inviting, maybe show a confirmation or go back
                Navigator.pop(context);
              },
              text: "Invite User",
            ),
          ],
        ),
      ),
    );
  }
}
