import 'package:flutter/material.dart';
import "../components/my_challenge_box.dart";
import "../components/my_button.dart";
import "../components/my_textfield.dart";
import 'package:http/http.dart' as http;
import "package:flutter_secure_storage/flutter_secure_storage.dart";

class InviteUsersPage extends StatefulWidget {
  final Challenge challenge;

  InviteUsersPage({Key? key, required this.challenge}) : super(key: key);

  @override
  _InviteUsersPageState createState() => _InviteUsersPageState();
}

class _InviteUsersPageState extends State<InviteUsersPage> {
  final TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _inviteUser() async {
    final String username = _usernameController.text;
    final int competitionId = widget.challenge.id;
    final storage = const FlutterSecureStorage();
    final String? jwtToken = await storage.read(key: 'jwt');

    final response = await http.post(
      Uri.parse(
          'https://fiskeprojekt-gruppe2.vercel.app/api/invitations/create'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $jwtToken',
      },
      body: {
        'username': username,
        'competitionId': competitionId.toString(),
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User invited')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Failed to invite user to challenge with id: ${widget.challenge.id}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6cbabc),
      appBar: AppBar(
        backgroundColor: const Color(0xFFcacdce),
        title: Text('Invite user to ${widget.challenge.title}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Invite user to challenge: ${widget.challenge.title}',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            SizedBox(height: 20.0),
            MyTextField(
              controller: _usernameController,
              hintText: "Invite by username",
              obscureText: false,
            ),
            SizedBox(height: 20.0),
            MyButton(
              onTap: () => _inviteUser(),
              text: "Invite User",
            ),
          ],
        ),
      ),
    );
  }
}
