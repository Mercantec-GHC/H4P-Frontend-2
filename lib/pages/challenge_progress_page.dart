import "package:flutter/material.dart";
import "../components/my_challenge_box.dart";
import "../components/my_progress_box.dart";

class ChallengeProgressPage extends StatelessWidget {
  final Challenge challenge;

  const ChallengeProgressPage({Key? key, required this.challenge})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy data for members' progress (replace with actual API data)
    final List<ChallengeMemberProgress> memberProgress = [
      ChallengeMemberProgress(username: 'User1', distanceCompleted: 30.0),
      ChallengeMemberProgress(username: 'User2', distanceCompleted: 15.5),
    ];

    return Scaffold(
      appBar: AppBar(
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
                  return ChallengeMemberProgressBox(
                    memberProgress: memberProgress[index],
                    targetDistance: challenge.targetDistance,
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
