import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/use_cases/usecase.dart';
import '../entities/number_trivia.dart';
import '../repositories/number-trivia-repository.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(
    Params params,
  ) async {
    return await repository.getConcreateNumberTrivia(params.number);
  }
}
