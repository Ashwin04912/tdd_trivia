import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tdd_trivia/core/constants/app_constants.dart';
import 'package:tdd_trivia/core/error/exceptions.dart';
import 'package:tdd_trivia/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDatasource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDatasourceImpl implements NumberTriviaRemoteDatasource {
  final http.Client client;

  NumberTriviaRemoteDatasourceImpl({required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) =>
      _fetchTrivia(AppConstants.concreteNumberUrl(number));

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() =>
      _fetchTrivia(AppConstants.randomNumberUrl);

  // ── shared fetch helper ───────────────────────────────────────────────────

  Future<NumberTriviaModel> _fetchTrivia(String url) async {
    final response = await client.get(
      Uri.parse(url),
      headers: AppConstants.jsonHeaders,
    );

    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(
        json.decode(response.body) as Map<String, dynamic>,
      );
    }
    throw ServerException();
  }
}
