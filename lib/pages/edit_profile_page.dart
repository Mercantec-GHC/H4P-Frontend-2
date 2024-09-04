import "package:flutter/material.dart";
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
