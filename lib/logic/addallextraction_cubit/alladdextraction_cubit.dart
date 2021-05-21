import 'package:bloc/bloc.dart';
import 'package:civil_project/data/network.dart';
import 'package:civil_project/screens/homee/home_items.dart';
import 'package:equatable/equatable.dart';

part 'alladdextraction_state.dart';

class AlladdextractionCubit extends Cubit<AlladdextractionState> {
  AlladdextractionCubit() : super(AlladdextractionInitial());
  Future getMaterilas(
      {String token, int projectid, int activityId, String type}) async {
    emit(LoadingAllExtraction());
    try {
      final body =
          await Routing().getStorageItemProperty(token: token, itemType: "ALL");
      final body2 = await Routing().getStorageExtraction(
        token: token,
        projectId: projectid,
      );
      emit(LoadedAllExtraction(body, body2));
    } catch (e) {
      print(e.toString());
      emit(FailedLoadingAllAllExtraction());
    }
  }

  Future addExtraction(
      {String token,
      int projectId,
      int itemId,
      int activityId,
      String info,
      String amount,
      String type}) async {
    emit(AddingAllExtraction());
    try {
      final body = await Routing().storageExtract(
          token: token,
          projectId: projectId,
          activityId: activityId,
          dateIn: globalDateController.text,
          itemId: itemId,
          amount: amount);
      print(body);
      emit(AllExtractionAdded(body['success']));
      await getMaterilas(
          token: token,
          projectid: projectId,
          activityId: activityId,
          type: type);
    } catch (e) {
      emit(AddingAllExtractionFailed());
    }
  }

  deletingExtraction(
      {String token,
      int projectId,
      int activityId,
      int itemId,
      String type}) async {
    emit(DeletingAllExtraction());
    try {
      final body =
          await Routing().deleteExtraction(token: token, itemId: itemId);
      print(body);
      emit(DeletedAllExtraction(body['success']));
      await getMaterilas(token: token,projectid: projectId,activityId:activityId,type: type);
    } catch (e) {
      print(e.toString());
      emit(FailedDeletingAllExtraction());
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
      String type}) async {
    emit(UpdatingAllExtraction());
    try {
      final body = await Routing().updateExtraction(
          token: token,
          itemId: itemId,
          stockId: stockId,
          description: description,
          amount: amount);
      emit(UpdatedAllExtraction(body['success']));
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
