import "package:flutter/material.dart";
import "../components/my_appbar.dart";
import "../components/my_challenge_box.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChallengePage extends StatelessWidget {
  const ChallengePage({super.key});

  Future<List<Challenge>> fetchChallenges() async {
    final storage = const FlutterSecureStorage();

    final String? jwtToken = await storage.read(key: 'jwt');
    final response = await http.get(
      Uri.parse('https://fiskeprojekt-gruppe2.vercel.app/api/competitions'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);

      List<dynamic> challengesJson = data['data'];

      return challengesJson.map((item) => Challenge.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load challenges');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6cbabc),
      appBar: CustomAppBar(
        title: 'My Challenges Page',
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
              'All your active challenges!',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Color(0xff333333),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Challenge>>(
              future: fetchChallenges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return ChallengeList(challenges: snapshot.data!);
                } else {
                  return Center(child: Text('No challenges available.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
