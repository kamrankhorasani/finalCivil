part of 'storeage_get_extract_cubit.dart';

abstract class StoreageGetExtractState extends Equatable {
  const StoreageGetExtractState();

  @override
  List<Object> get props => [];
}

class StoreageGetExtractInitial extends StoreageGetExtractState {}

class StoreageGetExtractLoading extends StoreageGetExtractState {}

class StoreageGetExtractLoaded extends StoreageGetExtractState {
  final Map extraction;

  StoreageGetExtractLoaded(this.extraction);
}

class StoreageGetExtractFailed extends StoreageGetExtractState {
  final String error;

  StoreageGetExtractFailed(this.error);
}
