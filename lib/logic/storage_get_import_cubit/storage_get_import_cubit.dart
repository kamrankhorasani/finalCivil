import 'package:bloc/bloc.dart';
import 'package:civil_project/data/network.dart';
import 'package:equatable/equatable.dart';

part 'storage_get_import_state.dart';

class StorageGetImportCubit extends Cubit<StorageGetImportState> {
  StorageGetImportCubit() : super(StorageGetImportInitial());

  Future getImportation({String token,projectId}) async {
    emit(LoadingImportation());
    try {
      final body = await Routing()
          .getStorageImportation(token: token,projectId:projectId) as Map;
      emit(LoadedImportation(body));
    } catch (e) {
      print(e.toString());
    }
  }
}
