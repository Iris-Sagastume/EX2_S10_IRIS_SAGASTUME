// lib/data/models/recipe.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String id;
  final String name;
  final List<String> ingredients;
  final String steps;
  final String? imageUrl;

  Recipe({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.steps,
    this.imageUrl,
  });

  factory Recipe.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Recipe(
      id: snapshot.id,
      name: data['name'] as String,
      ingredients: List<String>.from(data['ingredients']),
      steps: data['steps'] as String,
      imageUrl: data['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ingredients': ingredients,
      'steps': steps,
      'imageUrl': imageUrl,
    };
  }
}
