import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia_feature/data/data_sources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia_feature/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

import '../../../fixtures/fixture_reader.dart';

class MockSharedPref extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSourceImpl dataSource;
  MockSharedPref mockSharedPref;
  NumberTriviaModel numberTriviaModel;
  setUp(() {
    mockSharedPref = MockSharedPref();
    dataSource = NumberTriviaLocalDataSourceImpl(sharedPref:mockSharedPref);
    numberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('cached_res.json')));
  });

  group('getLastNumberTrivia', () {

    test('should return NumberTrivia from SharedPreferences when there is one in the cache',() async {
      when(mockSharedPref.getString(any)).thenReturn(fixture('cached_res.json'));
      final result =await dataSource.getLastNumberTrivia();
      verify(mockSharedPref.getString(LAST_CACHED_NUMBER_TRIVIA));
      expect(result,numberTriviaModel);
    });


    test('should throw a CacheException when there is not a cached value',()  {
      when(mockSharedPref.getString(any)).thenReturn(null);
      final call = dataSource.getLastNumberTrivia;
      expect(()  =>  call(), throwsA(TypeMatcher<CacheException>()));
    });
  });

  group ('cacheNumberTrivia',(){


    test('should call SharedPreferences to cache the data',(){

      dataSource.cacheNumberTrivia(numberTriviaModel);
      final String cachedString = json.encode( numberTriviaModel.toJson());
      verify(mockSharedPref.setString(LAST_CACHED_NUMBER_TRIVIA,cachedString));
      
    });
  });
}
