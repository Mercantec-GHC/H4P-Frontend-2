import 'package:flutter/material.dart';
import "../components/my_challenge_box.dart";
import "../components/my_button.dart";
import "../components/my_textfield.dart";
import 'package:http/http.dart' as http;
import "package:flutter_secure_storage/flutter_secure_storage.dart";

class ChallengeMemberProgressBox extends StatelessWidget {
  final ChallengeMemberProgress memberProgress;
  final double targetDistance;

  const ChallengeMemberProgressBox({
    Key? key,
    required this.memberProgress,
    required this.targetDistance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progressPercentage =
        memberProgress.distanceCompleted / targetDistance;

    return Card(
      elevation: 3.0,
      margin: EdgeInsets.symmetric(vertical: 5.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              memberProgress.username,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Distance Completed: ${memberProgress.distanceCompleted} km / $targetDistance km',
              style: TextStyle(fontSize: 14.0),
            ),
            SizedBox(height: 8.0),
            LinearProgressIndicator(
              value: progressPercentage,
              minHeight: 8.0,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                progressPercentage >= 1.0 ? Colors.green : Colors.blue,
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
  }
}
