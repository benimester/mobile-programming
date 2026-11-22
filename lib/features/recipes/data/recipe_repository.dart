import 'package:dio/dio.dart';

import '../models/recipe.dart';
import 'recipe_api_service.dart';

/// Single source of truth for recipes. The rest of the app only sees domain
/// [Recipe]s and [RecipeException]s, never Dio, JSON or DTOs.
class RecipeRepository {
  const RecipeRepository(this._api);

  final RecipeApiService _api;

  static const _genericMessage = 'Something went wrong while loading recipes.';

  Future<List<Recipe>> getRecipes() async {
    try {
      final dtos = await _api.fetchMeals();
      // Invalid meals map to null and are dropped.
      return dtos.map((dto) => dto.toRecipe()).nonNulls.toList();
    } on DioException catch (e) {
      throw RecipeException(_messageFor(e));
    } catch (_) {
      // Anything else (e.g. unexpected JSON shape -> TypeError/FormatException):
      // the UI still only ever has to handle a RecipeException.
      throw const RecipeException(_genericMessage);
    }
  }

  /// Turns a technical Dio error into a message the user can read.
  String _messageFor(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'The server is taking too long to respond.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      case DioExceptionType.badResponse:
        return 'The server returned an error (${e.response?.statusCode}).';
      default:
        return _genericMessage;
    }
  }
}

/// Error the UI can show directly, through [message].
class RecipeException implements Exception {
  const RecipeException(this.message);

  final String message;

  @override
  String toString() => message;
}
