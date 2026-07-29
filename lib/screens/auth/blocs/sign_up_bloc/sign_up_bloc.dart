import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final UserRepository _userRepository;

  SignUpBloc(this._userRepository) : super(SignUpInitial()) {
    on<SignUpRequired>((event, emit) async {
      emit(SignUpLoading());

      try {
        final user = await _userRepository.signUp(
          event.user,
          event.password,
        );

        log('Firebase account created. Saving user profile...');

        await _userRepository.setUserData(user);

        log('Sign-up completed successfully.');

        emit(SignUpSuccess());
      } catch (error, stackTrace) {
        log(
          'Sign-up failed.',
          error: error,
          stackTrace: stackTrace,
        );

        emit(SignUpFailure());
      }
    });
  }
}