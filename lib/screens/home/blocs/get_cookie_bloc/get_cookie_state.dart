part of 'get_cookie_bloc.dart';

sealed class GetCookieState extends Equatable {
  const GetCookieState();

  @override 
  List<Object> get props => [];


}

final class GetCookieInitial extends GetCookieState {}

final class GetCookieFailure extends GetCookieState {} 
final class GetCookieLoading extends GetCookieState {} 
final class GetCookieSuccess extends GetCookieState { 
  final List<Cookie> cookies;

const GetCookieSuccess(this.cookies);

@override
  List<Object> get props => [cookies];
  }
