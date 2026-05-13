import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tdd_trivia/core/error/failures.dart';
import 'package:tdd_trivia/core/usecases/usecase.dart';
import 'package:tdd_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_trivia/features/number_trivia/domain/repositories/number_trivia_repo.dart';

//usecase<output, input>

class GetRandomNumberTrivia implements Usecase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia({required this.repository});

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await repository.getRandomNumberTrivia();
  }
}

class NoParams extends Equatable{

  @override
  List<Object?> get props => [];
  
}

