import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_trivia/core/error/failures.dart';

import 'package:tdd_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:tdd_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cache Failure';
const String invalidInputFailureMessage =
    'Invalid Input – the number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
  }) : super(NumberTriviaInitial()) {
    on<GetTriviaForConcreteNumber>(_onGetTriviaForConcreteNumber);
    on<GetTriviaForRandomNumber>(_onGetTriviaForRandomNumber);
  }

  Future<void> _onGetTriviaForConcreteNumber(
    GetTriviaForConcreteNumber event,
    Emitter<NumberTriviaState> emit,
  ) async {
    final inputEither = _parseNumber(event.numberString);

    await inputEither.fold(
      // Left — invalid input
      (failure) async {
        emit(const NumberTriviaError(message: invalidInputFailureMessage));
      },
      // Right — valid integer, call use case
      (integer) async {
        emit(NumberTriviaLoading());
        final failureOrTrivia = await getConcreteNumberTrivia(
          Params(number: integer),
        );
        _emitFromEither(emit, failureOrTrivia);
      },
    );
  }

  Future<void> _onGetTriviaForRandomNumber(
    GetTriviaForRandomNumber event,
    Emitter<NumberTriviaState> emit,
  ) async {
    emit(NumberTriviaLoading());
    final failureOrTrivia = await getRandomNumberTrivia(NoParams());
    _emitFromEither(emit, failureOrTrivia);
  }

  // ─── helpers ───────────────────────────────────────────────────────────────

  /// Tries to parse [str] into a non-negative integer.
  Either<Failure, int> _parseNumber(String str) {
    final trimmed = str.trim();
    final parsed = int.tryParse(trimmed);
    if (parsed == null || parsed < 0) {
      // We re-use CacheFailure as a stand-in; the message is what matters.
      return Left(CacheFailure());
    }
    return Right(parsed);
  }

  void _emitFromEither(
    Emitter<NumberTriviaState> emit,
    Either<Failure, NumberTrivia> failureOrTrivia,
  ) {
    failureOrTrivia.fold(
      (failure) => emit(
        NumberTriviaError(message: _mapFailureToMessage(failure)),
      ),
      (trivia) => emit(NumberTriviaLoaded(trivia: trivia)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure) {
      case ServerFailure():
        return serverFailureMessage;
      case CacheFailure():
        return cacheFailureMessage;
      default:
        return 'Unexpected error';
    }
  }
}
