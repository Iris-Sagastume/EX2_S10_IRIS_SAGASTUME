// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, file_names

import 'package:ex2_s10_iris_sgastume/screens/recipe.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class EditRecipeScreen extends StatefulWidget {
  final Recipe recipe;

  const EditRecipeScreen({super.key, required this.recipe, required String recipeId});

  @override
  _EditRecipeScreenState createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late List<String> _ingredients;
  late List<String> _steps;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _name = widget.recipe.name;
    _ingredients = List.from(widget.recipe.ingredients);
    _steps = List.from(widget.recipe.steps);
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveRecipe() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Upload image to Firebase Storage and get URL if an image was selected
      String? imageUrl;
      if (_imageFile != null) {
        // TODO: Upload image to Firebase Storage and get URL
      } else {
        imageUrl = widget.recipe.imageUrl;
      }

      final updatedRecipe = Recipe(
        id: widget.recipe.id,
        name: _name,
        ingredients: _ingredients,
        steps: _steps,
        imageUrl: imageUrl,
      );

      await FirebaseFirestore.instance
          .collection('recipes')
          .doc(updatedRecipe.id)
          .update(updatedRecipe.toMap());

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Recipe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveRecipe,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Recipe Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the recipe name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              const SizedBox(height: 16.0),
              const Text('Ingredients'),
              ..._ingredients.map((ingredient) {
                return ListTile(
                  title: TextFormField(
                    initialValue: ingredient,
                    decoration: const InputDecoration(labelText: 'Ingredient'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an ingredient';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      final index = _ingredients.indexOf(ingredient);
                      _ingredients[index] = value!;
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _ingredients.remove(ingredient);
                      });
                    },
                  ),
                );
              // ignore: unnecessary_to_list_in_spreads
              }).toList(),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _ingredients.add('');
                  });
                },
                child: const Text('Add Ingredient'),
              ),
              const SizedBox(height: 16.0),
              const Text('Steps'),
              ..._steps.map((step) {
                return ListTile(
                  title: TextFormField(
                    initialValue: step,
                    decoration: const InputDecoration(labelText: 'Step'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a step';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      final index = _steps.indexOf(step);
                      _steps[index] = value!;
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _steps.remove(step);
                      });
                    },
                  ),
                );
              // ignore: unnecessary_to_list_in_spreads
              }).toList(),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _steps.add('');
                  });
                },
                child: const Text('Add Step'),
              ),
              const SizedBox(height: 16.0),
              const Text('Recipe Image'),
              _imageFile != null
                  ? Image.file(_imageFile!)
                  : widget.recipe.imageUrl != null
                      ? Image.network(widget.recipe.imageUrl!)
                      : Container(),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Change Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
