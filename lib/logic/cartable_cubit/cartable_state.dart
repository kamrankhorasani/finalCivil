part of 'cartable_cubit.dart';

abstract class CartableState extends Equatable {
  const CartableState();

  @override
  List<Object> get props => [];
}

class CartableInitial extends CartableState {}

// class LoadingCartable extends CartableState {}

class LoadedCartable extends CartableState {
  final Map cartables;

  LoadedCartable(this.cartables);
  @override
  List<Object> get props => [cartables];
}

class FailedLoadingCartable extends CartableState {}

class AddingCartable extends CartableState {}

class AddedCartable extends CartableState {
  final bool success;

  AddedCartable(this.success);
}

class FailedAddingCartable extends CartableState {}
