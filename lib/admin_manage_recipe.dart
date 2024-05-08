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
              String description =
                  recipeData['description'] ?? 'No description available';
              String course = recipeData['course'] ?? 'No course available';
              List<dynamic> ingredients = recipeData['ingredients'] ?? [];
              String imageUrl = recipeData['imageUrl'] ?? 'No image available';
              return ListTile(
                title: Text(name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(description),
                    Text('Course: $course'),
                    Text(
                        'Ingredients: ${ingredients.join(', ')}'), // Convert list to string
                    Text('Image URL: $imageUrl'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditRecipePage(
                                  recipeId: documents[index].id)),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // Implement delete functionality here
                        FirebaseFirestore.instance
                            .collection('recipes')
                            .doc(documents[index].id)
                            .delete()
                            .then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Recipe deleted successfully')),
                          );
                        }).catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Failed to delete recipe: $error')),
                          );
                        });
                      },
                    ),
                  ],
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
                List<String> ingredients =
                    _ingredientsController.text.split(',');
                String imageUrl = _imageUrlController.text.trim();

                if (name.isNotEmpty &&
                    description.isNotEmpty &&
                    course.isNotEmpty &&
                    ingredients.isNotEmpty &&
                    imageUrl.isNotEmpty) {
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

class EditRecipePage extends StatefulWidget {
  final String recipeId;

  EditRecipePage({required this.recipeId});

  @override
  _EditRecipePageState createState() => _EditRecipePageState();
}

class _EditRecipePageState extends State<EditRecipePage> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _courseController;
  late TextEditingController _ingredientsController;
  late TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _courseController = TextEditingController();
    _ingredientsController = TextEditingController();
    _imageUrlController = TextEditingController();

    // Fetch recipe data and populate the text fields
    FirebaseFirestore.instance
        .collection('recipes')
        .doc(widget.recipeId)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        _nameController.text = data['name'] ?? '';
        _descriptionController.text = data['description'] ?? '';
        _courseController.text = data['course'] ?? '';
        _ingredientsController.text =
            (data['ingredients'] as List<dynamic>).join(', ');
        _imageUrlController.text = data['imageUrl'] ?? '';
      }
    });
  }

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
                List<String> ingredients =
                    _ingredientsController.text.split(',');
                String imageUrl = _imageUrlController.text.trim();

                Map<String, dynamic> updatedData = {};

                if (name.isNotEmpty) updatedData['name'] = name;
                if (description.isNotEmpty)
                  updatedData['description'] = description;
                if (course.isNotEmpty) updatedData['course'] = course;
                if (ingredients.isNotEmpty)
                  updatedData['ingredients'] = ingredients;
                if (imageUrl.isNotEmpty) updatedData['imageUrl'] = imageUrl;

                if (updatedData.isNotEmpty) {
                  FirebaseFirestore.instance
                      .collection('recipes')
                      .doc(widget.recipeId)
                      .update(updatedData)
                      .then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Recipe updated successfully')),
                    );
                    Navigator.pop(
                        context); // Close the EditRecipePage and go back to Manage Recipe page
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Failed to update recipe: $error')),
                    );
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('No fields to update'),
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

  void main() {
    runApp(MaterialApp(
      title: 'Recipe App',
      home: AdminManageRecipePage(),
    ));
  }
}
