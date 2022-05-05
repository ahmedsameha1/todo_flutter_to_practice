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
    reset(notifyListenerCall);
  });
  test("""
        $given $workingWithApplicationState
        $wheN Creating a new ApplicationState instance
          $and there is no signed in user
        $then Firbase.initializeApp() should be called
          $and loginState should return ApplicationLoginState.loggedOut
          $and $notifyListenersCalled
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
          $and $notifyListenersCalled
      """, () async {
    verify(initializeCall()).called(1);
    streamController.sink.add(notNullUser);
    await expectLater(1, 1);
    expect(sut.loginState, ApplicationLoginState.loggedIn);
    verify(notifyListenerCall()).called(1);
  });

  test("""
        $given $workingWithApplicationState
          $and there is no signed in user
        $wheN calling startLoginFlow()
        $then That loginState returns ApplicationLoginState.emailAddress
          $and $notifyListenersCalled
      """, fromLoggedOutToEmailAddress);

  test("""
        $given $workingWithApplicationState
          $and there is no signed in user
        $wheN Calling verifyEmail() with an invalid email address
        $then the errorCallback() has been called, which imply that a
          FirebaseAuthException has been thrown
""", () {
    when(firebaseAuth.fetchSignInMethodsForEmail(invalidEmail))
        .thenThrow(invalidEmailException);
    fromLoggedOutToEmailAddress();
    sut.verifyEmail(invalidEmail, firebaseAuthExceptionCallback);
    verify(firebaseAuthExceptionCallback(invalidEmailException)).called(1);
  });

  test("""
        $given $workingWithApplicationState
          $and there is no signed in user
        $wheN Calling verifyEmail() with a valid email address
        $then the errorCallback() has NOT been called, which imply that a
          FirebaseAuthException has NOT been thrown
""", () {
    prepareFetchSignInMethodsForEmailWithValidEmailAndReturnAFutureOfListThatContainsPasswordMethod();
    fromLoggedOutToEmailAddress();
    sut.verifyEmail(validEmail, firebaseAuthExceptionCallback);
    verifyNever(firebaseAuthExceptionCallback(invalidEmailException));
  });

  test("""
        $given $workingWithApplicationState
          $and there is no signed in user
        $wheN Calling verifyEmail with a valid email address
          $and verifyEmail returns a Future of List that contains "password"
        $then loginState should return ApplicationLoginState.password
          $and the email returns the same passed argument email
          $and $notifyListenersCalled
""", () async {
    await fromLoggedOutToEmailAddressToPassword();
    expect(sut.email, validEmail);
  });

  test("""
        $given $workingWithApplicationState
          $and there is no signed in user
        $wheN Calling verifyEmail with a valid email address
          $and verifyEmail returns a Future of List that doesn't contain "password"
        $then loginState should return ApplicationLoginState.register
          $and the email returns the same passed argument email
          $and $notifyListenersCalled
""", fromLoggedOutToEmailAddressToRegister);
}

/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////

void fromLoggedOutToEmailAddress() {
  sut.startLoginFlow();
  expect(sut.loginState, ApplicationLoginState.emailAddress);
  verify(notifyListenerCall()).called(1);
  //reset(notifyListenerCall);
}

void
    prepareFetchSignInMethodsForEmailWithValidEmailAndReturnAFutureOfListThatContainsPasswordMethod() {
  when(firebaseAuth.fetchSignInMethodsForEmail(validEmail))
      .thenAnswer((realInvocation) => Future.value(<String>["password"]));
}

void
    prepareFetchSignInMethodsForEmailWithValidEmailAndReturnAFutureOfListThatDoesntContainPasswordMethod() {
  when(firebaseAuth.fetchSignInMethodsForEmail(validEmail))
      .thenAnswer((realInvocation) => Future.value(<String>[]));
}

void prepareUserChangesForTest(User? user) {
  when(firebaseAuth.userChanges())
      .thenAnswer((realInvocation) => Stream.value(user));
}

Future<void> fromLoggedOutToEmailAddressToPassword() async {
  fromLoggedOutToEmailAddress();
  prepareFetchSignInMethodsForEmailWithValidEmailAndReturnAFutureOfListThatContainsPasswordMethod();
  await sut.verifyEmail(validEmail, firebaseAuthExceptionCallback);
  expect(sut.loginState, ApplicationLoginState.password);
  verify(notifyListenerCall()).called(1);
  //reset(notifyListenerCall);
}

Future<void> fromLoggedOutToEmailAddressToRegister() async {
  fromLoggedOutToEmailAddress();
  prepareFetchSignInMethodsForEmailWithValidEmailAndReturnAFutureOfListThatDoesntContainPasswordMethod();
  await sut.verifyEmail(validEmail, firebaseAuthExceptionCallback);
  expect(sut.loginState, ApplicationLoginState.register);
  expect(sut.email, validEmail);
  verify(notifyListenerCall()).called(1);
  //reset(notifyListenerCall);
}

Future<void> fromPasswordToLoggedInIfUserHasBeenVerifiedHisEmail() async {
  when(firebaseAuth.signInWithEmailAndPassword(
          email: validEmail, password: password))
      .thenAnswer((realInvocation) => Future.value(userCredential));
  when(userCredential.user).thenReturn(notNullUser);
  when(notNullUser.emailVerified).thenReturn(true);
  await sut.signInWithEmailAndPassword(
      validEmail, password, firebaseAuthExceptionCallback);
  expect(sut.loginState, ApplicationLoginState.loggedIn);
  verify(notifyListenerCall()).called(1);
  reset(notifyListenerCall);
}

Future<void>
    fromPasswordToLoggedInButEmailHasNotBeenVerifiedExceptionThrown() async {
  when(firebaseAuth.signInWithEmailAndPassword(
          email: validEmail, password: password))
      .thenAnswer((realInvocation) => Future.value(userCredential));
  when(userCredential.user).thenReturn(notNullUser);
  when(notNullUser.emailVerified).thenReturn(false);
  expect(
      () => sut.signInWithEmailAndPassword(
          validEmail, password, firebaseAuthExceptionCallback),
      throwsA(predicate((e) => e is EmailHasNotBeenVerifiedException)));
  expect(sut.loginState, ApplicationLoginState.password);
}

void expectExceptionFromSignOut(Function() function, String message) {
  expect(() => function(),
      throwsA(predicate((e) => e is StateError && e.message == message)));
}

void expectExceptionFromSignInWithEmailAndPassword(
    Function(String validEmail, String password,
            Function(FirebaseAuthException) func)
        function,
    String message) {
  expect(() => function(validEmail, password, firebaseAuthExceptionCallback),
      throwsA(predicate((e) => e is StateError && e.message == message)));
}

void expectExceptionFromRegisterAccount(
    Function(String validEmail, String password, String displayName,
            Function(FirebaseAuthException) func)
        function,
    String message) {
  expect(
      () => function(
          validEmail, password, displayName, firebaseAuthExceptionCallback),
      throwsA(predicate((e) => e is StateError && e.message == message)));
}

void expectExceptionFromCancelRegistration(
    Function() function, String message) {
  expect(() => function(),
      throwsA(predicate((e) => e is StateError && e.message == message)));
}

void expectExceptionFromVerifyEmail(
    Function(String email, Function(FirebaseAuthException) func) function,
    String message) {
  expect(() => function(validEmail, firebaseAuthExceptionCallback),
      throwsA(predicate((e) => e is StateError && e.message == message)));
}
