import 'package:flutter/material.dart';

class InviteList extends StatelessWidget {
  final List invites;
  final bool isLoading;
  final Function(int invitationId) onAcceptInvite;

  const InviteList({
    required this.invites,
    required this.isLoading,
    required this.onAcceptInvite,
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
          final bool isAccepted = invite['status'];

          return ListTile(
            title: Text("Invited by: " + invite['ownerName']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Competition Title: ${invite['competitionTitle']}'),
                Text('Invitation ID: ${invite['id']}'),
              ],
            ),
            trailing: isAccepted
                ? const Text('Accepted')
                : ElevatedButton(
                    onPressed: () {
                      onAcceptInvite(invite['id']);
                    },
                    child: const Text('Accept'),
                  ),
          );
        },
      );
    }
  }
}
