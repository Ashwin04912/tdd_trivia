import 'package:dartz/dartz.dart';
import 'package:tdd_trivia/core/error/failures.dart';

abstract class Usecase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}
