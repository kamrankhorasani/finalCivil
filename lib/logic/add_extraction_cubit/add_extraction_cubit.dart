

import 'package:bloc/bloc.dart';
import 'package:civil_project/data/network.dart';
import 'package:civil_project/screens/homee/home_items.dart';
import 'package:equatable/equatable.dart';

part 'add_extraction_state.dart';

class AddExtractionCubit extends Cubit<AddExtractionState> {
  AddExtractionCubit() : super(AddExtractionInitial());

  Future getMaterilas(
      {String token, int projectid, int activityId, String type}) async {
    emit(LoadingMaterials());
    try {
      final body = await Routing()
          .getStorageItemProperty(token: token, itemType: "MASALEH");

      final body2 = await Routing().getMaterial(
        token: token,
        projectId: projectid,
        activityId: activityId,
        dateIn: globalDateController.text,
      );

      final body3 = await Routing().getFehrest(token, activityId);

      emit(LoadedMaterials(body, body2,body3));
    } catch (e) {
      print(e.toString());
      emit(FailedLoadingMaterials());
    }
  }

  Future addExtraction(
      {String token,
      int projectId,
      int itemId,
      int activityId,
      String info,
      String amount
     ,String fehrestCode}) async {
    emit(AddingExtraction());
    try {
      final body = await Routing().storageExtract(
          token: token,
          projectId: projectId,
          activityId: activityId,
          dateIn: globalDateController.text,
          itemId: itemId,
          fehrestCode: fehrestCode,
          info: info,
          amount: amount);
      print(body);
      emit(ExtractionAdded(body['success']));
      await getMaterilas(
          token: token,
          projectid: projectId,
          activityId: activityId,
          );
    } catch (e) {
      emit(AddingExtractionFailed());
    }
  }

  deletingExtraction(
      {String token,
      int projectId,
      int activityId,
      int itemId,
      String type}) async {
    emit(DeletingExtraction());
    try {
      final body =
          await Routing().deleteExtraction(token: token, itemId: itemId);
      print(body);
      emit(DeletedExtraction(body['success']));
      await getMaterilas(
          token: token,
          projectid: projectId,
          activityId: activityId,
          type: type);
    } catch (e) {
      print(e.toString());
      emit(FailedDeletingExtraction());
    }
  }

  updatingExtraction(
      {String token,
      int projectId,
      int activityId,
      int itemId,
      int stockId,
      String description,
      String amount,
      String fehrestCode,
      String type}) async {
    emit(UpdatingExtraction());
    try {
      final body = await Routing().updateExtraction(
          token: token,
          itemId: itemId,
          stockId: stockId,
          fehrestCode: fehrestCode,
          description: description,
          amount: amount);
      print(body);
      emit(UpdatedExtraction(body['success']));
      await getMaterilas(
          token: token,
          projectid: projectId,
          activityId: activityId,
          type: type);
    } catch (e) {
      print(e.toString());
    }
  }
}
