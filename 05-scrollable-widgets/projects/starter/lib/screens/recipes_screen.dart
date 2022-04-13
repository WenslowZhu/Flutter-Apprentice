import 'package:flutter/material.dart';
import '../models/simple_recipe.dart';
import '../components/components.dart';
import '../api/mock_fooderlich_service.dart';

class RecipesScreen extends StatelessWidget {
  final exploreService = MockFooderlichService();

  RecipesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: exploreService.getRecipes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done
         && snapshot.data != null) {
           final recipes = snapshot.data! as List<SimpleRecipe>;
           return RecipesGridView(recipes: recipes);
        }
        return const Center(child: CircularProgressIndicator(),);
      }
    );
  }
}