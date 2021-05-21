import 'package:bloc/bloc.dart';
import 'package:civil_project/data/network.dart';
import 'package:equatable/equatable.dart';

part 'financial_state.dart';

class FinancialCubit extends Cubit<FinancialState> {
  FinancialCubit() : super(FinancialInitial());

  Future getTransactions({String token, String fromDate, String toDate}) async {
    emit(LoadingTransactions());
    try {
      final body = await Routing().getWallet(
        token: token,
        fromDate: fromDate,
        toDate: toDate,
      ) as Map;
      print(body);
      emit(LoadedTransactions(body));
    } catch (e) {
      print(e);
    }
  }
}
