import 'dart:convert';

import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia_feature/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client httpClient;

  NumberTriviaRemoteDataSourceImpl({this.httpClient});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    final response = await httpClient.get(
      'http://numbersapi.com/$number',
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw ServerException();
    } else {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    }
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    final response = await httpClient.get(
      'http://numbersapi.com/random',
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw ServerException();
    } else {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    }  }
}
