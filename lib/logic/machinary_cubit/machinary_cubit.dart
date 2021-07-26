import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:civil_project/data/network.dart';
import 'package:civil_project/screens/homee/home_items.dart';
import 'package:equatable/equatable.dart';

part 'machinary_state.dart';

class MachinaryCubit extends Cubit<MachinaryState> {
  MachinaryCubit() : super(MachinaryInitial());
  List searchedItems = [];
  Future getMachines(
      {String token, int projectid, int activityId, String type}) async {
    emit(LoadingMachinary());
    try {
      //!body1 is Useless
      final body = await Routing()
          .getStorageItemProperty(token: token, itemType: "TAJHIZAT");
      final body2 = await Routing().getMachine(
        token: token,
        projectId: projectid,
        activityId: activityId,
        dateIn: globalDateController.text,
      );
      final body3 = await Routing().getFehrest(token, activityId);

      emit(LoadedMachinary(body, body2, body3));
    } catch (e) {
      print(e.toString());
      emit(FailedLoadingMachinary());
    }
  }

  searchMachine(
      {String token,
      String type = "TAJHIZAT",
      String title1,
      int frm,
      int cnt}) async {
    emit(SearchingMachine());

    try {
      final body = await Routing().getResource(
          token: token, type: type, title1: title1, frm: frm, cnt: 10) as Map;
      searchedItems.addAll(body['data'] as List ?? []);
      emit(SearchedMachine(searchedItems ?? []));

      print(body);
    } catch (e) {
      print(e);
    }
  }

  loadMoreMachine(
      {String token,
      String type = "TAJHIZAT",
      String title1,
      int frm,
      int cnt}) async {
    try {
      final body = await Routing().getResource(
          token: token, type: type, title1: title1, frm: frm, cnt: 10) as Map;
      searchedItems.addAll(body['data'] as List ?? []);
      emit(SearchedMachine(searchedItems ?? []));

      print(body);
    } catch (e) {
      print(e);
    }
  }

  Future addMachinary(
      {String token,
      int projectId,
      String itemCode,
      int activityId,
      String info,
      String amount,
      String fehrestCode,
      String priceRent,
      String fromSource}) async {
    print("before emit");
    emit(AddingMachinary());
    print("after emit");
    try {
      print("try");
      final body = await Routing().addTajhizat(
          token,
          projectId,
          activityId,
          itemCode,
          globalDateController.text,
          amount,
          info,
          fehrestCode,
          priceRent,
          fromSource);
      print(body);
      emit(MachinaryAdded(body['success']));
      await getMachines(
          token: token,
          projectid: projectId,
          activityId: activityId,
          type: "TAJHIZAT");
    } catch (e) {
      print("e");
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

  deletRent({String token, int itemId, int activityId, int projectId}) async {
    emit(DeletingMachinary());
    try {
      final body = await Routing().deleteRent(token: token, itemId: itemId);
      emit(DeletedMachinary(body["success"]));
    } catch (e) {
      print(e);
    }
    await getMachines(
      token:token,
      activityId: activityId,
      projectid: projectId,
    );
  }

  updatRent(
      {String token,
      int itemId,
      String info,
      String amount,
      String resourceCode,
      String priceRent,
      String fehrestCode}) async {
    emit(UpdatingMachinary());
    try {
      final body = await Routing().updateRent(
          token: token,
          itemId: itemId,
          info: info,
          amount: amount,
          resourceCode: resourceCode,
          priceRent: priceRent,
          fehrestCode: fehrestCode);
      print(body);
      emit(UpdatedMachinary(body['success']));
    } catch (e) {
      emit(FailedUpdatingMachinary());
      print(e);
    }
  }
}
