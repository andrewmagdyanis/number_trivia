import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/core/error/failure.dart';
import 'package:number_trivia/core/network/network_info.dart';
import 'package:number_trivia/features/number_trivia_feature/data/data_sources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia_feature/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia_feature/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia_feature/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia/features/number_trivia_feature/domain/entities/number_trivia.dart';

class MockRemoteDataSource extends Mock implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetWorkInfo {}

void main() {
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  NumberTriviaRepositoryImpl repo;
  final int tNumber = 1;
  final tNumberTriviaModel = NumberTriviaModel(number: tNumber, text: 'test trivia');
  final NumberTrivia tNumberTrivia = tNumberTriviaModel;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockLocalDataSource = MockLocalDataSource();
    mockRemoteDataSource = MockRemoteDataSource();
    repo = NumberTriviaRepositoryImpl(
      netWorkInfo: mockNetworkInfo,
      numberTriviaLocalDataSource: mockLocalDataSource,
      numberTriviaRemoteDataSource: mockRemoteDataSource,
    );
  });

  group('getConcreteNumberTrivia', () {
    test('should check if the device is online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((realInvocation) async => true);
      await repo.getConcreteNumberTrivia(tNumber);
      verify(mockNetworkInfo.isConnected);
    });
  });

  group('device is online', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((realInvocation) async => true);
    });
    test('should return remote data when the call to remote data source is successful', () async {
      when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
          .thenAnswer((value) async => tNumberTriviaModel);

      final result = await repo.getConcreteNumberTrivia(tNumber);
      verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
      expect(result, equals(Right(tNumberTrivia)));
    });

    test('should cache the data locally when the call to remote data source is successful',
        () async {
      when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
          .thenAnswer((realInvocation) async => tNumberTriviaModel);
      await repo.getConcreteNumberTrivia(tNumber);
      verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
      verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
    });


    test('should return server failure when the call to remote data source is failed', () async {
      when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
          .thenThrow(ServerException());

      final result = await repo.getConcreteNumberTrivia(tNumber);
      verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
      verifyZeroInteractions(mockLocalDataSource);
      expect(result, equals(Left(ServerFailure())));
    });
  });

  group('device is offline', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((realInvocation) async => false);
    });

    test('should return cached data when cached data is present',
            () async {
          when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
              .thenAnswer((realInvocation) async => tNumberTriviaModel);
          await repo.getConcreteNumberTrivia(tNumber);
          verify(mockLocalDataSource.getLastNumberTrivia());
        });


    test('should return cache exception when cached data isnot present',
            () async {
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          final result = await repo.getConcreteNumberTrivia(tNumber);

          expect(result, equals(Left(CacheFailure())));

        });


  });


  //// random

  group('getRandomNumberTrivia', () {
    test('should check if the device is online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((realInvocation) async => true);
      await repo.getRandomNumberTrivia();
      verify(mockNetworkInfo.isConnected);
    });
  });

  group('device is online', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((realInvocation) async => true);
    });
    test('should return remote data when the call to remote data source is successful', () async {
      when(mockRemoteDataSource.getRandomNumberTrivia())
          .thenAnswer((value) async => tNumberTriviaModel);

      final result = await repo.getRandomNumberTrivia();
      verify(mockRemoteDataSource.getRandomNumberTrivia());
      expect(result, equals(Right(tNumberTrivia)));
    });

    test('should cache the data locally when the call to remote data source is successful',
            () async {
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((realInvocation) async => tNumberTriviaModel);
          await repo.getRandomNumberTrivia();
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        });


    test('should return server failure when the call to remote data source is failed', () async {
      when(mockRemoteDataSource.getRandomNumberTrivia())
          .thenThrow(ServerException());

      final result = await repo.getRandomNumberTrivia();
      verify(mockRemoteDataSource.getRandomNumberTrivia());
      verifyZeroInteractions(mockLocalDataSource);
      expect(result, equals(Left(ServerFailure())));
    });
  });

  group('device is offline', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((realInvocation) async => false);
    });

    test('should return cached data when cached data is present',
            () async {
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((realInvocation) async => tNumberTriviaModel);
          await repo.getRandomNumberTrivia();
          verify(mockLocalDataSource.getLastNumberTrivia());
        });


    test('should return cache exception when cached data isnot present',
            () async {
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          final result = await repo.getRandomNumberTrivia();

          expect(result, equals(Left(CacheFailure())));

        });


  });
}
