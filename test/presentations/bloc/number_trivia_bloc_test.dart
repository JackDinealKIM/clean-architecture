import 'package:clean_architecture/core/util/input_converter.dart';
import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetConcreteNumberTrivia extends Mock implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

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

  test('initialState should be Empty', () {
    // assert
    expect(bloc.initialState, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    // The event takes in a String
    final tNumberString = '1';
    // This is the successful output of the InputConverter
    final tNumberParsed = int.parse(tNumberString);
    // NumberTrivia instance is needed too, of course
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    // test(
    //   'should call the InputConverter to validate and convert the string to an unsigned integer',
    //       () async {
    //     // arrange
    //     when(mockInputConverter.stringToUnsignedInteger("12"))
    //         .thenReturn(Right(tNumberParsed));
    //     // act
    //     bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
    //     await untilCalled(mockInputConverter.stringToUnsignedInteger("12"));
    //     // assert
    //     verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    //   },
    // );
    //
    // test(
    //   'should get data from the concrete use case',
    //       () async {
    //     // arrange
    //     when(mockInputConverter.stringToUnsignedInteger(any))
    //         .thenReturn(Right(tNumberParsed));
    //     when(mockGetConcreteNumberTrivia(any))
    //         .thenAnswer((_) async => Right(tNumberTrivia));
    //     // act
    //     bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
    //     await untilCalled(mockGetConcreteNumberTrivia(any));
    //     // assert
    //     verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
    //   },
    // );
    //
    // test(
    //   'should emit [Loading, Error] when getting data fails',
    //       () async {
    //     // arrange
    //     setUpMockInputConverterSuccess();
    //     when(mockGetConcreteNumberTrivia(any))
    //         .thenAnswer((_) async => Left(ServerFailure()));
    //     // assert later
    //     final expected = [
    //       Empty(),
    //       Loading(),
    //       Error(message: SERVER_FAILURE_MESSAGE),
    //     ];
    //     expectLater(bloc.state, emitsInOrder(expected));
    //     // act
    //     bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
    //   },
    // );
  });
}
