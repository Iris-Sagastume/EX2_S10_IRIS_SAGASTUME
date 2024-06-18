import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ex2_s10_iris_sgastume/data/models/recipe.dart';
import 'package:ex2_s10_iris_sgastume/data/repositories/recipe_repository.dart';

class FirebaseRecipeRepository implements RecipeRepository {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('recipes');

    @override
  Stream<List<Recipe>> getRecipes() {
    return collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Recipe.fromSnapshot(doc);
      }).toList();
    });
  }


  @override
  Future<void> addRecipe(Recipe recipe) async {
    await collection.add(recipe.toMap());
  }

  @override
  Future<void> updateRecipe(Recipe recipe) async {
    await collection.doc(recipe.id).update(recipe.toMap());
  }

  @override
  Future<void> deleteRecipe(String recipeId) async {
    await collection.doc(recipeId).delete();
  }
}
