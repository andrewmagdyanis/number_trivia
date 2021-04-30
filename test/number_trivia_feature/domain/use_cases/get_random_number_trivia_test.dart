import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/features/number_trivia_feature/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia_feature/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/features/number_trivia_feature/domain/use_cases/get_concerete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia_feature/domain/use_cases/get_random_number_trivia.dart';

class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository {}

void main() {
  MockNumberTriviaRepository mockNumberTriviaRepository;
  GetRandomNumberTrivia usecase;
  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });
  final tNumber = 1;
  final tNumberTrivai = NumberTrivia(text: 'dfs', number: 1);

  test('should get trivia from random from the repo', () async {
    when(mockNumberTriviaRepository.getRandomNumberTrivia())
        .thenAnswer((realInvocation) async => Right(tNumberTrivai));
    // run the usecase to be tested
    final result = await usecase(NoParams());
    // write the expected output
    expect(result, Right(tNumberTrivai));
    // verify that the method has been called on the repo
    verify(mockNumberTriviaRepository.getRandomNumberTrivia());
    //verify no other calls
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
