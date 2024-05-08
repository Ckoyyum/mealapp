import 'package:flutter/material.dart';

// Define a Recipe class to hold recipe details
class Recipe {
  final String name;
  final List<String> ingredients;
  final String time;
  final String instructions;

  Recipe({
    required this.name,
    required this.ingredients,
    required this.time,
    required this.instructions,
  });
}

class RecipeListPage extends StatelessWidget {
  final List<Recipe> recipes;

  RecipeListPage({required this.recipes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes'),
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(recipes[index].name),
            onTap: () {
              // Navigate to recipe details page when tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipePage(recipe: recipes[index]),
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

class RecipePage extends StatelessWidget {
  final Recipe recipe;

  RecipePage({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ingredients Needed:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: recipe.ingredients
                  .map((ingredient) => Text('- $ingredient'))
                  .toList(),
            ),
            SizedBox(height: 16),
            Text(
              'Time to Consume: ${recipe.time}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Instructions:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(recipe.instructions),
          ],
        ),
      ),
    );
  }
}
