part of 'storage_get_import_cubit.dart';

abstract class StorageGetImportState extends Equatable {
  const StorageGetImportState();

  @override
  List<Object> get props => [];
}

class StorageGetImportInitial extends StorageGetImportState {}

class LoadingImportation extends StorageGetImportState {}

class LoadedImportation extends StorageGetImportState {
  final Map importations;

  LoadedImportation(this.importations);
}

class LoadingImportationFailed extends StorageGetImportState{}
