part of 'inspection_cubit.dart';

abstract class InspectionState extends Equatable {
  const InspectionState();

  @override
  List<Object> get props => [];
}

class InspectionInitial extends InspectionState {}

class SessionInitial extends InspectionState {}

class LoadingInspection extends InspectionState {}

class LoadedInspection extends InspectionState {
  final Map inspections;

  LoadedInspection(this.inspections);
}

class FailedLoadingInspection extends InspectionState {}

class AddingInspection extends InspectionState {}

class AddedInspection extends InspectionState {
  final bool success;

  AddedInspection(this.success);
}

class FailedAddingInspection extends InspectionState {}

class UpdatingInspection extends InspectionState {}

class UpdatedInspection extends InspectionState {
  final bool success;

  UpdatedInspection(this.success);
}

class FailedUpdatingInspection extends InspectionState {}

class DeletingInspection extends InspectionState {}

class DeletedInspection extends InspectionState {
  final bool success;

  DeletedInspection(this.success);
}

class FailedDeletingInspection extends InspectionState {}
