import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clean_architecture/core/error/failures.dart';
import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/usecases/usucase.dart';
import '../../../../core/util/input_converter.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';

part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE = 'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(Empty()) {
    on<NumberTriviaEvent>((event, emit) async {
      if (event is GetTriviaForConcreteNumber) {
        print('GetTriviaForConcreteNumber: $event');
        final inputEither = inputConverter.stringToUnsignedInteger(event.numberString);

        inputEither.fold(
          (failure) {
            emit(Error(message: INVALID_INPUT_FAILURE_MESSAGE));
          },
          (integer) async {
            emit(Loading());
            final failureOrTrivia = await getConcreteNumberTrivia(Params(number: integer));
            (await _eitherLoadedOrErrorState(failureOrTrivia).single);
          },
        );
      } else if (event is GetTriviaForRandomNumber) {
        print('GetTriviaForRandomNumber: $event');
        emit(Loading());
        final failureOrTrivia = await getRandomNumberTrivia(NoParams());
        emit(await _eitherLoadedOrErrorState(failureOrTrivia).single);
      }
    });
  }

  Stream<NumberTriviaState> _eitherLoadedOrErrorState(Either<Failure, NumberTrivia> either) async* {
    yield either.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (trivia) => Loaded(trivia: trivia),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
