import 'package:clean_architecture/core/error/failures.dart';
import 'package:clean_architecture/core/use_cases/usecase.dart';
import 'package:clean_architecture/core/util/input_converter.dart';
import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/domain/use-cases/get-concrete-number-trivia.dart';
import 'package:clean_architecture/features/number_trivia/domain/use-cases/get_random_number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('Initial state should be empty ', () async {
    expect(bloc.state, equals(NumberTriviaEmpty()));
  });

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(number: 1, text: 'Test Trivia');

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));

    test(
        'should call InputConverter to validate and convert the string to Unsigned Integer',
        () async {
      //arrange
      setUpMockInputConverterSuccess();
      //act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
      //assert
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should emit [ERROR] when the input is invalid', () async {
      //arrange
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));
      //assert
      final expected = [
        NumberTriviaEmpty(),
        NumberTriviaError(message: Invalid_INPUT_FAILURE_MESSAGE),
      ];
      expectLater(bloc, emitsInOrder(expected));

      //act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test(
      'should get data from the concrete use case',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockGetConcreteNumberTrivia(any));
        // assert
        verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
      },
    );

    test(
      'should emit [LOADING, LOADED] when data fetching is successful',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));

        // assert later
        final expected = [
          NumberTriviaEmpty(),
          NumberTriviaLoading(),
          NumberTriviaLoaded(numberTrivia: tNumberTrivia)
        ];
        expectLater(bloc, emitsInOrder(expected));

        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should emit [LOADING, ERROR] when data fetching is unsuccessful',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expected = [
          NumberTriviaEmpty(),
          NumberTriviaLoading(),
          NumberTriviaError(message: SERVER_FAILURE_MESSAGE)
        ];
        expectLater(bloc, emitsInOrder(expected));

        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should emit [LOADING, ERROR] with the proper message for error',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));

        // assert later
        final expected = [
          NumberTriviaEmpty(),
          NumberTriviaLoading(),
          NumberTriviaError(message: CACHE_FAILURE_MESSAGE)
        ];
        expectLater(bloc, emitsInOrder(expected));

        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(number: 1, text: 'Test Trivia');

    test(
      'should get data from the concrete use case',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        bloc.add(GetTriviaForRandomNumber());
        await untilCalled(mockGetRandomNumberTrivia(any));
        // assert
        verify(mockGetRandomNumberTrivia(NoParams()));
      },
    );

    test(
      'should emit [LOADING, LOADED] when data fetching is successful',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));

        // assert later
        final expected = [
          NumberTriviaEmpty(),
          NumberTriviaLoading(),
          NumberTriviaLoaded(numberTrivia: tNumberTrivia)
        ];
        expectLater(bloc, emitsInOrder(expected));

        // act
        bloc.add(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [LOADING, ERROR] when data fetching is unsuccessful',
      () async {
        // arrange

        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expected = [
          NumberTriviaEmpty(),
          NumberTriviaLoading(),
          NumberTriviaError(message: SERVER_FAILURE_MESSAGE)
        ];
        expectLater(bloc, emitsInOrder(expected));

        // act
        bloc.add(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [LOADING, ERROR] with the proper message for error',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));

        // assert later
        final expected = [
          NumberTriviaEmpty(),
          NumberTriviaLoading(),
          NumberTriviaError(message: CACHE_FAILURE_MESSAGE)
        ];
        expectLater(bloc, emitsInOrder(expected));

        // act
        bloc.add(GetTriviaForRandomNumber());
      },
    );
  });
}
