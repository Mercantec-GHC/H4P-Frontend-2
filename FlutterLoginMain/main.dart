import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Login & Signup'),
            bottom: TabBar(
              tabs: [
                Tab(text: 'Login'),
                Tab(text: 'Signup'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              LoginCard(),
              SignupCard(),
            ],
          ),
        ),
      ),
    );
  }
}

// User model class to store user information
class User {
  String fullName;
  final String email;
  final String password;

  User({
    required this.fullName,
    required this.email,
    required this.password,
  });
}

// List to store registered users (this is an in-memory store for demo purposes)
List<User> registeredUsers = [];

// Variable to track the current logged-in user
User? currentUser;

class LoginCard extends StatefulWidget {
  @override
  _LoginCardState createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _handleLogin() {
    final String email = emailController.text;
    final String password = passwordController.text;

    bool userFound = false;

    for (var user in registeredUsers) {
      if (user.email == email && user.password == password) {
        userFound = true;
        setState(() {
          currentUser = user;
        });
        break;
      }
    }

    if (userFound) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login successful')),
      );
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid email or password')),
      );
    }
  }

  void _handleLogout() {
    setState(() {
      currentUser = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Logged out')),
    );
  }

  void _handleDeleteAccount() {
    setState(() {
      registeredUsers.remove(currentUser);
      currentUser = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Account deleted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20.0),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (currentUser != null) ...[
                Text('Logged in as ${currentUser!.fullName}'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfileScreen(),
                      ),
                    ).then((_) {
                      // Refresh the UI when returning from EditProfileScreen
                      setState(() {});
                    });
                  },
                  child: Text('Edit Profile'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _handleLogout,
                  child: Text('Logout'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _handleDeleteAccount,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors
                        .red, // Change button color to red for delete action
                  ),
                  child: Text('Delete Account'),
                ),
              ] else ...[
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _handleLogin,
                  child: Text('Login'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class SignupCard extends StatefulWidget {
  @override
  _SignupCardState createState() => _SignupCardState();
}

class _SignupCardState extends State<SignupCard> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _handleSignup() {
    final String fullName = fullNameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;

    bool emailExists = registeredUsers.any((user) => user.email == email);

    if (emailExists) {
      // Show error message if email is already registered
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email is already registered')),
      );
    } else {
      // Register the user
      User newUser = User(
        fullName: fullName,
        email: email,
        password: password,
      );

      registeredUsers.add(newUser);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signup successful')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20.0),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: fullNameController,
                decoration: InputDecoration(labelText: 'Full Name'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handleSignup,
                child: Text('Signup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      nameController.text = currentUser!.fullName;
    }
  }

  void _handleSaveChanges() {
    if (currentUser != null) {
      setState(() {
        currentUser!.fullName = nameController.text;
      });

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Full Name'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleSaveChanges,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
