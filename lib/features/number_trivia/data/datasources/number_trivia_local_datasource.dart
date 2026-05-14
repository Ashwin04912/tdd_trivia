import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_trivia/core/error/exceptions.dart';
import 'package:tdd_trivia/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDatasource {
  /// Returns the cached [NumberTriviaModel] from the last successful fetch.
  /// Throws [CacheException] if no cached value exists.
  Future<NumberTriviaModel> getLastNumberTrivia();

  /// Caches [triviaToCache] locally.
  /// Throws [CacheException] if the write fails.
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

// ignore: constant_identifier_names
const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDatasourceImpl implements NumberTriviaLocalDatasource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDatasourceImpl({required this.sharedPreferences});

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() async {
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if (jsonString == null) throw CacheException();
    return NumberTriviaModel.fromJson(
      json.decode(jsonString) as Map<String, dynamic>,
    );
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) async {
    final success = await sharedPreferences.setString(
      CACHED_NUMBER_TRIVIA,
      json.encode(triviaToCache.toJson()),
    );
    if (!success) throw CacheException();
  }
}
