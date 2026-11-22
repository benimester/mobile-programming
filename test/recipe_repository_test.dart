import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/features/recipes/data/meal_dto.dart';
import 'package:mobile/features/recipes/data/recipe_api_service.dart';
import 'package:mobile/features/recipes/data/recipe_repository.dart';

/// API service that fails with the given error instead of calling the network.
class _FailingApiService implements RecipeApiService {
  _FailingApiService(this.error);

  final Object error;

  @override
  Future<List<MealDto>> fetchMeals() async => throw error;
}

void main() {
  test('a Dio error becomes a RecipeException with a specific message', () {
    final repository = RecipeRepository(
      _FailingApiService(
        DioException.connectionError(
          requestOptions: RequestOptions(),
          reason: 'offline',
        ),
      ),
    );

    expect(
      repository.getRecipes(),
      throwsA(
        isA<RecipeException>().having(
          (e) => e.message,
          'message',
          'No internet connection.',
        ),
      ),
    );
  });

  test('any other error becomes a RecipeException with a generic message', () {
    final repository = RecipeRepository(
      _FailingApiService(const FormatException('bad JSON')),
    );

    expect(
      repository.getRecipes(),
      throwsA(
        isA<RecipeException>().having(
          (e) => e.message,
          'message',
          'Something went wrong while loading recipes.',
        ),
      ),
    );
  });
}
