import 'package:flutter/material.dart'; 
import 'package:firebase_auth/firebase_auth.dart'; 
import 'login.dart'; 
 
 
class ForgotPasswordPage extends StatelessWidget { 
  final TextEditingController _emailController = TextEditingController(); 
 
  void _resetPassword(BuildContext context) async { 
    try { 
      await FirebaseAuth.instance.sendPasswordResetEmail( 
        email: _emailController.text.trim(), 
      ); 
      // Password reset email sent successfully 
      ScaffoldMessenger.of(context).showSnackBar( 
        SnackBar( 
          content: Text('Password reset email sent. Check your inbox.'), 
        ), 
      ); 
    } catch (e) { 
      // Handle password reset errors 
      ScaffoldMessenger.of(context).showSnackBar( 
        SnackBar( 
          content: Text('Error: $e'), 
        ), 
      ); 
    } 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar( 
        title: Text('Forgot Password'), 
      ), 
      body: Padding( 
        padding: const EdgeInsets.all(16.0), 
        child: Column( 
          crossAxisAlignment: CrossAxisAlignment.stretch, 
          children: [ 
            TextField( 
              controller: _emailController, 
              decoration: InputDecoration( 
                labelText: 'Email', 
              ), 
            ), 
            SizedBox(height: 16.0), 
            ElevatedButton( 
              onPressed: () => _resetPassword(context), 
              child: Text('Reset Password'), 
            ), 
          ], 
        ), 
      ), 
    ); 
  } 
}
