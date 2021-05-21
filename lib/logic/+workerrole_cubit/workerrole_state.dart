part of 'workerrole_cubit.dart';

abstract class WorkerroleState extends Equatable {
  const WorkerroleState();

  @override
  List<Object> get props => [];
}

class WorkerroleInitial extends WorkerroleState {}

class WorkerRoleLoading extends WorkerroleState {}

class WorkerRoleLoaded extends WorkerroleState {
  final List humenResourceList;
  final Map humenWorker;

  WorkerRoleLoaded(this.humenResourceList, this.humenWorker);
}

class WorkerRoleFailedLoading extends WorkerroleState {}

class AddingRole extends WorkerroleState {}

class AddedRole extends WorkerroleState {
  final bool succes;

  AddedRole(this.succes);
}

class AddingFailedRole extends WorkerroleState {}

class DeletingRole extends WorkerroleState {}

class DeletedRole extends WorkerroleState {
  final bool succes;

  DeletedRole(this.succes);
}

class DeletingFailedRole extends WorkerroleState {}

class UpdatingRole extends WorkerroleState {}

class UpdatedRole extends WorkerroleState {
  final bool succes;

  UpdatedRole(this.succes);
}

class UpdatingFailedRole extends WorkerroleState {}
