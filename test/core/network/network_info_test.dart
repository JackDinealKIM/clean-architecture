
import 'package:clean_architecture/core/platform/network_info.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  late NetworkInfoImpl networkInfo;
  late MockDataConnectionChecker mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfo = NetworkInfoImpl(mockDataConnectionChecker);
  });
  
  group('isConnected', () async {
    // arrange
    when(mockDataConnectionChecker.hasConnection).thenAnswer((_) async => true);

    // act
    final result = await networkInfo.isConnected;
    // assert
    verify(mockDataConnectionChecker.hasConnection);
    expect(result, true);
  });
}

