import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ex2_s10_iris_sgastume/data/models/recipe.dart';
import 'package:ex2_s10_iris_sgastume/data/repositories/recipe_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditRecipePage extends StatefulWidget {
  final Recipe? recipe;

  const EditRecipePage({Key? key, this.recipe}) : super(key: key);

  @override
  _EditRecipePageState createState() => _EditRecipePageState();
}

class _EditRecipePageState extends State<EditRecipePage> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late List<String> _ingredients;
  late String _steps;
  String? _imageUrl;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    if (widget.recipe != null) {
      _name = widget.recipe!.name;
      _ingredients = widget.recipe!.ingredients;
      _steps = widget.recipe!.steps;
      _imageUrl = widget.recipe!.imageUrl;
    } else {
      _name = '';
      _ingredients = [];
      _steps = '';
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipeRepository = Provider.of<RecipeRepository>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe == null ? 'Agregar receta' : 'Editar Receta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Nombre de la receta'),
                onSaved: (value) => _name = value!,
                validator: (value) => value!.isEmpty ? 'Por favor ingrese el nombre de la receta' : null,
              ),
              TextFormField(
                initialValue: _ingredients.join(', '),
                decoration: const InputDecoration(labelText: 'Ingredientess (comma separated)'),
                onSaved: (value) => _ingredients = value!.split(',').map((e) => e.trim()).toList(),
                validator: (value) => value!.isEmpty ? 'Por favor introduce los ingredientes' : null,
              ),
              TextFormField(
                initialValue: _steps,
                decoration: const InputDecoration(labelText: 'Procedimiento'),
                onSaved: (value) => _steps = value!,
                validator: (value) => value!.isEmpty ? 'Por favor ingresa el procedimiento' : null,
              ),
              const SizedBox(height: 20),
              _imageFile != null
                  ? Image.file(_imageFile!)
                  : _imageUrl != null
                      ? Image.network(_imageUrl!)
                      : Container(),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Link Image'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    final newRecipe = Recipe(
                      id: widget.recipe?.id ?? '',
                      name: _name,
                      ingredients: _ingredients,
                      steps: _steps,
                      imageUrl: _imageUrl,
                    );

                    if (widget.recipe == null) {
                      await recipeRepository.addRecipe(newRecipe);
                    } else {
                      await recipeRepository.updateRecipe(newRecipe);
                    }

                    Navigator.pop(context);
                  }
                },
                child: Text(widget.recipe == null ? 'Agrear Receta' : 'Eliminar Receta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
