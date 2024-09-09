import "package:flutter/material.dart";
import "../components/my_appbar.dart";
import "../components/my_challenge_box.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChallengePage extends StatefulWidget {
  const ChallengePage({Key? key}) : super(key: key);

  @override
  _ChallengePageState createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  late Future<List<Challenge>> _challengesFuture;

  @override
  void initState() {
    super.initState();
    _challengesFuture = fetchChallenges();
  }

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
      final data = json.decode(response.body) as Map<String, dynamic>;
      final List<dynamic> challengesJson = data['data'];

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
            child: const Text(
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
              future: _challengesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return _buildErrorContent(snapshot.error.toString());
                } else if (snapshot.hasData) {
                  final challenges = snapshot.data!;
                  return challenges.isNotEmpty
                      ? ChallengeList(challenges: challenges)
                      : const Center(child: Text('No challenges available.'));
                } else {
                  return const Center(child: Text('Unexpected error.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorContent(String errorMessage) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error, size: 48, color: Colors.red),
        const SizedBox(height: 16),
        Text('Error: $errorMessage'),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _challengesFuture = fetchChallenges();
            });
          },
          child: const Text('Retry'),
        ),
      ],
    );
  }
}

/*
Stateless version
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
*/
