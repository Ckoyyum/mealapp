import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mealplan/firebase_options.dart';
import 'home.dart';
import 'login.dart';
import 'admin.dart'; // Import the AdminPage class

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Ensure Firebase is initialized before running the app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthenticationWrapper(),
      routes: {
        '/admin': (context) => AdminPage(), // Add a route for the admin page
      },
    );
  }
}

class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  bool isAuthenticated = false;
  bool isAdmin = false; // Add a boolean to track admin status

  void _login() {
    setState(() {
      isAuthenticated = true;
    });
  }

  void _logout() {
    setState(() {
      isAuthenticated = false;
    });
  }

  void _setAdmin(bool value) {
    setState(() {
      isAdmin = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isAuthenticated
        ? isAdmin
            ? AdminPage() // Navigate to AdminPage if isAdmin is true
            : MyHomePage(logout: _logout)
        : LoginPage(
            login: _login,
            goToSignUp: () {},
            setAdmin: _setAdmin, // Pass the setAdmin function to LoginPage
          );
  }
}
