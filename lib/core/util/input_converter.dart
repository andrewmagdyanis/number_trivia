import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/error/failure.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInt(String numberString) {
    try {
      final int result = int.parse(numberString);
      if (result < 0) {
        throw FormatException();
      } else {
        return Right(result);
      }
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
