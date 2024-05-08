import 'package:flutter/material.dart';
import 'package:mealplan/admin_manage_ingredient.dart';
import 'package:mealplan/admin_manage_recipe.dart'; // Import your screen for managing recipes
import 'package:mealplan/login.dart'; // Import the login page

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Navigate to the login page when logout button is pressed
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage(login: () {  }, goToSignUp: () {  }, setAdmin: (bool value) {  },)),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage Recipes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigate to screen for managing recipes
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminManageRecipePage()),
                );
              },
              child: Text('Manage Recipes'),
            ),
            SizedBox(height: 20),
            Text(
              'Manage Ingredients',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigate to ingredient page for managing ingredients
                // Replace IngredientPage() with the appropriate page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminManageIngredientPage()),
                );
              },
              child: Text('Manage Ingredients'),
            ),
          ],
        ),
      ),
    );
  }
}
