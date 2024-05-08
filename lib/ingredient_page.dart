import 'package:flutter/material.dart';
import 'recipe_list_page.dart';

class IngredientPage extends StatefulWidget {
  @override
  _IngredientPageState createState() => _IngredientPageState();
}

class _IngredientPageState extends State<IngredientPage> {
  List<String> selectedIngredients = [];
  TextEditingController _searchController = TextEditingController();

  void _toggleIngredientSelection(String ingredient) {
    if (selectedIngredients.contains(ingredient)) {
      setState(() {
        selectedIngredients.remove(ingredient);
      });
    } else {
      setState(() {
        selectedIngredients.add(ingredient);
      });
    }
  }

  void _handleSubmit() {
    // Navigate to RecipeListPage when submit button is pressed
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            RecipeListPage(selectedIngredients: selectedIngredients),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('What\'s in your kitchen?'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Perform search action here
              String query = _searchController.text;
              print('Search query: $query');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search other recipes',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Proteins',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            ..._getIngredientSection(
                'Chicken', 'Beef', 'Fish', _toggleIngredientSelection),
            Container(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Carbohydrates',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            ..._getIngredientSection(
                'Rice', 'Potato', 'Sweet Potato', _toggleIngredientSelection),
            Container(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Fats',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            ..._getIngredientSection(
                'Olive Oil', 'Avocado', 'Nuts', _toggleIngredientSelection),
            Container(
              padding: EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _handleSubmit,
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _getIngredientSection(String ingredient1, String ingredient2,
      String ingredient3, Function(String) toggleIngredientSelection) {
    return [
      _buildIngredientCheckbox(ingredient1, toggleIngredientSelection),
      _buildIngredientCheckbox(ingredient2, toggleIngredientSelection),
      _buildIngredientCheckbox(ingredient3, toggleIngredientSelection),
    ];
  }

  Widget _buildIngredientCheckbox(
      String ingredient, Function(String) toggleIngredientSelection) {
    return Row(
      children: [
        Checkbox(
          value: selectedIngredients.contains(ingredient),
          onChanged: (value) {
            toggleIngredientSelection(ingredient);
          },
        ),
        Text(ingredient),
      ],
    );
  }
}
