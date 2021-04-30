import 'dart:convert';

import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia_feature/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

const LAST_CACHED_NUMBER_TRIVIA = 'last_cached_number_trivia';

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPref;

  NumberTriviaLocalDataSourceImpl({this.sharedPref});

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    return sharedPref.setString(LAST_CACHED_NUMBER_TRIVIA, json.encode(triviaToCache.toJson()));
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final String lastCachedString = sharedPref.getString(LAST_CACHED_NUMBER_TRIVIA);
    if (lastCachedString != null) {
      final NumberTriviaModel lastCachedModel =
          NumberTriviaModel.fromJson(json.decode(lastCachedString));
      return Future.value(lastCachedModel);
    } else {
      throw CacheException();
    }
  }
}
