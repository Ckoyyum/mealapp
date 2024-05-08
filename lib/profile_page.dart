import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'main.dart';
import 'login.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isSwitched = false;
  int _selectedIndex = 0;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load user data when the page initializes
  }

  void _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        _usernameController.text = userData['username'];
      });
    }
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pop(context);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Future<void> _updateUsername(String newName) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && newName.isNotEmpty) {
      // Check if newName is not empty
      try {
        // Update the display name in Firebase Authentication
        await user.updateProfile(displayName: newName);

        // Update the username in Firestore database
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'username': newName});

        _showAlertDialog(context, "Update Successful");
      } catch (e) {
        print('Error updating username: $e');
        _showAlertDialog(context, "Error updating username: $e");
      }
    } else {
      _showAlertDialog(context, "New username cannot be empty");
    }
  }

  Future<void> _updatePassword(String newPassword) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Update the password in Firebase Authentication
        await user.updatePassword(newPassword);

        // You typically don't store passwords in Firestore for security reasons.
        // If you need to store additional user data, update it here.
        // For example, you could update a 'lastPasswordUpdate' field:
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'lastPasswordUpdate': DateTime.now()});

        _showAlertDialog(context, "Password Updated Successfully");
      } catch (e) {
        print('Error updating password: $e');
        _showAlertDialog(context, "Error updating password: $e");
      }
    }
  }

  // void _deleteAccount() async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     await user.delete();
  //     // Show pop-up message indicating successful deletion
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text("Account Deleted"),
  //           content: Text("Your account has been successfully deleted."),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               child: Text("OK"),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //     // Navigator.pushReplacement( // Navigate to login page after account deletion
  //     //   context,
  //     //   MaterialPageRoute(builder: (context) => LoginPage()),
  //     // );
  //   }
  // }

  void _confirmUpdates() {
    String newUsername = _usernameController.text;
    String newPassword = _passwordController.text;

    // Only update password if it's not empty
    if (newPassword.isNotEmpty) {
      _updatePassword(newPassword);
    }

    // Always update username
    _updateUsername(newUsername);
  }

  void _showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Update Status"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          Map<String, dynamic> userData =
              snapshot.data!.data() as Map<String, dynamic>;

          return ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(userData['username'] ?? ""),
                accountEmail: Text(user.email ?? ""),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    userData['username']?.substring(0, 1) ?? "",
                    style: TextStyle(fontSize: 40.0),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.purple,
                ),
              ),
              ListTile(
                title: Text('General Settings'),
              ),
              ListTile(
                title: Text('Username'),
                subtitle: TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'Enter new username',
                  ),
                ),
              ),
              ListTile(
                title: Text('Password'),
                subtitle: TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Enter new password',
                  ),
                  obscureText: true,
                  onChanged: (value) {
                    // Update the password controller as the user types
                    _passwordController.text = value;
                  },
                ),
              ),
              // ListTile(
              //   title: Text('Delete Account'),
              //   onTap: () {
              //     showDialog(
              //       context: context,
              //       builder: (BuildContext context) {
              //         return AlertDialog(
              //           title: Text("Confirm Deletion"),
              //           content: Text(
              //               "Are you sure you want to delete your account? This action cannot be undone."),
              //           actions: [
              //             TextButton(
              //               onPressed: () {
              //                 Navigator.of(context).pop();
              //               },
              //               child: Text("Cancel"),
              //             ),
              //             // TextButton(
              //             //   onPressed: () {
              //             //     _deleteAccount();
              //             //   },
              //             //   child: Text("Delete"),
              //             // ),
              //           ],
              //         );
              //       },
              //     );
              //   },
              // ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home, color: Colors.black),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.person, color: Colors.black),
          ),
          BottomNavigationBarItem(
            label: 'Favorite',
            icon: Icon(Icons.favorite, color: Colors.black),
          ),
          BottomNavigationBarItem(
            label: 'Settings',
            icon: Icon(Icons.settings, color: Color.fromARGB(255, 0, 0, 0)),
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            // Navigate to ProfilePage when profile is tapped
            var push = Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _confirmUpdates,
        icon: Icon(Icons.check),
        label: Text('Confirm Update'),
      ),
    );
  }
}
