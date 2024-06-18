// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recetas')),
      body: RecipeList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/add');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class RecipeList extends StatelessWidget {
  final Stream<QuerySnapshot> _recipesStream = FirebaseFirestore.instance.collection('recipes').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _recipesStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Algo salió mal');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Cargando...");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            return ListTile(
              title: Text(data['name']),
              subtitle: Text(data['ingredients'].join(', ')),
              onTap: () {
                context.go('/edit/${document.id}');
              },
            );
          }).toList(),
        );
      },
    );
  }
}
