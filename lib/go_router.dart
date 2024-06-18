import 'package:ex2_s10_iris_sgastume/screens/recipe.dart';
import 'screens/editrecipescreen .dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'screens/signinscreen.dart';
import 'screens/signupscreen.dart';
import 'screens/resetpasswordscreen.dart';
import 'screens/homescreen.dart';
import 'screens/addrecipescreen.dart';
import 'screens/searchscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/sign_up',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/reset_password',
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/add',
        builder: (context, state) => const AddRecipeScreen(),
      ),
      GoRoute(
  path: '/edit/:id',
  builder: (context, state) {
    final id = state.params['id']!;
    // Aquí, si recipe es null, se crea una nueva instancia de Recipe
    final recipe = Recipe(id: id, name: '', ingredients: [], steps: []);
    return EditRecipeScreen(recipeId: id, recipe: recipe);
  },
),
      GoRoute(
        path: '/search',
        builder: (context, state) => SearchScreen(),
      ),
    ],
  );

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      title: 'Recetas App',
    );
  }
}
