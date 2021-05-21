import 'package:bloc/bloc.dart';
import 'package:civil_project/data/network.dart';
import 'package:equatable/equatable.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial());

  Future getCostProperties({String token,int projectId }) async {
    emit(PaymentLoadingProperty());
    try {
      final body = await Routing().getPropertyCost(
          token: token,
          projectId: projectId) as Map;
      emit(PaymentLoadedProperty(body));
    } catch (e) {
      print(e);
    }
  }

  Future addPayment(
      {String token,int projectId ,
      int activityId ,
      int receiverId,
      String amount,
      String description,
      String type}) async {
    emit(AddingPayment());
    try {
      final body = await Routing().addPay(
          token: token,
          projectId: projectId,
          activityId: activityId,
          receiverId: receiverId,
          amount: amount,
          description: description,
          type: type);
      print(body);
      emit(PaymentAdded(body['success']));
    } catch (e) {
      print(e.toString());
      emit(AddingPaymentFailed());
    }
  }
}
