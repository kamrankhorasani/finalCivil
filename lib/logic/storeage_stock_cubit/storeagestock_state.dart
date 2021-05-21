part of 'storeagestock_cubit.dart';

abstract class StoreagestockState extends Equatable {
  const StoreagestockState();

  @override
  List<Object> get props => [];
}

class StoreagestockInitial extends StoreagestockState {}

class StoreageStockLoading extends StoreagestockState {}

class StoreageStockLoaded extends StoreagestockState {
  final Map stock;

  StoreageStockLoaded(this.stock);
}

class StoreageStockLoadFailed extends StoreagestockState {
  final String e;

  StoreageStockLoadFailed(this.e);
}
