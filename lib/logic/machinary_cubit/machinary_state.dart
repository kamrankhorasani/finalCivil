part of 'machinary_cubit.dart';

abstract class MachinaryState extends Equatable {
  const MachinaryState();

  @override
  List<Object> get props => [];
}

class MachinaryInitial extends MachinaryState {}

class LoadingMachinary extends MachinaryState {}

class LoadedMachinary extends MachinaryState {
  final Map machines;
  final Map storageMachinarys;
  final Map fehrest;

  LoadedMachinary(this.machines, this.storageMachinarys, this.fehrest);
}

class FailedLoadingMachinary extends MachinaryState {}

class AddingMachinary extends MachinaryState {}

class MachinaryAdded extends MachinaryState {
  final bool succes;

  MachinaryAdded(this.succes);
}

class AddingMachinaryFailed extends MachinaryState {}

class DeletingMachinary extends MachinaryState {}

class DeletedMachinary extends MachinaryState {
  final bool succes;

  DeletedMachinary(this.succes);
}

class FailedDeletingMachinary extends MachinaryState {}

class UpdatingMachinary extends MachinaryState {}

class UpdatedMachinary extends MachinaryState {
  final bool succes;

  UpdatedMachinary(this.succes);
}

class FailedUpdatingMachinary extends MachinaryState {}
class SearchingMachine extends MachinaryState {}
class SearchedMachine extends MachinaryState {
  final List searchedItems;

  SearchedMachine(this.searchedItems);
}

class FailedSearchingMachine extends MachinaryState {}