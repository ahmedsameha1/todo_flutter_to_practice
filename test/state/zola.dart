import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_flutter_to_practice/state/application_state.dart';

import 'application_state_test.mocks.dart';
import 'test_constants.dart';

abstract class FirebaseInitializeAppFunction {
  Future<FirebaseApp>? call({String? name, FirebaseOptions? options});
}

abstract class ProviderNotifiyListenerFunction {
  void call();
}

abstract class FirebaseAuthExceptionErrorCallbackFunction {
  void call(FirebaseAuthException exception);
}

late FirebaseAuth firebaseAuth;
late User? firebaseUser;
//late Stream<User?> streamOfFirebaseUsers;
late UserCredential userCredential;
const validEmail = "email@email.com";
const invalidEmail = "invalid_email";
const password = "oiehgrwogherow+%5";
const weakPassword = "123";
const displayName = "displayName";
const workingWithApplicationState = "Working with ApplicationState class";
const notifyListenersCalled =
    "ChangeNotifier.notifyListeners() has been called";
const callingStartLoginFlow = "Calling startLoginFlow()";
late ApplicationState sut;
final firebaseAuthExceptionCallback =
    MockFirebaseAuthExceptionErrorCallbackFunction();
final notifyListenerCall = MockProviderNotifiyListenerFunction();
const User? nullUser = null;
final User notNullUser = MockUser();

@GenerateMocks([
  ProviderNotifiyListenerFunction,
  FirebaseAuthExceptionErrorCallbackFunction,
  FirebaseAuth,
  UserCredential,
  User
], customMocks: [
  MockSpec<FirebaseInitializeAppFunction>(returnNullOnMissingStub: true)
])
main() {
  final initializeCall = MockFirebaseInitializeAppFunction();
  final invalidEmailException = FirebaseAuthException(code: "invalid-email");
  final userDisabledException = FirebaseAuthException(code: "user-disabled");
  final userNotFoundException = FirebaseAuthException(code: "user-not-found");
  final wrongPasswordException = FirebaseAuthException(code: "wrong-password");
  final operationNotAllowedException =
      FirebaseAuthException(code: "operation-not-allowed");
  final weakPasswordException = FirebaseAuthException(code: "weak-password");
  final emailAlreadyInUseException =
      FirebaseAuthException(code: "email-already-in-use");
late StreamController<User?> streamController;

  setUp(() {
    firebaseAuth = MockFirebaseAuth();
    sut = ApplicationState(firebaseAuth, initializeCall)
      ..addListener(notifyListenerCall);
    userCredential = MockUserCredential();
    streamController = StreamController();
    when(firebaseAuth.userChanges())
        .thenAnswer((ri) => streamController.stream);
    //prepareUserChangesForTest(notNullUser);
    //reset(notifyListenerCall);
  });
  test("""
        $given $workingWithApplicationState
        $wheN Creating a new ApplicationState instance
          $and there is no signed in user
        $then Firbase.initializeApp() should be called
          $and loginState should return ApplicationLoginState.loggedOut
      """, () async {
    verify(initializeCall()).called(1);
    streamController.sink.add(nullUser);
    await expectLater(1, 1);
    expect(sut.loginState, ApplicationLoginState.loggedOut);
    verify(notifyListenerCall()).called(1);
  });
  test("""
        $given $workingWithApplicationState
        $wheN Creating a new ApplicationState instance
          $and there is a signed in user
        $then Firbase.initializeApp() should be called
          $and loginState should return ApplicationLoginState.loggedIn
      """, () async {
    verify(initializeCall()).called(1);
    streamController.sink.add(notNullUser);
    await expectLater(1, 1);
    expect(sut.loginState, ApplicationLoginState.loggedIn);
    verify(notifyListenerCall()).called(1);
  });
}
