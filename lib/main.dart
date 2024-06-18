// ignore_for_file: library_private_types_in_public_api, prefer_final_fields, prefer_const_constructors

import 'package:ex2_s10_iris_sgastume/data/repositories/firebase_recipe_repository.dart';
import 'package:ex2_s10_iris_sgastume/data/repositories/recipe_repository.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Importa Firebase Core
import 'package:ex2_s10_iris_sgastume/presentation/screens/home_page.dart'; // Importa la pantalla principal
import 'package:ex2_s10_iris_sgastume/presentation/screens/login_page.dart'; // Importa la pantalla de inicio de sesión
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart'; // Importa Firebase Auth

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inicializa Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

   @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<RecipeRepository>(
          create: (_) => FirebaseRecipeRepository(),
        ),
      ],
      child: MaterialApp(
  title: 'Flutter Firebase Recipes',
  theme: ThemeData(
   //primarySwatch: Colors.blue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.blue,
    ).copyWith(
      secondary: Colors.greenAccent,
    ),
  ),
  home: const AuthChecker(),
),
    );
  }
}

class AuthChecker extends StatefulWidget {
  const AuthChecker({Key? key}) : super(key: key);

  @override
  _AuthCheckerState createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          return const LoginPage(); // Si el usuario está autenticado, muestra la pantalla principal
        } else {
          return const HomePage(); // Si no está autenticado, muestra la pantalla de inicio de sesión
        }
      },
    );
  }
}