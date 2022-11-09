// Mocks generated by Mockito 5.3.2 from annotations
// in todo_flutter_to_practice/test/widget_tests/main_screen_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;

import 'package:firebase_auth/firebase_auth.dart' as _i2;
import 'package:flutter_riverpod/flutter_riverpod.dart' as _i5;
import 'package:mockito/mockito.dart' as _i1;
import 'package:state_notifier/state_notifier.dart' as _i7;
import 'package:todo_flutter_to_practice/domain_model/auth_state.dart' as _i3;
import 'package:todo_flutter_to_practice/state/auth_state_notifier.dart' as _i4;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeFirebaseAuth_0 extends _i1.SmartFake implements _i2.FirebaseAuth {
  _FakeFirebaseAuth_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAuthState_1 extends _i1.SmartFake implements _i3.AuthState {
  _FakeAuthState_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [AuthStateNotifier].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthStateNotifier extends _i1.Mock implements _i4.AuthStateNotifier {
  MockAuthStateNotifier() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.FirebaseAuth get firebaseAuth => (super.noSuchMethod(
        Invocation.getter(#firebaseAuth),
        returnValue: _FakeFirebaseAuth_0(
          this,
          Invocation.getter(#firebaseAuth),
        ),
      ) as _i2.FirebaseAuth);
  @override
  set firebaseAuth(_i2.FirebaseAuth? _firebaseAuth) => super.noSuchMethod(
        Invocation.setter(
          #firebaseAuth,
          _firebaseAuth,
        ),
        returnValueForMissingStub: null,
      );
  @override
  set onError(_i5.ErrorListener? _onError) => super.noSuchMethod(
        Invocation.setter(
          #onError,
          _onError,
        ),
        returnValueForMissingStub: null,
      );
  @override
  bool get mounted => (super.noSuchMethod(
        Invocation.getter(#mounted),
        returnValue: false,
      ) as bool);
  @override
  _i6.Stream<_i3.AuthState> get stream => (super.noSuchMethod(
        Invocation.getter(#stream),
        returnValue: _i6.Stream<_i3.AuthState>.empty(),
      ) as _i6.Stream<_i3.AuthState>);
  @override
  _i3.AuthState get state => (super.noSuchMethod(
        Invocation.getter(#state),
        returnValue: _FakeAuthState_1(
          this,
          Invocation.getter(#state),
        ),
      ) as _i3.AuthState);
  @override
  set state(_i3.AuthState? value) => super.noSuchMethod(
        Invocation.setter(
          #state,
          value,
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i3.AuthState get debugState => (super.noSuchMethod(
        Invocation.getter(#debugState),
        returnValue: _FakeAuthState_1(
          this,
          Invocation.getter(#debugState),
        ),
      ) as _i3.AuthState);
  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);
  @override
  void startLoginFlow() => super.noSuchMethod(
        Invocation.method(
          #startLoginFlow,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i6.Future<void> verifyEmail(
    String? email,
    void Function(_i2.FirebaseAuthException)? errorCallback,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #verifyEmail,
          [
            email,
            errorCallback,
          ],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<void> signInWithEmailAndPassword(
    String? email,
    String? password,
    void Function(_i2.FirebaseAuthException)? errorCallback,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #signInWithEmailAndPassword,
          [
            email,
            password,
            errorCallback,
          ],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  void cancelRegistration() => super.noSuchMethod(
        Invocation.method(
          #cancelRegistration,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i6.Future<void> registerAccount(
    String? email,
    String? password,
    String? displayName,
    void Function(_i2.FirebaseAuthException)? errorCallback,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #registerAccount,
          [
            email,
            password,
            displayName,
            errorCallback,
          ],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<void> signOut() => (super.noSuchMethod(
        Invocation.method(
          #signOut,
          [],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  void sendEmailToVerifyEmailAddress() => super.noSuchMethod(
        Invocation.method(
          #sendEmailToVerifyEmailAddress,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void toLoggedOut() => super.noSuchMethod(
        Invocation.method(
          #toLoggedOut,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void updateUser() => super.noSuchMethod(
        Invocation.method(
          #updateUser,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void resetPassword(
    String? email,
    void Function(_i2.FirebaseAuthException)? errorCallback,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #resetPassword,
          [
            email,
            errorCallback,
          ],
        ),
        returnValueForMissingStub: null,
      );
  @override
  bool updateShouldNotify(
    _i3.AuthState? old,
    _i3.AuthState? current,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateShouldNotify,
          [
            old,
            current,
          ],
        ),
        returnValue: false,
      ) as bool);
  @override
  _i5.RemoveListener addListener(
    _i7.Listener<_i3.AuthState>? listener, {
    bool? fireImmediately = true,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
          {#fireImmediately: fireImmediately},
        ),
        returnValue: () {},
      ) as _i5.RemoveListener);
  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
