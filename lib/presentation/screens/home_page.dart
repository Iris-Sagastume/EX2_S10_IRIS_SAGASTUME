import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ex2_s10_iris_sgastume/data/models/recipe.dart';
import 'package:ex2_s10_iris_sgastume/data/repositories/recipe_repository.dart';
import 'package:ex2_s10_iris_sgastume/presentation/screens/edit_recipe_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _searchController;
  late Stream<List<Recipe>> _recipesStream;
  late List<Recipe> _recipes = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _recipesStream = Provider.of<RecipeRepository>(context, listen: false).getRecipes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchRecipes(String query) {
    setState(() {
      _recipes = _recipes
          .where((recipe) => recipe.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final recipeRepository = Provider.of<RecipeRepository>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Recetas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditRecipePage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Buscar recetas por nombre',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _searchRecipes,
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Recipe>>(
              stream: _recipesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No hay recetas disponibles.'));
                }

                _recipes = snapshot.data!; // Guardar todas las recetas
                if (_searchController.text.isNotEmpty) {
                  _recipes = _recipes
                      .where((recipe) =>
                          recipe.name.toLowerCase().contains(_searchController.text.toLowerCase()))
                      .toList();
                }

                if (_recipes.isEmpty) {
                  return const Center(child: Text('No se encontraron recetas.'));
                }

                return ListView.builder(
                  itemCount: _recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = _recipes[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(recipe.name),
                        subtitle: Text(recipe.ingredients.join(', ')),
                        trailing: Container(
                          width: 100,
                          color: Colors.white.withOpacity(0.8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditRecipePage(recipe: recipe),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Confirmar Eliminación'),
                                      content: const Text('¿Estás seguro de eliminar esta receta?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            recipeRepository.deleteRecipe(recipe.id);
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Eliminar'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}