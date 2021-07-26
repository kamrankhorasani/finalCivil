part of 'add_extraction_cubit.dart';

abstract class AddExtractionState extends Equatable {
  const AddExtractionState();

  @override
  List<Object> get props => [];
}

class AddExtractionInitial extends AddExtractionState {}

class LoadingMaterials extends AddExtractionState {}

class LoadedMaterials extends AddExtractionState {
  final Map materials;
  final Map storageExtractions;
  final Map fehrest;

  LoadedMaterials(this.materials, this.storageExtractions,this.fehrest);
  @override
  List<Object> get props => [materials, storageExtractions,fehrest];
}

class FailedLoadingMaterials extends AddExtractionState {}

class AddingExtraction extends AddExtractionState {}

class ExtractionAdded extends AddExtractionState {
  final bool succes;

  ExtractionAdded(this.succes);
}

class AddingExtractionFailed extends AddExtractionState {}

class DeletingExtraction extends AddExtractionState {}

class DeletedExtraction extends AddExtractionState {
  final bool succes;

  DeletedExtraction(this.succes);
}

class FailedDeletingExtraction extends AddExtractionState {}

class UpdatingExtraction extends AddExtractionState {}

class UpdatedExtraction extends AddExtractionState {
  final bool succes;

  UpdatedExtraction(this.succes);
}

class FailedUpdatingExtraction extends AddExtractionState {}

