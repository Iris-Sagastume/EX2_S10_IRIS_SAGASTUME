// lib/domain/repositories/recipe_repository.dart

// lib/data/repositories/recipe_repository.dart

import 'package:ex2_s10_iris_sgastume/data/models/recipe.dart';

abstract class RecipeRepository {
  Stream<List<Recipe>> getRecipes();
  Future<void> addRecipe(Recipe recipe);
  Future<void> updateRecipe(Recipe recipe);
  Future<void> deleteRecipe(String recipeId);
}
