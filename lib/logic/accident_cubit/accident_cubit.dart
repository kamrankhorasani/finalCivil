import 'package:bloc/bloc.dart';
import 'package:civil_project/data/network.dart';
import 'package:civil_project/screens/homee/home_items.dart';
import 'package:equatable/equatable.dart';

part 'accident_state.dart';

class AccidentCubit extends Cubit<AccidentState> {
  AccidentCubit() : super(AccidentInitial());

  Future gettingAccidents({String token, int projectId, int activityId}) async {
    emit(LoadingAccident());
    try {
      final body1 = await Routing().getAccident(
          token: token,
          projectId: projectId,
          activityId: activityId,
          dateIn: globalDateController.text) as Map;
      emit(LoadedAccident(body1));
    } catch (e) {
      emit(FailedUpdatingAccident());
      print(e.toString());
    }
  }

  Future deletingAccidents(
      {String token, int itemId, int projectId, int activityId}) async {
    emit(DeletingAccident());
    try {
      final body = await Routing().deleteAccident(token: token, itemId: itemId);
      print(body);
      emit(DeletedAccident(body["success"]));
      await gettingAccidents(
          token: token, projectId: projectId, activityId: activityId);
    } catch (e) {
      emit(FailedDeletingAccident());
      print(e.toString());
    }
  }

  Future addingAccidents(
      {String token,
      int projectId,
      int activityId,
      String enentType,
      String descriptionEvent,
      List<Map> file}) async {
    emit(AddingAccident());
    try {
      final body = await Routing().addAccident(
          token: token,
          projectId: projectId,
          activityId: activityId,
          dateIn: globalDateController.text,
          enentType: enentType,
          descriptionEvent: descriptionEvent,
          file: file);
      print(body);
      emit(AddedAccident(body["success"]));
      await gettingAccidents(
          token: token, projectId: projectId, activityId: activityId);
    } catch (e) {
      emit(FailedAddingAccident());
      print(e.toString());
    }
  }

  Future updatingAccident(
      {String token,
      int projectId,
      int activityId,
      int itemId,
      String enentType,
      String descriptionEvent,
      List<dynamic> file}) async {
    emit(UpdateingAccident());
    try {
      final body = await Routing().updateAccident(
          token: token,
          itemId: itemId,
          enentType: enentType,
          descriptionEvent: descriptionEvent,
          file: file);
      print(body);
      emit(UpdatedAccident(body["success"]));
      await gettingAccidents(
          token: token, projectId: projectId, activityId: activityId);
    } catch (e) {
      emit(FailedUpdatingAccident());
      print(e.toString());
    }
  }
}
