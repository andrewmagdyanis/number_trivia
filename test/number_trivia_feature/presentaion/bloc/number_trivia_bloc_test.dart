import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/failure.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/features/number_trivia_feature/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia_feature/domain/use_cases/get_concerete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia_feature/domain/use_cases/get_random_number_trivia.dart';
import 'package:number_trivia/features/number_trivia_feature/presentaion/bloc/number_trivia_bloc.dart';

class MockGetConcreteNumberTrivia extends Mock implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;
  NumberTriviaBloc bloc;
  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      random: mockGetRandomNumberTrivia,
      concrete: mockGetConcreteNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });
  group('concrete number trivia bloc', () {
    final tNumberString = '1';
    final tNumberParsed = int.parse(tNumberString);
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    test('initial should be empty', () {
      expect(bloc.initialState, Empty());
    });

    test(
        'should call the input converter '
        'and convert the string to an unsigned int', () async {
      when(mockInputConverter.stringToUnsignedInt(tNumberString)).thenReturn(Right(tNumberParsed));
      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInt(any));

      verify(mockInputConverter.stringToUnsignedInt(tNumberString));
    });

    test('should emit [Error] when the input is invalid', () async {
      when(mockInputConverter.stringToUnsignedInt(tNumberString))
          .thenReturn(Left(InvalidInputFailure()));
      final expectedValues = [
        Empty(),
        Error(message: INVALID_INPUT_FAILURE_MESSAGE),
      ];
      expectLater(bloc.state, emitsInOrder(expectedValues));
      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
    });

    test('should emit [NumberTrivia] when the input is valid', () async {
      when(mockInputConverter.stringToUnsignedInt(tNumberString)).thenReturn(Right(tNumberParsed));
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((realInvocation) async => Right(tNumberTrivia));
      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));
      // assert
      verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
    });

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInt(any)).thenReturn(Right(tNumberParsed));
        when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async => Right(tNumberTrivia));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Loaded(trivia: tNumberTrivia),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test('should emit [Loading, Error] when getting data fails', () {
      // arrange
      when(mockInputConverter.stringToUnsignedInt(any)).thenReturn(Right(tNumberParsed));
      when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async => Left(ServerFailure()));
      final expected = [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
    });

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInt(any)).thenReturn(Right(tNumberParsed));
        when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      },
    );
  });

  group('random number trivia bloc', () {
    final tNumberString = '1';
    final tNumberParsed = int.parse(tNumberString);
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    test('initial should be empty', () {
      expect(bloc.initialState, Empty());
    });

    test('should get data from the random use case', () async {
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((realInvocation) async => Right(tNumberTrivia));
      bloc.dispatch(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(any));
      // assert
      verify(mockGetRandomNumberTrivia(any));
    });

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async => Right(tNumberTrivia));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Loaded(trivia: tNumberTrivia),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetTriviaForRandomNumber());
      },
    );

    test('should emit [Loading, Error] when getting data fails', () {
      // arrange
      when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async => Left(ServerFailure()));
      final expected = [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      bloc.dispatch(GetTriviaForRandomNumber());
    });

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetTriviaForRandomNumber());
      },
    );
  });
}
