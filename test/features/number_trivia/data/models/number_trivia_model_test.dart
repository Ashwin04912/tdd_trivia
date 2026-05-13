import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:tdd_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: "Hello");

  test('should be subclass of number trivia entity', () {
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fronJson', () {
    test('should return a valid model when json number is integer', () {
      //arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));

      //act
      final result = NumberTriviaModel.fromJson(jsonMap);

      //assert
      expect(result, tNumberTriviaModel);
    });

    test('should return a valid model when json number is double', () {
      //arrange
      final Map<String, dynamic> jsonMap = json.decode(
        fixture('trivia_double.json'),
      );

      //act
      final result = NumberTriviaModel.fromJson(jsonMap);

      //assert
      expect(result, tNumberTriviaModel);
    });
  });

  group('toJson', () {
    test('should return a json map containing the proper data', () {
      //act
      final result = tNumberTriviaModel.toJson();

      //assert
      final expectedMap = {"text": "Hello", "number": 1};
      expect(result, expectedMap);
    });
  });
}
