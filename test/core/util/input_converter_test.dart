import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/util/input_converter.dart';

void main() {
  String input = '1';
  int number = 1;

  InputConverter inputConverter;
  setUp(() {
    inputConverter = InputConverter();
  });
  group('input_converter_test', () {
    test(
        'should return the unsigned number '
        'when the given is really int number in string format', () {
      final result = inputConverter.stringToUnsignedInt(input);
      expect(result, Right(number));
    });
    test('should return a failure when the string is not an integer', () {
      final str = 'abc';
      final result = inputConverter.stringToUnsignedInt(str);
      expect(result, Left(InvalidInputFailure()));
    });
    test(
      'should return a failure when the string is a negative integer',
          () async {
        final str = '-123';
        final result = inputConverter.stringToUnsignedInt(str);
        expect(result, Left(InvalidInputFailure()));
      },
    );
  });
}
