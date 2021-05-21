import 'package:bloc/bloc.dart';
import 'package:civil_project/data/network.dart';
import 'package:civil_project/screens/homee/home_items.dart';
import 'package:equatable/equatable.dart';

part 'permit_state.dart';

class PermitCubit extends Cubit<PermitState> {
  PermitCubit() : super(PermitInitial());

  Future gettingPermit({String token, int projectId, int activityId}) async {
    emit(LoadingPermit());
    try {
      final body = await Routing().getPermit(
          token: token,
          projectId: projectId,
          activityId: activityId,
          dateIn: globalDateController.text);
      print(body);
      emit(LoadedPermit(body));
    } catch (e) {
      print(e.toString());
      emit(FailedLoadingPermit());
    }
  }

  Future deletingPermit(
      {String token, int projectId, int activityId, int itemId}) async {
    emit(DeletingPermit());

    try {
      final body = await Routing().deletePermit(token: token, itemId: itemId);
      print(body);
      emit(DeletedPermit(body['success']));
      await gettingPermit(
          token: token, projectId: projectId, activityId: activityId);
    } catch (e) {
      print(e.toString());
      emit(FailedDeletingPermit());
    }
  }

  Future updatingPermit(
      {String token,
      int projectId,
      int activityId,
      int itemId,
      String titleOf,
      String descriptionOf,
      int permitFrom}) async {
    emit(UpdatingPermit());
    try {
      final body = await Routing().updatePermit(
          token: token,
          itemId: itemId,
          titleOf: titleOf,
          descriptionOf: descriptionOf,
          permitFrom: permitFrom);
      print(body);
      emit(UpdatedPermit(body['success']));
      await gettingPermit(
          token: token, projectId: projectId, activityId: activityId);
    } catch (e) {
      print(e.toString());
      emit(FailedUpdatingPermit());
    }
  }

  Future addingPermit(
      {String token,
      int projectId,
      int activityId,
      String titleOf,
      String descriptionOf,
      int permitFrom}) async {
    emit(AddingPermit());
    try {
      final body = await Routing().addPermit(
          token: token,
          projectId: projectId,
          activityId: activityId,
          dateIn: globalDateController.text,
          titleOf: titleOf,
          descriptionOf: descriptionOf,
          permitFrom: permitFrom);
      print(body);
      emit(AddedPermit(body['success']));
      await gettingPermit(
          token: token, projectId: projectId, activityId: activityId);
    } catch (e) {
      print(e.toString());
      emit(FailedAddingPermit());
    }
  }
}
