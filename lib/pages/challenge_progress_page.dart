import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import "../components/my_progress_box.dart";
import "../components/my_challenge_box.dart";
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChallengeProgressPage extends StatelessWidget {
  final Challenge challenge;

  const ChallengeProgressPage({Key? key, required this.challenge})
      : super(key: key);

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return await secureStorage.read(key: 'jwt');
  }

  Future<List<ChallengeMemberProgress>> fetchMemberProgress() async {
    // Get the JWT token
    final String? token = await getToken();

    if (token == null) {
      throw Exception('JWT token is missing');
    }

    // Make the HTTP request with the token
    final response = await http.get(
      Uri.parse('https://fiskeprojekt-gruppe2.vercel.app/api/competitions'),
      headers: {
        'Authorization': 'Bearer $token', // Add the JWT token here
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);

      // Extract the challenge data
      final challengeData = jsonData['data'].firstWhere(
        (c) => c['id'] == this.challenge.id, // Correctly access challenge.id
        orElse: () => null,
      );

      if (challengeData == null) {
        throw Exception('Challenge not found');
      }

      // Extract and convert members progress
      final List<dynamic> members = challengeData['members'];
      return members.map((member) {
        final double progress = (member['progress'] is String)
            ? double.tryParse(member['progress']) ?? 0.0
            : (member['progress'] as num).toDouble();

        return ChallengeMemberProgress(
          username: member['id'].toString(), // Use id as username for now
          distanceCompleted: progress,
        );
      }).toList();
    } else {
      throw Exception('Failed to load challenge data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6cbabc),
      appBar: AppBar(
        backgroundColor: const Color(0xFFcacdce),
        title: Text('${challenge.title} Progress'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Members\' Progress',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: FutureBuilder<List<ChallengeMemberProgress>>(
                future: fetchMemberProgress(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No progress available.'));
                  }

                  final memberProgress = snapshot.data!;
                  return ListView.builder(
                    itemCount: memberProgress.length,
                    itemBuilder: (context, index) {
                      return ChallengeMemberProgressBox(
                        memberProgress: memberProgress[index],
                        targetDistance: challenge.targetDistance,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/*
class ChallengeProgressPage extends StatelessWidget {
  final Challenge challenge;

  const ChallengeProgressPage({Key? key, required this.challenge})
      : super(key: key);

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return await secureStorage.read(key: 'jwt');
  }

  Future<List<ChallengeMemberProgress>> fetchMemberProgress() async {
    final String? token = await getToken();
    final response = await http.get(
      Uri.parse('https://fiskeprojekt-gruppe2.vercel.app/api/competitions'),
      headers: {
        'Authorization': 'Bearer $token', // Add the JWT token here
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);

      // Extract the challenge data
      final challengeData = jsonData['data'].firstWhere(
        (challenge) => challenge['id'] == challenge.id,
        orElse: () => null,
      );

      if (challengeData == null) {
        throw Exception('Challenge not found');
      }

      // Extract and convert members progress
      final List<dynamic> members = challengeData['members'];
      return members.map((member) {
        final double progress = (member['progress'] is String)
            ? double.tryParse(member['progress']) ?? 0.0
            : (member['progress'] as num).toDouble();

        return ChallengeMemberProgress(
          username: member['id'].toString(), // Use id as username for now
          distanceCompleted: progress,
        );
      }).toList();
    } else {
      throw Exception('Failed to load challenge data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6cbabc),
      appBar: AppBar(
        backgroundColor: const Color(0xFFcacdce),
        title: Text('${challenge.title} Progress'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Members\' Progress',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: FutureBuilder<List<ChallengeMemberProgress>>(
                future: fetchMemberProgress(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No progress available.'));
                  }

                  final memberProgress = snapshot.data!;
                  return ListView.builder(
                    itemCount: memberProgress.length,
                    itemBuilder: (context, index) {
                      return ChallengeMemberProgressBox(
                        memberProgress: memberProgress[index],
                        targetDistance: challenge.targetDistance,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

*/