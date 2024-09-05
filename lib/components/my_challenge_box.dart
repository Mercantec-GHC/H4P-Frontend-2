import 'package:flutter/material.dart';

class Challenge {
  final String title;
  final String description;
  final double targetDistance;

  Challenge({
    required this.title,
    required this.description,
    required this.targetDistance,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      title: json['title'],
      description: json['description'],
      targetDistance: (json['targetDistance'] as num).toDouble(),
    );
  }
}

class ChallengeBox extends StatelessWidget {
  final Challenge challenge;

  const ChallengeBox({Key? key, required this.challenge}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFcacdce),
      margin: EdgeInsets.all(10.0),
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              challenge.title,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Color(0xff333333),
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              challenge.description,
              style: TextStyle(
                fontSize: 16.0,
                color: Color(0xff333333),
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Target Distance: ${challenge.targetDistance} km',
              style: TextStyle(
                fontSize: 16.0,
                color: Color(0xff333333),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChallengeList extends StatelessWidget {
  final List<Challenge> challenges;

  const ChallengeList({Key? key, required this.challenges}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: challenges.length,
      itemBuilder: (context, index) {
        return ChallengeBox(challenge: challenges[index]);
      },
    );
  }
}
