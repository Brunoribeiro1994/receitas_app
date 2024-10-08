// controllers/meal_controller.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/meal.dart';

class MealController with ChangeNotifier {
  List<Meal> _meals = [];
  List<Meal> _favoriteMeals = [];
  String _searchQuery = ''; // Nova propriedade

  List<Meal> get meals => _meals;
  List<Meal> get favoriteMeals => _favoriteMeals;
  String get searchQuery => _searchQuery;

  Future<void> fetchMeals({String query = ''}) async {
    try {
      _searchQuery = query; // Atualiza a consulta de pesquisa atual
      final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s=$query'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data == null || data['meals'] == null) {
          _meals = []; // Nenhuma receita encontrada
        } else {
          final List<dynamic> mealsJson = data['meals'];
          _meals = mealsJson.map((json) => Meal.fromJson(json)).toList();
        }
        notifyListeners();
      } else {
        throw Exception('Falha ao carregar as receitas. Código: ${response.statusCode}');
      }
    } catch (error) {
      print('Erro ao buscar as receitas: $error');
      throw error;
    }
  }

  void toggleFavorite(Meal meal) {
    if (_favoriteMeals.contains(meal)) {
      _favoriteMeals.remove(meal);
    } else {
      _favoriteMeals.add(meal);
    }
    notifyListeners();
  }

  bool isFavorite(Meal meal) {
    return _favoriteMeals.contains(meal);
  }
}
