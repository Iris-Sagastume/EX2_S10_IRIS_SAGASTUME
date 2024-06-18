// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  late String name;
  late List<String> ingredients = [];
  late List<String> steps = [];
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        // ignore: avoid_print
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Añadir Receta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                onChanged: (value) {
                  name = value;
                },
                decoration: const InputDecoration(labelText: 'Nombre de la receta'),
              ),
              TextFormField(
                onChanged: (value) {
                  ingredients = value.split(',');
                },
                decoration: const InputDecoration(labelText: 'Ingredientes (separados por comas)'),
              ),
              TextFormField(
                onChanged: (value) {
                  steps = value.split(',');
                },
                decoration: const InputDecoration(labelText: 'Pasos (separados por comas)'),
              ),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Añadir Foto'),
              ),
              _image == null ? Container() : Image.file(_image!),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _firestore.collection('recipes').add({
                      'name': name,
                      'ingredients': ingredients,
                      'steps': steps,
                      'photoUrl': _image?.path,
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('Guardar Receta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
