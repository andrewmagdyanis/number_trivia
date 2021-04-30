
import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/error/failure.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/features/number_trivia_feature/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia_feature/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/features/number_trivia_feature/domain/use_cases/get_concerete_number_trivia.dart';

class GetRandomNumberTrivia extends Usecase<NumberTrivia,NoParams>{
  final NumberTriviaRepository numberTriviaRepository;

  GetRandomNumberTrivia(this.numberTriviaRepository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams noParams) async {
  return await numberTriviaRepository.getRandomNumberTrivia();

  }

}