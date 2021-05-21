import 'package:bloc/bloc.dart';
import 'package:civil_project/data/network.dart';
import 'package:equatable/equatable.dart';

part 'storeagestock_state.dart';

class StorageGetStockCubit extends Cubit<StoreagestockState> {
  StorageGetStockCubit() : super(StoreagestockInitial());

  Future getStock({String token,int projectId}) async {
    emit(StoreageStockLoading());
    try {

      final body = await Routing().getStorageStock(
          token: token, projectId: projectId) as Map;
      print(body);
      emit(StoreageStockLoaded(body));
    } catch (e) {
      emit(StoreageStockLoadFailed(e.toString()));
    }
  }
}
