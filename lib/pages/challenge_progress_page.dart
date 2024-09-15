import "package:flutter/material.dart";
import "../components/my_challenge_box.dart";

import 'package:flutter/material.dart';

class ChallengeProgressPage extends StatelessWidget {
  final Challenge challenge;

  const ChallengeProgressPage({Key? key, required this.challenge})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy data for members' progress (you'll replace this with actual API data)
    final List<ChallengeMemberProgress> memberProgress = [
      ChallengeMemberProgress(username: 'User1', distanceCompleted: 30.0),
      ChallengeMemberProgress(username: 'User2', distanceCompleted: 15.5),
    ];

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
              child: ListView.builder(
                itemCount: memberProgress.length,
                itemBuilder: (context, index) {
                  final progress = memberProgress[index];
                  final progressPercentage =
                      progress.distanceCompleted / challenge.targetDistance;

                  return Card(
                    elevation: 3.0,
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            progress.username,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            'Distance Completed: ${progress.distanceCompleted} km / ${challenge.targetDistance} km',
                            style: TextStyle(fontSize: 14.0),
                          ),
                          SizedBox(height: 8.0),
                          LinearProgressIndicator(
                            value: progressPercentage,
                            minHeight: 8.0,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              progressPercentage >= 1.0
                                  ? Colors.green
                                  : Colors.blue,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            '${(progressPercentage * 100).toStringAsFixed(1)}% completed',
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ],
                      ),
                    ),
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

class ChallengeMemberProgress {
  final String username;
  final double distanceCompleted;

  ChallengeMemberProgress({
    required this.username,
    required this.distanceCompleted,
  });
}
/*
class ChallengeProgressPage extends StatefulWidget {
  final Challenge challenge;

  const ChallengeProgressPage({Key? key, required this.challenge})
      : super(key: key);

  @override
  State<ChallengeProgressPage> createState() => _ChallengeProgressPageState();
}

class _ChallengeProgressPageState extends State<ChallengeProgressPage> {
  @override
  Widget build(BuildContext context) {
    final challenge =
        widget.challenge; // Access the challenge passed from the previous page

    return Scaffold(
      backgroundColor: Color(0xFF6cbabc),
      appBar: AppBar(
        backgroundColor: const Color(0xFFcacdce),
        title: Text('Challenge Progress: ${challenge.title}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Challenge Title: ${challenge.title}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(
              'Description: ${challenge.description}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 10.0),
            Text(
              'Target Distance: ${challenge.targetDistance} km',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 10.0),
            Text(
              'Challenge ID: ${challenge.id}',
              style: TextStyle(fontSize: 16.0),
            ),
            // Add more UI elements to display the progress of the challenge
          ],
        ),
      ),
    );
  }
}
*/
