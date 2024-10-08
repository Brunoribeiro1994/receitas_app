// views/meal_list_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/meal_controller.dart';
import 'meal_detail_view.dart';
import 'favorite_meals_view.dart';

class MealListView extends StatefulWidget {
  const MealListView({Key? key}) : super(key: key);

  @override
  _MealListViewState createState() => _MealListViewState();
}

class _MealListViewState extends State<MealListView> {
  late Future<void> _mealsFuture;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final mealController = Provider.of<MealController>(context, listen: false);
    _mealsFuture = mealController.fetchMeals();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchMeals(String query) {
    final mealController = Provider.of<MealController>(context, listen: false);
    setState(() {
      _mealsFuture = mealController.fetchMeals(query: query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mealController = Provider.of<MealController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Receitas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoriteMealsView(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de pesquisa
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Pesquisar receitas',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _searchMeals(_searchController.text);
                  },
                ),
              ),
              onSubmitted: _searchMeals,
            ),
          ),
          // Lista de receitas
          Expanded(
            child: FutureBuilder(
              future: _mealsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  // Exibe a mensagem de erro detalhada
                  return Center(
                    child: Text('Ocorreu um erro: ${snapshot.error}'),
                  );
                } else {
                  if (mealController.meals.isEmpty) {
                    return const Center(
                      child: Text('Nenhuma receita disponível.'),
                    );
                  }
                  return ListView.builder(
                    itemCount: mealController.meals.length,
                    itemBuilder: (context, index) {
                      final meal = mealController.meals[index];
                      return ListTile(
                        leading: meal.imageUrl.isNotEmpty
                            ? Image.network(
                                meal.imageUrl,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : const SizedBox.shrink(),
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
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
