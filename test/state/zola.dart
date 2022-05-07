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
late StreamController<User?> streamController;

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
    //streamController.sink.add(nullUser);
    pushPreparedUserToUserChangesStream(nullUser);
    await expectLater(1, 1);
    expect(sut.loginState, ApplicationLoginState.loggedOut);
    verify(notifyListenerCall()).called(1);
  });
  test("""
        $given $workingWithApplicationState
        $wheN Creating a new ApplicationState instance
          $and there is a signed in user
          $and User.emailVerified returns true
        $then Firbase.initializeApp() should be called
          $and loginState should return ApplicationLoginState.loggedIn
          $and $notifyListenersCalled
      """, () async {
    verify(initializeCall()).called(1);
    //streamController.sink.add(notNullUser);
    pushPreparedUserToUserChangesStream(notNullUser, true);
    await expectLater(1, 1);
    expect(sut.loginState, ApplicationLoginState.loggedIn);
    verify(notifyListenerCall()).called(1);
  });

  test("""
        $given $workingWithApplicationState
        $wheN Creating a new ApplicationState instance
          $and there is a signed in user
          $and User.emailVerified returns false
        $then Firbase.initializeApp() should be called
          $and loginState should return ApplicationLoginState.locked
          $and $notifyListenersCalled
      """, () async {
    verify(initializeCall()).called(1);
    //streamController.sink.add(notNullUser);
    pushPreparedUserToUserChangesStream(notNullUser, false);
    await expectLater(1, 1);
    expect(sut.loginState, ApplicationLoginState.locked);
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

  test("""
        $given $workingWithApplicationState
          $and there is no signed in user
        $wheN Calling signInWithEmailAndPassword() with invalid email
          $or Calling signInWithEmailAndPassword() with an email that belongs to
                a disabled user
          $or Calling signInWithEmailAndPassword() with an email that belogns to 
                no user
          $or Calling signInWithEmailAndPassword() with an invalid password for 
                the given email or the account of the email doesn't have a 
                password set
        $then errorCallback() should be called, and this imply tha an exception 
                has been thrown
""", () async {
    await fromLoggedOutToEmailAddressToPassword();
    when(firebaseAuth.signInWithEmailAndPassword(
            email: invalidEmail, password: password))
        .thenThrow(invalidEmailException);
    sut.signInWithEmailAndPassword(
        invalidEmail, password, firebaseAuthExceptionCallback);
    verify(firebaseAuthExceptionCallback(invalidEmailException)).called(1);
    when(firebaseAuth.signInWithEmailAndPassword(
            email: validEmail, password: password))
        .thenThrow(userDisabledException);
    sut.signInWithEmailAndPassword(
        validEmail, password, firebaseAuthExceptionCallback);
    verify(firebaseAuthExceptionCallback(userDisabledException)).called(1);
    when(firebaseAuth.signInWithEmailAndPassword(
            email: validEmail, password: password))
        .thenThrow(userNotFoundException);
    sut.signInWithEmailAndPassword(
        validEmail, password, firebaseAuthExceptionCallback);
    verify(firebaseAuthExceptionCallback(userNotFoundException)).called(1);
    when(firebaseAuth.signInWithEmailAndPassword(
            email: validEmail, password: password))
        .thenThrow(wrongPasswordException);
    sut.signInWithEmailAndPassword(
        validEmail, password, firebaseAuthExceptionCallback);
    verify(firebaseAuthExceptionCallback(wrongPasswordException)).called(1);
  });

  test("""
        $given $workingWithApplicationState
          $and there is no signed in user
        $wheN Calling signInWithEmailAndPassword() with a valid email and
                password
          $and User.emailVerified returns false
        $then Calling loginState should return ApplicationLoginState.locked
""", () async {
    await fromLoggedOutToEmailAddressToPassword();
    await fromPasswordToLocked();
  });

  test("""
        $given $workingWithApplicationState
          $and there is no signed in user
        $wheN Calling signInWithEmailAndPassword() with a valid email and
                password
          $and User.emailVerified returns true
        $then Calling loginState returns ApplicationLoginState.loggedIn
""", () async {
    await fromLoggedOutToEmailAddressToPassword();
    await fromPasswordToLoggedIn();
  });

  test("""
      $given $workingWithApplicationState
        $and there is no signed in user
      $wheN Calling sendEmailToVerifyEmailAddress()
      $then User.sendEmailVerification() has been called
      """, () async {
    await fromLoggedOutToEmailAddressToPassword();
    await fromPasswordToLocked();
    when(firebaseAuth.currentUser).thenReturn(notNullUser);
    sut.sendEmailToVerifyEmailAddress();
    verify(notNullUser.sendEmailVerification()).called(1);
  });
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

void pushPreparedUserToUserChangesStream(User? user,
    [bool emailVerified = false]) {
  if (user != null) {
    when(user.emailVerified).thenReturn(emailVerified);
  }
  streamController.sink.add(user);
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

Future<void> fromPasswordToLoggedIn() async {
  when(firebaseAuth.signInWithEmailAndPassword(
          email: validEmail, password: password))
      .thenAnswer((realInvocation) => Future.value(userCredential));
  //when(userCredential.user).thenReturn(notNullUser);
  //when(notNullUser.emailVerified).thenReturn(true);
  //streamController.sink.add(notNullUser);
  pushPreparedUserToUserChangesStream(notNullUser, true);
  await sut.signInWithEmailAndPassword(
      validEmail, password, firebaseAuthExceptionCallback);
  //expectLater(1, 1);
  expect(sut.loginState, ApplicationLoginState.loggedIn);
  verify(notifyListenerCall()).called(1);
  //reset(notifyListenerCall);
}

Future<void> fromPasswordToLocked() async {
  when(firebaseAuth.signInWithEmailAndPassword(
          email: validEmail, password: password))
      .thenAnswer((realInvocation) => Future.value(userCredential));
  // when(userCredential.user).thenReturn(notNullUser);
  //when(notNullUser.emailVerified).thenReturn(false);
  pushPreparedUserToUserChangesStream(notNullUser, false);
  await sut.signInWithEmailAndPassword(
      validEmail, password, firebaseAuthExceptionCallback);
  expect(sut.loginState, ApplicationLoginState.locked);
  verify(notifyListenerCall()).called(1);
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
