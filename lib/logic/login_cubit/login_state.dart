part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoadingFile extends LoginState {}

class FileLoaded extends LoginState {
  final int data;

  FileLoaded(this.data);
  @override
  List<Object> get props => [data];
}

class GrantCode extends LoginState {
  final Map verify;
  GrantCode({@required this.verify});
  @override
  List<Object> get props => [verify];
}

class WrongCode extends LoginState {
  final String error;
  WrongCode({this.error});
}
