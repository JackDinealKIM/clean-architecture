
import 'dart:convert';

import 'package:clean_architecture/core/error/exceptions.dart';
import 'package:clean_architecture/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPrefrences extends Mock implements SharedPreferences {}

void main() {
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockSharedPrefrences mockSharedPrefrences;

  setUp(() {
    mockSharedPrefrences = MockSharedPrefrences();
    dataSource = NumberTriviaLocalDataSourceImpl(sharedPreferences: mockSharedPrefrences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));

    test('should return NumberTrivia from SharedPreferences when there is one in the cache', () async {
      // arrange
      when(mockSharedPrefrences.getString('CACHED_NUMBER_TRIVIA')).thenReturn(fixture('trivia_cached.json'));
      // act
      final result = await dataSource.getLastNumberTrivia();
      // assert
      verify(mockSharedPrefrences.getString("CACHED_NUMBER_TRIVIA"));
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a CacheException when there is not a cached value', () async {
      // arrange
      when(mockSharedPrefrences.getString('CACHED_NUMBER_TRIVIA')).thenReturn(null);
      // act
      final result = dataSource.getLastNumberTrivia();
      // assert
      // verify(mockSharedPrefrences.getString("CACHED_NUMBER_TRIVIA"));
      expect(result, throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'test trivia');
    
    test('should call SharedPreferences to cache the data', () async {
      // act
      dataSource.cacheNumberTrivia(tNumberTriviaModel);
      // assert
      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      verify(mockSharedPrefrences.setString('CACHED_NUMBER_TRIVIA', expectedJsonString));
    });
  });

}