import 'package:flutter/material.dart';

class InviteList extends StatelessWidget {
  final List invites;
  final bool isLoading;
  final Function(String competitionId) onAcceptInvite;

  const InviteList({
    required this.invites,
    required this.isLoading,
    required this.onAcceptInvite, // Callback for accepting invites
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (invites.isEmpty) {
      return const Center(child: Text('No invites found'));
    } else {
      return ListView.builder(
        itemCount: invites.length,
        itemBuilder: (context, index) {
          final invite = invites[index];
          final bool isAccepted =
              invite['status']; // Assuming status represents acceptance

          return ListTile(
            title: Text(invite['username']), // Display username
            subtitle: Text(
                'Competition ID: ${invite['competitionId']}'), // Display competitionId
            trailing: isAccepted
                ? const Text('Accepted') // If already accepted
                : ElevatedButton(
                    onPressed: () {
                      onAcceptInvite(invite['competitionId'].toString());
                    },
                    child: const Text('Accept'),
                  ),
          );
        },
      );
    }
  }
}
