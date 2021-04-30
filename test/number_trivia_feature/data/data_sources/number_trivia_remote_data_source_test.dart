import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia_feature/data/data_sources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia_feature/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia_feature/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

import '../../../fixtures/fixture_reader.dart';
import 'package:http/http.dart' as http;

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;
  NumberTriviaModel numberTriviaModel;
  var tNumber =1;
  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(httpClient:mockHttpClient);
    numberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('cached_res.json')));
  });

  group('getConcreteNumberTrivia', () {
    test(
        'should preform a GET request on a URL with '
        'number being the endpoint and with application/json header', () async {
      when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
            (realInvocation) async => http.Response(fixture('response.json'), 200));
        final result = await dataSource.getConcreteNumberTrivia(tNumber);
        verify(mockHttpClient.get(
          'http://numbersapi.com/$tNumber',
          headers: {'Content-Type': 'application/json'},
        ));
        expect(result , numberTriviaModel);

    });

    test(
      'should throw a ServerException when the response code is 404 or other',
          () async {
        // arrange
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
              (_) async => http.Response('Something went wrong', 404),
        );
        // act
        final call = dataSource.getConcreteNumberTrivia;
        // assert
        expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });


  group('getRandomNumberTrivia', () {
    test(
        'should preform a GET request on a URL with '
            'number being the endpoint and with application/json header', () async {
      when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
              (realInvocation) async => http.Response(fixture('response.json'), 200));
      final result = await dataSource.getRandomNumberTrivia();
      verify(mockHttpClient.get(
        'http://numbersapi.com/random',
        headers: {'Content-Type': 'application/json'},
      ));
      expect(result , numberTriviaModel);

    });

    test(
      'should throw a ServerException when the response code is 404 or other',
          () async {
        // arrange
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
              (_) async => http.Response('Something went wrong', 404),
        );
        // act
        final call = dataSource.getRandomNumberTrivia;
        // assert
        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
