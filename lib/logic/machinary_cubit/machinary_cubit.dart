import 'package:bloc/bloc.dart';
import 'package:civil_project/data/network.dart';
import 'package:civil_project/screens/homee/home_items.dart';
import 'package:equatable/equatable.dart';

part 'machinary_state.dart';

class MachinaryCubit extends Cubit<MachinaryState> {
  MachinaryCubit() : super(MachinaryInitial());
  Future getMachines(
      {String token, int projectid, int activityId, String type}) async {
    emit(LoadingMachinary());
    try {
      final body = await Routing()
          .getStorageItemProperty(token: token, itemType: "TAJHIZAT");
      final body2 = await Routing().getMachine(
        token: token,
        projectId: projectid,
        activityId: activityId,
        dateIn: globalDateController.text,
      );
      emit(LoadedMachinary(body, body2));
    } catch (e) {
      print(e.toString());
      emit(FailedLoadingMachinary());
    }
  }

  Future addMachinary({
    String token,
    int projectId,
    int itemId,
    int activityId,
    String info,
    String amount,
  }) async {
    emit(AddingMachinary());
    try {
      final body = await Routing().storageExtract(
          token: token,
          projectId: projectId,
          activityId: activityId,
          dateIn: globalDateController.text,
          itemId: itemId,
          amount: amount);
      print(body);
      emit(MachinaryAdded(body['success']));
      await getMachines(
          token: token,
          projectid: projectId,
          activityId: activityId,
          type: "TAJHIZAT");
    } catch (e) {
      emit(AddingMachinaryFailed());
    }
  }

  deletingMachinary(
      {String token,
      int projectId,
      int activityId,
      int itemId,
      String type}) async {
    emit(DeletingMachinary());
    try {
      final body =
          await Routing().deleteExtraction(token: token, itemId: itemId);
      print(body);
      emit(DeletedMachinary(body['success']));
      await getMachines(
          token: token,
          projectid: projectId,
          activityId: activityId,
          type: type);
    } catch (e) {
      print(e.toString());
      emit(FailedDeletingMachinary());
    }
  }

  updatingMachinary(
      {String token,
      int projectId,
      int activityId,
      int itemId,
      int stockId,
      String description,
      String amount,
      String type}) async {
    emit(UpdatingMachinary());
    try {
      final body = await Routing().updateExtraction(
          token: token,
          itemId: itemId,
          stockId: stockId,
          description: description,
          amount: amount);
      print(body);
      emit(UpdatedMachinary(body['success']));
      await getMachines(
          token: token,
          projectid: projectId,
          activityId: activityId,
          type: type);
    } catch (e) {
      print(e.toString());
    }
  }
}
