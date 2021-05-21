import 'package:bloc/bloc.dart';
import 'package:civil_project/data/network.dart';
import 'package:equatable/equatable.dart';

part 'cartable_state.dart';

class CartableCubit extends Cubit<CartableState> {
  CartableCubit() : super(CartableInitial());
  List crt = [];

  getCartable({String token, int frm}) async {
    try {
      final body = await Routing().getKarTable(token: token, frm: frm);
      print(body);
      crt.addAll(body['data']);
      emit(LoadedCartable(body));
    } catch (e) {
      print(e.toString());
      emit(FailedLoadingCartable());
    }
  }

  addCartable(
      {String token,
      String titleOf,
      String msgType = "msg",
      int itemId = 0,
      String description,
      int toUser,
      int toRole = 0,
      List<dynamic> file}) async {
    emit(AddingCartable());
    try {
      final body = await Routing().addKartable(
          token: token,
          titleOf: titleOf,
          itemId: itemId,
          description: description,
          toUser: toUser,
          toRole: toRole,
          msgType: msgType,
          file: file);
      print(body);
      emit(AddedCartable(body['success']));
    } catch (e) {
      print(e.toString());
      emit(FailedAddingCartable());
    }
  }
}
