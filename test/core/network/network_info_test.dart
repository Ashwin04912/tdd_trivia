import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_trivia/core/network/network_info.dart';
import 'network_info_test.mocks.dart';

@GenerateMocks([InternetConnectionChecker])
void main() {
  late NetworkInfoImpl networkInfoImpl;
  late MockInternetConnectionChecker mockInternetConnectionChecker;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(
      internetConnectionChecker: mockInternetConnectionChecker,
    );
  });

  group(
    'isConnected should forward the call to internetconnectionchecker.instance.hasConnection',
    () {
      test('should ', () async {

        final tNetworkConnectionStatus = Future.value(true);
        // arrange
        when(
          mockInternetConnectionChecker.hasConnection,
        ).thenAnswer((_)  => tNetworkConnectionStatus);

        // act
        final result =  networkInfoImpl.isConnected;
        // assert
        verify(mockInternetConnectionChecker.hasConnection);
        expect(result, tNetworkConnectionStatus);
      });
    },
  );
}
