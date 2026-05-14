import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_trivia/core/error/exceptions.dart';
import 'package:tdd_trivia/core/error/failures.dart';
import 'package:tdd_trivia/core/network/network_info.dart';
import 'package:tdd_trivia/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:tdd_trivia/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:tdd_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:tdd_trivia/features/number_trivia/data/repositories/number_trivia_repo_impl.dart';
import 'package:tdd_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import 'number_trivia_repo_impl_test.mocks.dart';

@GenerateMocks([
  NumberTriviaRemoteDatasource,
  NumberTriviaLocalDatasource,
  NetworkInfo,
])
void main() {
  late NumberTriviaRepoImpl repository;
  late MockNumberTriviaRemoteDatasource mockRemoteDatasource;
  late MockNumberTriviaLocalDatasource mockLocalDatasource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDatasource = MockNumberTriviaRemoteDatasource();
    mockLocalDatasource = MockNumberTriviaLocalDatasource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepoImpl(
      remoteDatasource: mockRemoteDatasource,
      localDatasource: mockLocalDatasource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(text: 'Test', number: tNumber);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should return remote data when called remotedatasource is successfull',
        () async {
          //arrange
          when(
            mockRemoteDatasource.getConcreteNumberTrivia(any),
          ).thenAnswer((_) async => tNumberTriviaModel);
          //act
          final result = await repository.getConcreteNumberTrivia(tNumber);

          //assert
          verify(mockRemoteDatasource.getConcreteNumberTrivia(tNumber));
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'should cache the data locally when called remotedatasource is successfull',
        () async {
          //arrange
          when(
            mockRemoteDatasource.getConcreteNumberTrivia(any),
          ).thenAnswer((_) async => tNumberTriviaModel);

          //act
          await repository.getConcreteNumberTrivia(tNumber);

          //assert
          verify(mockLocalDatasource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );

      test(
        'should return serverFailure when called remotedatasource is unsuccessfull',
        () async {
          //arrange
          when(
            mockRemoteDatasource.getConcreteNumberTrivia(any),
          ).thenThrow(ServerException());

          //act
          final result = await repository.getConcreteNumberTrivia(tNumber);

          //assert
          verify(mockRemoteDatasource.getConcreteNumberTrivia(tNumber));
          verifyZeroInteractions(mockLocalDatasource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });


    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(
            mockLocalDatasource.getLastNumberTrivia(),
          ).thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verifyZeroInteractions(mockRemoteDatasource);
          verify(mockLocalDatasource.getLastNumberTrivia());
          expect(result, Right(tNumberTrivia));
        },
      );

      test(
        'should return CacheFailure when there is NO cached data present',
        () async {
          // arrange
          when(
            mockLocalDatasource.getLastNumberTrivia(),
          ).thenThrow(CacheException());

          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);

          // assert
          verifyZeroInteractions(mockRemoteDatasource);
          verify(mockLocalDatasource.getLastNumberTrivia());
          expect(result, Left(CacheFailure()));
        },
      );
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(text: 'Test', number: tNumber);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

   group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      test(
        'should return remote data when called remotedatasource is successfull',
        () async {
          //arrange
          when(
            mockRemoteDatasource.getRandomNumberTrivia(),
          ).thenAnswer((_) async => tNumberTriviaModel);

          //act
          final result = await repository.getRandomNumberTrivia();

          //assert
          verify(mockRemoteDatasource.getRandomNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'should cache the data locally when called remotedatasource is successfull',
        () async {
          //arrange
          when(
            mockRemoteDatasource.getRandomNumberTrivia(),
          ).thenAnswer((_) async => tNumberTriviaModel);

          //act
          await repository.getRandomNumberTrivia();

          //assert
          verify(mockLocalDatasource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );

      test(
        'should return serverFailure when called remotedatasource is unsuccessfull',
        () async {
          //arrange
          when(
            mockRemoteDatasource.getRandomNumberTrivia(),
          ).thenThrow(ServerException());

          //act
          final result = await repository.getRandomNumberTrivia();

          //assert
          verify(mockRemoteDatasource.getRandomNumberTrivia());
          verifyZeroInteractions(mockLocalDatasource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(
            mockLocalDatasource.getLastNumberTrivia(),
          ).thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verifyZeroInteractions(mockRemoteDatasource);
          verify(mockLocalDatasource.getLastNumberTrivia());
          expect(result, Right(tNumberTrivia));
        },
      );

      test(
        'should return CacheFailure when there is NO cached data present',
        () async {
          // arrange
          when(
            mockLocalDatasource.getLastNumberTrivia(),
          ).thenThrow(CacheException());

          // act
          final result = await repository.getRandomNumberTrivia();

          // assert
          verifyZeroInteractions(mockRemoteDatasource);
          verify(mockLocalDatasource.getLastNumberTrivia());
          expect(result, Left(CacheFailure()));
        },
      );
    });
  });
}
