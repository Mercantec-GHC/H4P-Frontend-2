import 'package:fiske_fitness_app/components/my_invites.dart';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PendingInvitesPage extends StatefulWidget {
  const PendingInvitesPage({super.key});

  @override
  State<PendingInvitesPage> createState() => _PendingInvitesPageState();
}

class _PendingInvitesPageState extends State<PendingInvitesPage> {
  List invites = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchInvites();
  }

  Future<void> fetchInvites() async {
    final storage = const FlutterSecureStorage();
    final String? jwtToken = await storage.read(key: 'jwt');
    final response = await http.get(
      Uri.parse('https://fiskeprojekt-gruppe2.vercel.app/api/invitations/'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);

      setState(() {
        invites = decodedResponse['data'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load invites');
    }
  }

  Future<void> acceptInvite(String competitionId) async {
    final storage = const FlutterSecureStorage();
    final String? jwtToken = await storage.read(key: 'jwt');
    final response = await http.post(
      Uri.parse(
          'https://fiskeprojekt-gruppe2.vercel.app/api/invitations/accept'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'competitionId': competitionId,
      },
    );

    if (response.statusCode == 200) {
      // Update invite status locally
      setState(() {
        invites = invites.map((invite) {
          if (invite['competitionId'] == competitionId) {
            invite['status'] = true; // Mark as accepted
          }
          return invite;
        }).toList();
      });
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to accept')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6cbabc),
      appBar: AppBar(title: const Text('Pending Invites')),
      body: InviteList(
        invites: invites,
        isLoading: isLoading,
        onAcceptInvite: acceptInvite, // Pass the acceptInvite function
      ),
    );
  }
}
