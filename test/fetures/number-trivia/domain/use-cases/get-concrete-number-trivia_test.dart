import 'package:clean_architecture/core/use_cases/usecase.dart';
import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/domain/repositories/number-trivia-repository.dart';
import 'package:clean_architecture/features/number_trivia/domain/use-cases/get-concrete-number-trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetConcreteNumberTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  final tNumber = 1;
  final tNumberTrivia = NumberTrivia(
    number: 1,
    text: 'Test trivia',
  );

  test('should get trivia for the number from the repository', () async {
    //arrange

    when(mockNumberTriviaRepository.getConcreateNumberTrivia(any))
        .thenAnswer((_) async => Right(tNumberTrivia));

    //act
    final result = await usecase(Params(number: tNumber));

    //assert
    expect(result, Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getConcreateNumberTrivia(tNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
