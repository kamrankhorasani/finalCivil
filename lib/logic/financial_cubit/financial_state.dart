part of 'financial_cubit.dart';

abstract class FinancialState extends Equatable {
  const FinancialState();

  @override
  List<Object> get props => [];
}

class FinancialInitial extends FinancialState {}



class LoadingTransactions extends FinancialState {}

class LoadedTransactions extends FinancialState {
  final Map transactions;

  LoadedTransactions(this.transactions);
  @override

  List<Object> get props => [transactions];
}

class LoadingBalanceFailed extends FinancialState{}
class LoadingTransactionsFailed extends FinancialState{}