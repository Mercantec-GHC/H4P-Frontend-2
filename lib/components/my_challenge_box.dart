import "package:fiske_fitness_app/pages/challenge_progress_page.dart";
import 'package:flutter/material.dart';
import "../pages/invite_user_page.dart";
import "../components/my_button.dart";

class Challenge {
  final String title;
  final String description;
  final double targetDistance;
  final int id;

  Challenge({
    required this.title,
    required this.description,
    required this.targetDistance,
    required this.id,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      title: json['title'],
      description: json['description'],
      targetDistance: (json['targetDistance'] as num).toDouble(),
      id: json['id'],
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

class ChallengeMemberProgress {
  final String username;
  final double distanceCompleted;

  ChallengeMemberProgress({
    required this.username,
    required this.distanceCompleted,
  });

  // Factory method to create a ChallengeMemberProgress object from JSON
  factory ChallengeMemberProgress.fromJson(Map<String, dynamic> json) {
    return ChallengeMemberProgress(
      username: json['id'].toString(), // Use id as username for now
      distanceCompleted: (json['progress'] as num).toDouble(),
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
            SizedBox(height: 10.0),
            Text(
              'Challenge ID: ${challenge.id}',
              style: TextStyle(
                fontSize: 16.0,
                color: Color(0xff333333),
              ),
            ),
            SizedBox(height: 55.0),
            Divider(
              color: Color(0xFFfaa53b),
              thickness: 2.0,
            ),
            Row(
              children: [
                Expanded(
                  child: MyButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              InviteUsersPage(challenge: challenge),
                        ),
                      );
                    },
                    text: "Invite User",
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: MyButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChallengeProgressPage(
                            challenge: challenge,
                          ), // Navigate to the new page
                        ),
                      );
                    },
                    text: "View Progress",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
