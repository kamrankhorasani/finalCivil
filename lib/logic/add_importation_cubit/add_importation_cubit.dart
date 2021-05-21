import 'package:bloc/bloc.dart';
import 'package:civil_project/data/network.dart';
import 'package:equatable/equatable.dart';

part 'add_importation_state.dart';

class AddImportationCubit extends Cubit<AddImportationState> {
  AddImportationCubit() : super(AddImportationInitial());
  List searchedItems = [];
  Future getItems({String token}) async {
    emit(AddImportationLoadingItemsProperty());
    try {
      final body = await Routing().getProvider(token: token) as Map;
      emit(AddImportationLoadedItemsProperty(body));
      print(body);
    } catch (e) {
      print(e);
      emit(AddImportationLoadItemsPropertyFailed(e.toString()));
    }
  }

  Future searchItems(
      {String token, String type, String txt, int frm, int cnt = 10}) async {
    emit(SearchingItems());
    try {
      final body = await Routing().getStorageImportationByText(
          token: token, type: "ALL", txt: txt, frm: frm, cnt: cnt) as Map;
      searchedItems.addAll(body['data']);
      print(body);
      emit(SearchedItems(searchedItems));
    } catch (e) {
      emit(FailedSearchingItems());
      print(e);
    }
  }

  Future addImportation(
      {String token,
      int projectId,
      int providerId,
      int vahedId,
      int itemId,
      String amount,
      String evacuation,
      List files}) async {
    emit(AddingImportation());
    try {
      final body = await Routing().storageImport(
          token: token,
          projectId: projectId,
          providerId: providerId,
          vahedId: vahedId,
          itemId: itemId,
          amount: amount,
          files: files,
          evacuation: evacuation);
      emit(ImportationAdded(body['success']));
      print(body);
    } catch (e) {
      emit(AddingImportationFailed(e.toString()));
    }
  }
}
