// views/meal_detail_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/meal.dart';
import '../controllers/meal_controller.dart';

class MealDetailView extends StatelessWidget {
  final Meal meal;

  const MealDetailView({Key? key, required this.meal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mealController = Provider.of<MealController>(context);
    final isFavorite = mealController.isFavorite(meal);

    return Scaffold(
      appBar: AppBar(
        title: Text(meal.name),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
            onPressed: () {
              mealController.toggleFavorite(meal);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(meal.imageUrl),
            const SizedBox(height: 8),
            Text(
              'Ingredientes',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            // Lista de ingredientes
            ...meal.ingredients.map((ingredient) => ListTile(
                  title: Text(ingredient),
                )),
            const SizedBox(height: 8),
            Text(
              'Instruções',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(meal.instructions),
            ),
          ],
        ),
      ),
    );
  }
}
