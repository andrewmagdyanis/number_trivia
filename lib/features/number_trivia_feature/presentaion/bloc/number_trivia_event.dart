part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  NumberTriviaEvent([List props = const <dynamic>[]]) : super(props);
}

class GetTriviaForConcreteNumber extends NumberTriviaEvent {
  final String number;

  GetTriviaForConcreteNumber(this.number):super([number]);
}

class GetTriviaForRandomNumber extends NumberTriviaEvent {}
