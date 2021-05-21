import 'package:bloc/bloc.dart';
import 'package:civil_project/data/network.dart';
import 'package:equatable/equatable.dart';

part 'storeage_get_extract_state.dart';

class StorageGetExtractCubit extends Cubit<StoreageGetExtractState> {
  StorageGetExtractCubit() : super(StoreageGetExtractInitial());

  Future getExtraction({ String token,int projectId}) async {
    emit(StoreageGetExtractLoading());
    try {
      final body = await Routing().getStorageExtraction(
          token: token, projectId: projectId) as Map;
      emit(StoreageGetExtractLoaded(body));
    } catch (e) {
      emit(StoreageGetExtractFailed(e.toString()));
    }
  }
}
