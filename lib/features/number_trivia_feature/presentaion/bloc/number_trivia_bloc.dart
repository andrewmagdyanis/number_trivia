import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:number_trivia/core/error/failure.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/features/number_trivia_feature/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia_feature/domain/use_cases/get_concerete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia_feature/domain/use_cases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';

part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    @required GetRandomNumberTrivia random,
    @required GetConcreteNumberTrivia concrete,
    @required this.inputConverter,
  })  : assert(concrete != null),
        assert(random != null),
        assert(inputConverter != null),
        getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random;

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumber) {
      final inputEither = inputConverter.stringToUnsignedInt(event.number);
      yield* inputEither.fold(
        (failure) async* {
          yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
        },
        (number) async* {
          yield Loading();
          final failureOrTrivia = await getConcreteNumberTrivia(Params(number: number));
          yield failureOrTrivia.fold(
            (f) => Error(message: _mapFailureToMessage(f)),
            (t) => Loaded(trivia: t),
          );
        },
      );
    } else if (event is GetTriviaForRandomNumber) {
      yield Loading();
      final failureOrTrivia = await getRandomNumberTrivia(NoParams());
      yield failureOrTrivia.fold(
        (f) => Error(message: _mapFailureToMessage(f)),
        (t) => Loaded(trivia: t),
      );
    } else {}
  }

  @override
  NumberTriviaState get initialState => Empty();

  String _mapFailureToMessage(Failure failure) {
    // Instead of a regular 'if (failure is ServerFailure)...'
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
