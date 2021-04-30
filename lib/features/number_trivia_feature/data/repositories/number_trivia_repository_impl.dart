import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/core/error/failure.dart';
import 'package:number_trivia/core/network/network_info.dart';
import 'package:number_trivia/features/number_trivia_feature/data/data_sources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia_feature/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia_feature/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia_feature/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia_feature/domain/repositories/number_trivia_repository.dart';

class NumberTriviaRepositoryImpl extends NumberTriviaRepository {
  final NetWorkInfo netWorkInfo;
  final NumberTriviaLocalDataSource numberTriviaLocalDataSource;
  final NumberTriviaRemoteDataSource numberTriviaRemoteDataSource;

  NumberTriviaRepositoryImpl({
    @required this.netWorkInfo,
    @required this.numberTriviaLocalDataSource,
    @required this.numberTriviaRemoteDataSource,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number) async {
    return (await _getTrivia(() => numberTriviaRemoteDataSource.getConcreteNumberTrivia(number)));
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return (await _getTrivia(() => numberTriviaRemoteDataSource.getRandomNumberTrivia()));
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(Future<NumberTriviaModel> conOrRand()) async {
    if (await netWorkInfo.isConnected) {
      try {
        final result = await conOrRand();
        await numberTriviaLocalDataSource.cacheNumberTrivia(result);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final result = await numberTriviaLocalDataSource.getLastNumberTrivia();
        return Right(result);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
