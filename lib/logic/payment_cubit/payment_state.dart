part of 'payment_cubit.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoadingProperty extends PaymentState {}

class PaymentLoadedProperty extends PaymentState {
  final Map properties;

  PaymentLoadedProperty(this.properties);
}

class PaymentLoadingPropertyFailed extends PaymentState{}


class AddingPayment extends PaymentState{}

class PaymentAdded extends PaymentState{
    final bool success;

  PaymentAdded(this.success);
}

class AddingPaymentFailed extends PaymentState{}


