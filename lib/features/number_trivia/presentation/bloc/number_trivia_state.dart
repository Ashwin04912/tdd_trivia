part of 'number_trivia_bloc.dart';

sealed class NumberTriviaState extends Equatable {
  const NumberTriviaState();

  @override
  List<Object> get props => [];
}

// Initial / empty state
final class NumberTriviaInitial extends NumberTriviaState {}

// While the use case is running
final class NumberTriviaLoading extends NumberTriviaState {}

// Use case returned successfully
final class NumberTriviaLoaded extends NumberTriviaState {
  final NumberTrivia trivia;

  const NumberTriviaLoaded({required this.trivia});

  @override
  List<Object> get props => [trivia];
}

// Use case returned a failure
final class NumberTriviaError extends NumberTriviaState {
  final String message;

  const NumberTriviaError({required this.message});

  @override
  List<Object> get props => [message];
}
