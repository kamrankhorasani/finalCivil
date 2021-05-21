part of 'alladdextraction_cubit.dart';

abstract class AlladdextractionState extends Equatable {
  const AlladdextractionState();

  @override
  List<Object> get props => [];
}

class AlladdextractionInitial extends AlladdextractionState {}
class LoadedAllExtraction extends AlladdextractionState {
  final Map all;
  final Map storageAllExtractions;

  LoadedAllExtraction(this.all, this.storageAllExtractions);
  @override
  List<Object> get props => [all, storageAllExtractions];
}
class LoadingAllExtraction extends AlladdextractionState{}

class FailedLoadingAllAllExtraction extends AlladdextractionState {}

class AddingAllExtraction extends AlladdextractionState {}

class AllExtractionAdded extends AlladdextractionState {
  final bool succes;

  AllExtractionAdded(this.succes);
}

class AddingAllExtractionFailed extends AlladdextractionState {}

class DeletingAllExtraction extends AlladdextractionState {}

class DeletedAllExtraction extends AlladdextractionState {
  final bool succes;

  DeletedAllExtraction(this.succes);
}

class FailedDeletingAllExtraction extends AlladdextractionState {}

class UpdatingAllExtraction extends AlladdextractionState {}

class UpdatedAllExtraction extends AlladdextractionState {
  final bool succes;

  UpdatedAllExtraction(this.succes);
}

class FailedUpdatingAllExtraction extends AlladdextractionState {}
