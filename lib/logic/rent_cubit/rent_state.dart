part of 'rent_cubit.dart';

abstract class RentState extends Equatable {
  const RentState();

  @override
  List<Object> get props => [];
}

class RentInitial extends RentState {}
class LoadingRent extends RentState {}

class LoadedRent extends RentState {
  final Map rents;

  LoadedRent(this.rents);
}

class FailedLoadingRent extends RentState {}

class AddingRent extends RentState {}

class AddedRent extends RentState {
    final bool success;

  AddedRent(this.success);
}

class FailedAddingRent extends RentState {}

class UpdatingRent extends RentState {}

class UpdatedRent extends RentState {
    final bool success;

  UpdatedRent(this.success);
}

class FailedUpdatingRent extends RentState {}

class DeletingRent extends RentState {}

class DeletedRent extends RentState {
    final bool success;

  DeletedRent(this.success);
}

class FailedDeletingRent extends RentState {}
