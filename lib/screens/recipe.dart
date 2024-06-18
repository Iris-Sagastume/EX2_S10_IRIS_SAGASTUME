class Recipe {
  final String name;
  final List<String> ingredients;
  final List<String> steps;
  final String? photoUrl;

  Recipe({required this.name, required this.ingredients, required this.steps, this.photoUrl, required id, String? imageUrl});

  String? get id => null;

  get imageUrl => null;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ingredients': ingredients,
      'steps': steps,
      'photoUrl': photoUrl,
    };
  }

  Recipe.fromMap(Map<String, dynamic> map)
    : name = map['name'],
      ingredients = List<String>.from(map['ingredients']),
      steps = List<String>.from(map['steps']),
      photoUrl = map['photoUrl'];
}
