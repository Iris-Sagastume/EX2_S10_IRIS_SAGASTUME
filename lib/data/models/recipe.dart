import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String id;
  final String name;
  final List<String> ingredients;
  final String steps;
  final String? imageUrl;
  bool isFavorite; // Nueva propiedad para indicar si la receta es favorita

  Recipe({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.steps,
    this.imageUrl,
    this.isFavorite = false, // Valor por defecto
  });

  factory Recipe.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Recipe(
      id: snapshot.id,
      name: data['name'] as String,
      ingredients: List<String>.from(data['ingredients']),
      steps: data['steps'] as String,
      imageUrl: data['imageUrl'] as String?,
      isFavorite: data['isFavorite'] ?? false, // Inicializar desde Firebase
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ingredients': ingredients,
      'steps': steps,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite, // Incluir isFavorite al guardar en Firebase
    };
  }
}

