import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminManageIngredientPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Ingredients'),
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
                  MaterialPageRoute(builder: (context) => AddIngredientPage()),
                );
              },
              child: Text('Add Ingredient'),
            ),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: IngredientList(),
          ),
        ],
      ),
    );
  }
}

class IngredientList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('ingredients').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

        if (documents.isEmpty) {
          return Center(child: Text('No ingredients found'));
        }

        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            var ingredientData = documents[index].data();
            if (ingredientData != null && ingredientData is Map<String, dynamic>) {
              String name = ingredientData['name'] ?? 'Unnamed Ingredient';
              String type = ingredientData['type'] ?? 'Unknown Type';
              return ListTile(
                title: Text(name),
                subtitle: Text(type),
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

class AddIngredientPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Ingredient'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Ingredient Name'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _typeController,
              decoration: InputDecoration(labelText: 'Ingredient Type'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String name = _nameController.text.trim();
                String type = _typeController.text.trim();

                if (name.isNotEmpty && type.isNotEmpty) {
                  FirebaseFirestore.instance.collection('ingredients').add({
                    'name': name,
                    'type': type,
                  }).then((_) {
                    _nameController.clear();
                    _typeController.clear();
                    Navigator.pop(context); // Close the page after adding ingredient
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add ingredient: $error')),
                    );
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Please enter both name and type')),
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
