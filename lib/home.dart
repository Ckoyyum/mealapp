import 'package:flutter/material.dart';
import 'ingredient_page.dart';
import 'recipe_list_page.dart';
import 'profile_page.dart'; // Importing the profile_page.dart
import 'login.dart'; // Importing the login.dart

class MyHomePage extends StatelessWidget {
  final VoidCallback logout;

  const MyHomePage({Key? key, required this.logout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 245, 242, 196),
        title: Text('Found Your Food'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              onTap: () {
                // Navigate to IngredientPage when the search bar is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => IngredientPage()),
                );
              },
              decoration: InputDecoration(
                hintText: 'Search for your food',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: List.generate(
                4,
                (index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to RecipeListPage when a recipe is tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeListPage(
                              selectedIngredients: [
                                'Ingredient 1',
                                'Ingredient 2',
                                'Ingredient 3'
                              ]),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.photo,
                          size: 50,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the login page and remove all routes from the stack
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage(login: () {  }, goToSignUp: () {  }, setAdmin: (bool value) {  },)),
          );
        },
        child: Icon(Icons.logout),
      ),
    );
  }
}
