part of 'accident_cubit.dart';

abstract class AccidentState extends Equatable {
  const AccidentState();

  @override
  List<Object> get props => [];
}

class AccidentInitial extends AccidentState {}

class LoadingAccident extends AccidentState {}

class LoadedAccident extends AccidentState {
  final Map accidents;

  LoadedAccident(this.accidents);
}

class FailedLoadingAccident extends AccidentState {}

class DeletingAccident extends AccidentState {}

class DeletedAccident extends AccidentState {
  final bool succes;

  DeletedAccident(this.succes);
}

class FailedDeletingAccident extends AccidentState {}

class UpdateingAccident extends AccidentState {}

class UpdatedAccident extends AccidentState {
  final bool succes;

  UpdatedAccident(this.succes);
}

class FailedUpdatingAccident extends AccidentState {}

class AddingAccident extends AccidentState {}

class AddedAccident extends AccidentState {
  final bool succes;

  AddedAccident(this.succes);
}

class FailedAddingAccident extends AccidentState {}
