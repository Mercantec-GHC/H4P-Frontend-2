import "package:fiske_fitness_app/pages/create_challenge_page.dart";
import "package:flutter/material.dart";
import "login_page.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "../components/my_button.dart";
import "edit_profile_page.dart";
import "../components/my_appbar.dart";
import "../components/my_challenge_box.dart";

class ChallengePage extends StatelessWidget {
  const ChallengePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6cbabc),
      appBar: CustomAppBar(
        title: 'Hjælp! Jeg er en fisk!',
      ),
      body: Column(
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Welcome to the Challenge Page!',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Color(0xff333333),
              ),
            ),
          ),

          // Use Expanded to allow the ChallengeList to take up the remaining space
          Expanded(
            child: ChallengeList(
              challenges: [
                Challenge(
                  title: 'Marathon',
                  description: 'Run a full marathon within a month.',
                  targetDistance: 42.195,
                ),
                Challenge(
                  title: 'Half-Marathon',
                  description: 'Complete a half-marathon in 2 weeks.',
                  targetDistance: 21.0975,
                ),
                Challenge(
                  title: '400m',
                  description: 'Run 400m fastest time wins.',
                  targetDistance: 400,
                ),

                // Add more challenges here
              ],
            ),
          ),
        ],
      ),
    );
  }
}
