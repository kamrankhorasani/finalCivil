part of 'add_importation_cubit.dart';

abstract class AddImportationState extends Equatable {
  const AddImportationState();

  @override
  List<Object> get props => [];
}

class AddImportationInitial extends AddImportationState {}

class AddImportationLoadingItemsProperty extends AddImportationState {}

class AddImportationLoadedItemsProperty extends AddImportationState {
  final Map itemsOption;

  AddImportationLoadedItemsProperty(this.itemsOption);
}

class AddImportationLoadItemsPropertyFailed extends AddImportationState {
  final String error;

  AddImportationLoadItemsPropertyFailed(this.error);
}

class AddingImportation extends AddImportationState {}

class ImportationAdded extends AddImportationState {
  final success;

  ImportationAdded(this.success);
}

class AddingImportationFailed extends AddImportationState {
  final String error;

  AddingImportationFailed(this.error);
}

class SearchingItems extends AddImportationState {}

class SearchedItems extends AddImportationState {
  final List searchedItems;

  SearchedItems(this.searchedItems);
}

class FailedSearchingItems extends AddImportationState {}
