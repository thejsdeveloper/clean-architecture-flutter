import 'dart:convert';

import 'package:clean_architecture/core/error/exceptions.dart';
import 'package:clean_architecture/features/number_trivia/data/data-sources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setMockHttpClientFailure500() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 500));
  }

  group('getConcreateNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(jsonDecode(
      fixture('trivia.json'),
    ));
    test('''should perform a GET request on a URL with number being  
        the endpoint and with application/json header''', () async {
      //arrange
      setMockHttpClientSuccess200();
      //act
      dataSource.getConcreateNumberTrivia(tNumber);
      //assert
      verify(mockHttpClient.get(
        'http://numbersapi.com/$tNumber',
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test('''should return NumberTrivia when the response code is 200''',
        () async {
      //arrange
      setMockHttpClientSuccess200();
      //act
      final result = await dataSource.getConcreateNumberTrivia(tNumber);
      //assert
      expect(result, tNumberTriviaModel);
    });

    test('''should return ServerException when the response code is not 200''',
        () async {
      //arrange
      setMockHttpClientFailure500();
      //act
      final call = dataSource.getConcreateNumberTrivia;
      //assert
      expect(() => call(tNumber), throwsA(isA<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(jsonDecode(
      fixture('trivia.json'),
    ));
    test('''should perform a GET request on a URL with number being  
        the endpoint and with application/json header''', () async {
      //arrange
      setMockHttpClientSuccess200();
      //act
      dataSource.getRandomNumberTrivia();
      //assert
      verify(mockHttpClient.get(
        'http://numbersapi.com/random',
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test('''should return NumberTrivia when the response code is 200''',
        () async {
      //arrange
      setMockHttpClientSuccess200();
      //act
      final result = await dataSource.getRandomNumberTrivia();
      //assert
      expect(result, tNumberTriviaModel);
    });

    test('''should return ServerException when the response code is not 200''',
        () async {
      //arrange
      setMockHttpClientFailure500();
      //act
      final call = dataSource.getRandomNumberTrivia;
      //assert
      expect(() => call(), throwsA(isA<ServerException>()));
    });
  });
}
