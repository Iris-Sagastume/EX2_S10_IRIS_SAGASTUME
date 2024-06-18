// lib/domain/usecases/recipe_usecase.dart

import 'package:ex2_s10_iris_sgastume/data/models/recipe.dart';
import 'package:ex2_s10_iris_sgastume/data/repositories/recipe_repository.dart';

class RecipeUseCase {
  final RecipeRepository repository;

  RecipeUseCase(this.repository);

  Stream<List<Recipe>> getRecipes() {
    return repository.getRecipes();
  }

  Future<void> addRecipe(Recipe recipe) {
    return repository.addRecipe(recipe);
  }

  Future<void> updateRecipe(Recipe recipe) {
    return repository.updateRecipe(recipe);
  }

  Future<void> deleteRecipe(String recipeId) {
    return repository.deleteRecipe(recipeId);
  }
}
