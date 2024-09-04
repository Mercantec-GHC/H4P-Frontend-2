import "package:fiske_fitness_app/pages/create_challenge_page.dart";
import "package:flutter/material.dart";
import "login_page.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "../components/my_button.dart";
import "../components/my_appbar.dart";

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6cbabc),
      appBar: CustomAppBar(title: 'Edit Profile Page'),
    );
  }
}
