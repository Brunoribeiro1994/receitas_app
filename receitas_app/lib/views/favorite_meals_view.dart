// views/favorite_meals_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/meal_controller.dart';
import 'meal_detail_view.dart';

class FavoriteMealsView extends StatelessWidget {
  const FavoriteMealsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mealController = Provider.of<MealController>(context);
    final favoriteMeals = mealController.favoriteMeals;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),
      body: favoriteMeals.isEmpty
          ? const Center(
              child: Text('Nenhuma receita favoritada.'),
            )
          : ListView.builder(
              itemCount: favoriteMeals.length,
              itemBuilder: (context, index) {
                final meal = favoriteMeals[index];
                return ListTile(
                  leading: Image.network(meal.imageUrl),
                  title: Text(meal.name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MealDetailView(meal: meal),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
