import 'package:flutter/material.dart';

class RecipeListPage extends StatelessWidget {
  final List<String> selectedIngredients;

  RecipeListPage({required this.selectedIngredients});

  // Dummy list of recipes for testing
  final List<String> dummyRecipes = [
    'Recipe 1',
    'Recipe 2',
    'Recipe 3',
    // Add more recipes as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes'),
      ),
      body: ListView.builder(
        itemCount: dummyRecipes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(dummyRecipes[index]),
            onTap: () {
              // Navigate to recipe details page when tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RecipeDetailPage(recipeName: dummyRecipes[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class RecipeDetailPage extends StatelessWidget {
  final String recipeName;

  RecipeDetailPage({required this.recipeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipeName),
      ),
      body: Center(
        child: Text('Recipe details for $recipeName'),
      ),
    );
  }
}
