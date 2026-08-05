import 'package:bloc/bloc.dart';
import 'package:cookie_repository/cookie_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';

part 'get_cookie_event.dart';
part 'get_cookie_state.dart';

class GetCookieBloc extends Bloc<GetCookieEvent, GetCookieState> {
  final CookieRepo _cookieRepo;

  GetCookieBloc(this._cookieRepo) : super(GetCookieInitial()) {
    on<GetCookie>((event, emit) async {
      emit(GetCookieLoading());
      try {
        final cookies = await _cookieRepo.getCookies();
        emit(GetCookieSuccess(cookies));
      } catch (error, stackTrace) {
        addError(error, stackTrace);
        emit(GetCookieFailure(_messageFor(error)));
      }
    });
  }

  String _messageFor(Object error) {
    if (error is FirebaseException) {
      return switch (error.code) {
        'permission-denied' =>
          'Firestore denied access to cookies. Check your Firestore security rules and signed-in user permissions.',
        'unavailable' =>
          'Firestore is unavailable. Check the phone\'s internet connection and try again.',
        _ => 'Firestore error (${error.code}): ${error.message ?? error}',
      };
    }
    if (error is FormatException) {
      return 'A cookie document has invalid data: ${error.message}';
    }
    return 'Could not load cookies: $error';
  }
}
