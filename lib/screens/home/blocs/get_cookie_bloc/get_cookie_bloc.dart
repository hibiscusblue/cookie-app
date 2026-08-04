import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'get_cookie_event.dart';
part 'get_cookie_state.dart';

class GetCookieBloc extends Bloc<GetCookieEvent, GetCookieState> {
  final CookieRepo _cookieRepo;

  GetCookieBloc(this._cookieRepo) : super(GetCookieInitial()) {
    on<GetCookie>((event, emit) async {
      emit(GetCookieLoading());
      try {
        List<Cookie> cookies = await _cookieRepo.getCookies();
        emit(GetCookieSuccess(cookies));
      }
      catch (e) {
        emit(GetCookieFailure());
      }
       
    });
  }
}

class CookieRepo {
  Future<List<Cookie>> getCookies() async {
    throw UnimplementedError();
  }
}
