import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminManageRecipePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Recipes'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddRecipePage()),
                );
              },
              child: Text('Add Recipe'),
            ),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: RecipeList(),
          ),
        ],
      ),
    );
  }
}

class RecipeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('recipes').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

        if (documents.isEmpty) {
          return Center(child: Text('No recipes found'));
        }

        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            var recipeData = documents[index].data();
            if (recipeData != null && recipeData is Map<String, dynamic>) {
              String name = recipeData['name'] ?? 'Unnamed Recipe';
              String description = recipeData['description'] ?? 'No description available';
              String course = recipeData['course'] ?? 'No course available';
              String ingredients = recipeData['ingredients'] ?? 'No ingredients available';
              String imageUrl = recipeData['imageUrl'] ?? 'No image available';
              return ListTile(
                title: Text(name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(description),
                    Text('Course: $course'),
                    Text('Ingredients: $ingredients'),
                    Text('Image URL: $imageUrl'),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditRecipePage(recipeId: documents[index].id)),
                  );
                },
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Implement delete functionality here
                    // You can use documents[index].id to identify the recipe to delete
                  },
                ),
              );
            } else {
              return ListTile(
                title: Text('Invalid Data'),
                subtitle: Text('Please check Firestore documents'),
              );
            }
          },
        );
      },
    );
  }
}

class AddRecipePage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Recipe'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Recipe Name'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _courseController,
              decoration: InputDecoration(labelText: 'Course'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _ingredientsController,
              decoration: InputDecoration(labelText: 'Ingredients'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _imageUrlController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String name = _nameController.text.trim();
                String description = _descriptionController.text.trim();
                String course = _courseController.text.trim();
                List<String> ingredients = _ingredientsController.text.split(',');
                String imageUrl = _imageUrlController.text.trim();

                if (name.isNotEmpty && description.isNotEmpty && course.isNotEmpty && ingredients.isNotEmpty && imageUrl.isNotEmpty) {
                  FirebaseFirestore.instance.collection('recipes').add({
                    'name': name,
                    'description': description,
                    'course': course,
                    'ingredients': ingredients,
                    'imageUrl': imageUrl,
                  }).then((_) {
                    _nameController.clear();
                    _descriptionController.clear();
                    _courseController.clear();
                    _ingredientsController.clear();
                    _imageUrlController.clear();
                    Navigator.pop(context); // Close the AddRecipePage
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add recipe: $error')),
                    );
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter all fields'),
                    ),
                  );
                }
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditRecipePage extends StatelessWidget {
  final String recipeId;

  EditRecipePage({required this.recipeId});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Recipe'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Recipe Name'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _courseController,
              decoration: InputDecoration(labelText: 'Course'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _ingredientsController,
              decoration: InputDecoration(labelText: 'Ingredients'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _imageUrlController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String name = _nameController.text.trim();
                String description = _descriptionController.text.trim();
                String course = _courseController.text.trim();
                List<String> ingredients = _ingredientsController.text.split(',');
                String imageUrl = _imageUrlController.text.trim();

                if (name.isNotEmpty && description.isNotEmpty && course.isNotEmpty && ingredients.isNotEmpty && imageUrl.isNotEmpty) {
                  FirebaseFirestore.instance.collection('recipes').doc(recipeId).update({
                    'name': name,
                    'description': description,
                    'course': course,
                    'ingredients': ingredients,
                    'imageUrl': imageUrl,
                  }).then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Recipe updated successfully')),
                    );
                    Navigator.pop(context); // Close the EditRecipePage and go back to Manage Recipe page
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to update recipe: $error')),
                    );
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter all fields'),
                    ),
                  );
                }
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Recipe App',
    home: AdminManageRecipePage(),
  ));
}
