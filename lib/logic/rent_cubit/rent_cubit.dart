import 'package:bloc/bloc.dart';
import 'package:civil_project/data/network.dart';
import 'package:civil_project/screens/homee/home_items.dart';
import 'package:equatable/equatable.dart';

part 'rent_state.dart';

class RentCubit extends Cubit<RentState> {
  RentCubit() : super(RentInitial());
  Future gettingRent({String token, int projectId, int activityId}) async {
    emit(LoadingRent());
    try {
      final body = await Routing().getRent(
          token: token,
          projectId: projectId,
          activityId: activityId,
          dateIn: globalDateController.text);
      print(body);
      emit(LoadedRent(body));
    } catch (e) {
      print(e.toString());
      emit(FailedLoadingRent());
    }
  }

  Future deletingRent(
      {String token, int projectId, int activityId, int itemId}) async {
    emit(DeletingRent());

    try {
      final body = await Routing().deleteRent(token: token, itemId: itemId);
      print(body);
      emit(DeletedRent(body['success']));
      await gettingRent(
          token: token, projectId: projectId, activityId: activityId);
    } catch (e) {
      print(e.toString());
      emit(FailedDeletingRent());
    }
  }

  Future updatingRent(
      {String token,
      int projectId,
      int activityId,
      int itemId,
      String titleOf,
      String descriptionOf,
      String price,
      String dateStart,
      String dateEnd,
      List file}) async {
    emit(UpdatingRent());
    try {
      final body = await Routing().updateRent(
          token: token,
          itemId: itemId,
          titleOf: titleOf,
          price: price,
          descriptionOf: descriptionOf,
          dateEnd: dateEnd,
          dateStart: dateStart,
          file: file);
      print(body);
      emit(UpdatedRent(body['success']));
      await gettingRent(
          token: token, projectId: projectId, activityId: activityId);
    } catch (e) {
      print(e.toString());
      emit(FailedUpdatingRent());
    }
  }

  Future addingRent(
      {String token,
      int projectId,
      int activityId,
      String titleOf,
      String descriptionOf,
      String price,
      String dateStart,
      String dateEnd,
      List file}) async {
    emit(AddingRent());

    try {
      final body = await Routing().addRent(
          token: token,
          projectId: projectId,
          activityId: activityId,
          dateIn: globalDateController.text,
          titleOf: titleOf,
          descriptionOf: descriptionOf,
          price: price,
          dateEnd: dateEnd,
          dateStart: dateStart,
          file: file);
      print(body);
      emit(AddedRent(body['success']));
          await gettingRent(
          token: token, projectId: projectId, activityId: activityId);
    } catch (e) {
      print(e.toString());
      emit(FailedAddingRent());
    }
  }
}
