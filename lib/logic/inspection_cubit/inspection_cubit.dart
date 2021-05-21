import 'package:bloc/bloc.dart';
import 'package:civil_project/data/network.dart';
import 'package:civil_project/screens/homee/home_items.dart';
import 'package:equatable/equatable.dart';

part 'inspection_state.dart';

class InspectionCubit extends Cubit<InspectionState> {
  InspectionCubit() : super(InspectionInitial());

  Future gettingInspection(
      {String token, int projectId, int activityId}) async {
    emit(LoadingInspection());
    try {
      final body = await Routing().getBazdid(
          token: token,
          projectId: projectId,
          activityId: activityId,
          dateIn: globalDateController.text);
      print(body);
      emit(LoadedInspection(body));
    } catch (e) {
      print(e.toString());
      emit(FailedLoadingInspection());
    }
  }

  Future deletingInspection(
      {String token, int projectId, int activityId, int itemId}) async {
    emit(DeletingInspection());

    try {
      final body = await Routing().deleteBazdid(token: token, itemId: itemId);
      print(body);
      emit(DeletedInspection(body['success']));
      await gettingInspection();
    } catch (e) {
      print(e.toString());
      emit(FailedDeletingInspection());
    }
  }

  Future updatingInspection(
      {String token,
      int projectId,
      int activityId,
      int itemId,
      String titleOf,
      String descriptionOf,
      String visitor,
      List file}) async {
    emit(UpdatingInspection());
    try {
      final body = await Routing().updateBazdid(
          token: token,
          itemId: itemId,
          titleOf: titleOf,
          descriptionOf: descriptionOf,
          visitor: visitor,
          file: file);
      print(body);
      emit(UpdatedInspection(body['success']));
      await gettingInspection(
          token: token, projectId: projectId, activityId: activityId);
    } catch (e) {
      print(e.toString());
      emit(FailedUpdatingInspection());
    }
  }

  Future addingInspection(
      {String token,
      int projectId,
      int activityId,
      String titleOf,
      String descriptionOf,
      String visitor,
      List file}) async {
    emit(AddingInspection());

    try {
      final body = await Routing().addBazdid(
          token: token,
          projectId: projectId,
          activityId: activityId,
          dateIn: globalDateController.text,
          titleOf: titleOf,
          descriptionOf: descriptionOf,
          visitor: visitor,
          file: file);
      print(body);
      emit(AddedInspection(body['success']));
      await gettingInspection(
          token: token, projectId: projectId, activityId: activityId);
    } catch (e) {
      print(e.toString());
      emit(FailedAddingInspection());
    }
  }
}
