import 'package:dio/dio.dart';

import 'meal_dto.dart';

/// Talks HTTP, nothing else: sends the request with Dio and turns the JSON
/// into DTOs. It doesn't know about the domain model or the UI.
class RecipeApiService {
  const RecipeApiService(this._dio);

  final Dio _dio;

  /// `search.php?s=` with an empty query returns a list of complete meals
  /// (ingredients included), so one request is enough for Home and Details.
  Future<List<MealDto>> fetchMeals() async {
    final response = await _dio.get<Map<String, dynamic>>(
      'search.php',
      queryParameters: {'s': ''},
    );
    // TheMealDB returns {"meals": null} when there are no results.
    final meals = response.data?['meals'] as List<dynamic>? ?? [];
    return meals
        .map((json) => MealDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
