part of 'permit_cubit.dart';

abstract class PermitState extends Equatable {
  const PermitState();

  @override
  List<Object> get props => [];
}

class PermitInitial extends PermitState {}

class LoadingPermit extends PermitState {}

class LoadedPermit extends PermitState {
  final Map permits;

  LoadedPermit(this.permits);
}

class FailedLoadingPermit extends PermitState {}

class DeletingPermit extends PermitState {}

class DeletedPermit extends PermitState {
  final bool success;

  DeletedPermit(this.success);
}

class FailedDeletingPermit extends PermitState {}

class UpdatingPermit extends PermitState {}

class UpdatedPermit extends PermitState {
  final bool success;

  UpdatedPermit(this.success);
}

class FailedUpdatingPermit extends PermitState {}

class AddingPermit extends PermitState {}

class AddedPermit extends PermitState {
  final bool success;

  AddedPermit(this.success);
}

class FailedAddingPermit extends PermitState {}
