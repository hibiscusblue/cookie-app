import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/src/entities/entities.dart';
import 'package:user_repository/src/models/models.dart';
import 'package:user_repository/src/user_repo.dart';

class FirebaseUserRepo implements UserRepository {
  static const Duration _requestTimeout = Duration(seconds: 20);

  final FirebaseAuth _firebaseAuth;
  final CollectionReference<Map<String, dynamic>> usersCollection;

  FirebaseUserRepo({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        usersCollection =
            (firestore ?? FirebaseFirestore.instance).collection('users');

  @override
  Stream<MyUser?> get user {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) {
        log('No Firebase user is currently signed in.');
        return MyUser.empty;
      }

      log('Authentication state changed. User ID: ${firebaseUser.uid}');

      try {
        final userData = await _getUserDocument(firebaseUser.uid);

        return MyUser.fromEntity(
          MyUserEntity.fromDocument(userData),
        );
      } on TimeoutException catch (error, stackTrace) {
        log(
          'Timed out while loading the user profile from Firestore.',
          error: error,
          stackTrace: stackTrace,
        );

        return MyUser.empty;
      } catch (error, stackTrace) {
        log(
          'Could not load the user profile from Firestore.',
          error: error,
          stackTrace: stackTrace,
        );

        return MyUser.empty;
      }
    });
  }

  Future<Map<String, dynamic>> _getUserDocument(String userId) async {
    // A newly created Firebase account can become authenticated slightly
    // before its Firestore profile document has finished saving.
    // We briefly retry so that this does not break the authentication stream.
    for (var attempt = 1; attempt <= 10; attempt++) {
      final document = await usersCollection.doc(userId).get();
      final data = document.data();

      if (data != null) {
        log('User profile found in Firestore.');
        return data;
      }

      log(
        'User profile not available yet. '
        'Attempt $attempt of 10.',
      );

      await Future<void>.delayed(
        const Duration(milliseconds: 400),
      );
    }

    throw StateError(
      'No Firestore user document was found for user ID $userId.',
    );
  }

  @override
  Future<void> signIn(String email, String password) async {
    final normalizedEmail = email.trim().toLowerCase();

    try {
      log('Starting Firebase sign-in for $normalizedEmail');

      final credential = await _firebaseAuth
          .signInWithEmailAndPassword(
            email: normalizedEmail,
            password: password,
          )
          .timeout(_requestTimeout);

      log(
        'Firebase sign-in successful. '
        'User ID: ${credential.user?.uid}',
      );
    } on FirebaseAuthException catch (error, stackTrace) {
      log(
        'Firebase sign-in failed. '
        'Code: ${error.code}. '
        'Message: ${error.message}',
        error: error,
        stackTrace: stackTrace,
      );

      rethrow;
    } on TimeoutException catch (error, stackTrace) {
      log(
        'Firebase sign-in timed out after '
        '${_requestTimeout.inSeconds} seconds.',
        error: error,
        stackTrace: stackTrace,
      );

      rethrow;
    } catch (error, stackTrace) {
      log(
        'Unexpected sign-in error.',
        error: error,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  @override
  Future<MyUser> signUp(
    MyUser myUser,
    String password,
  ) async {
    final normalizedEmail = myUser.email.trim().toLowerCase();

    try {
      log('Starting Firebase sign-up for $normalizedEmail');

      final userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(
            email: normalizedEmail,
            password: password,
          )
          .timeout(_requestTimeout);

      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw StateError(
          'Firebase created the account but returned no user.',
        );
      }

      myUser.userId = firebaseUser.uid;

      log(
        'Firebase account created successfully. '
        'User ID: ${firebaseUser.uid}',
      );

      return myUser;
    } on FirebaseAuthException catch (error, stackTrace) {
      log(
        'Firebase sign-up failed. '
        'Code: ${error.code}. '
        'Message: ${error.message}',
        error: error,
        stackTrace: stackTrace,
      );

      rethrow;
    } on TimeoutException catch (error, stackTrace) {
      log(
        'Firebase sign-up timed out after '
        '${_requestTimeout.inSeconds} seconds.',
        error: error,
        stackTrace: stackTrace,
      );

      rethrow;
    } catch (error, stackTrace) {
      log(
        'Unexpected sign-up error.',
        error: error,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  @override
  Future<void> setUserData(MyUser user) async {
    try {
      log(
        'Saving the user profile to Firestore. '
        'User ID: ${user.userId}',
      );

      await usersCollection
          .doc(user.userId)
          .set(user.toEntity().toDocument())
          .timeout(_requestTimeout);

      log('User profile saved successfully.');
    } on FirebaseException catch (error, stackTrace) {
      log(
        'Could not save the user profile. '
        'Code: ${error.code}. '
        'Message: ${error.message}',
        error: error,
        stackTrace: stackTrace,
      );

      rethrow;
    } on TimeoutException catch (error, stackTrace) {
      log(
        'Saving the user profile timed out.',
        error: error,
        stackTrace: stackTrace,
      );

      rethrow;
    } catch (error, stackTrace) {
      log(
        'Unexpected error while saving the user profile.',
        error: error,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  @override
  Future<void> logOut() async {
    try {
      await _firebaseAuth.signOut().timeout(_requestTimeout);
      log('User signed out successfully.');
    } catch (error, stackTrace) {
      log(
        'Could not sign out.',
        error: error,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }
}