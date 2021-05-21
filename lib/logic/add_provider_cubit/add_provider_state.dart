part of 'add_provider_cubit.dart';

abstract class AddProviderState extends Equatable {
  const AddProviderState();

  @override
  List<Object> get props => [];
}

class AddProviderInitial extends AddProviderState {}

class AddProviderLoadingTypes extends AddProviderState {}

class AddProviderLoadedTypes extends AddProviderState {
  final Map options;

  AddProviderLoadedTypes(this.options);
}

class AddProviderLoadingTypesFailed extends AddProviderState {
  final String error;

  AddProviderLoadingTypesFailed(this.error);
}

class AddingProvider extends AddProviderState {}

class ProviderAdded extends AddProviderState {
  final bool success;

  ProviderAdded(this.success);
}

class AddingProviderFailed extends AddProviderState {
  final String error;

  AddingProviderFailed(this.error);
}
