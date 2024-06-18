import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
  final Stream<QuerySnapshot> _recipesStream = FirebaseFirestore.instance.collection('recipes').snapshots();

  SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(hintText: 'Buscar Recetas'),
          onChanged: (value) {
            // Refrescar la lista basada en el término de búsqueda
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _recipesStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Algo salió mal');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Cargando...");
          }

          final results = snapshot.data!.docs.where((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            return data['name'].toLowerCase().contains(_searchController.text.toLowerCase());
          }).toList();

          return ListView(
            children: results.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(data['name']),
                subtitle: Text(data['ingredients'].join(', ')),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
