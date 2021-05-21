import 'package:bloc/bloc.dart';
import 'package:civil_project/data/network.dart';
import 'package:equatable/equatable.dart';

part 'itemdeteils2_state.dart';

class Itemdeteils2Cubit extends Cubit<Itemdeteils2State> {
  Itemdeteils2Cubit() : super(Itemdeteils2Initial());

  Future getCartablebyId({String token,int itemId = 20}) async {
    emit(LoadingItem());
    try {
      final body = await Routing().getKartablebyId(
          token: token, itemId: itemId);
      print(body);
      emit(LoadedItem(body));
    } catch (e) {
      print(e.toString());
      emit(FaildLoadingItem());
    }
  }

  Future cartableConfirm(
      {String token,int cartableId, int isConfirm, Map responseJson}) async {
    emit(AddingItem());
    try {
      final body = await Routing().addConfirm(
          token: token,
          cartableId: cartableId,
          isConfirm: isConfirm,
          responseJson: responseJson);
      print(body);
      emit(AddedItem());
    } catch (e) {
      print(e.toString());
      emit(FaildAddingItem());
    }
  }
}
