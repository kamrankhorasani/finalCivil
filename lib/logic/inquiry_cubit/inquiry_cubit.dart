import 'package:bloc/bloc.dart';
import 'package:civil_project/data/network.dart';
import 'package:civil_project/screens/homee/home_items.dart';
import 'package:equatable/equatable.dart';

part 'inquiry_state.dart';

class InquiryCubit extends Cubit<InquiryState> {
  InquiryCubit() : super(InquiryInitial());
  List providers;
  Future gettingInquiry({String token, int projectId, int activityId}) async {
    emit(LoadingInquiry());
    try {
      final body = await Routing().getEstelam(
          token: token,
          projectId: projectId,
          activityId: activityId,
          dateIn: globalDateController.text);
      final body2 = await Routing().getProvider(token: token);
      providers = body2['data'];
      print(body);
      emit(LoadedInquiry(body));
    } catch (e) {
      print(e.toString());
      emit(FailedLoadingInquiry());
    }
  }

  Future deletingInquiry(
      {String token, int projectId, int activityId, int itemId}) async {
    emit(DeletingInquiry());

    try {
      final body = await Routing().deleteEstelam(token: token, itemId: itemId);
      print(body);
      emit(DeletedInquiry(body['success']));
      await gettingInquiry(token: token,projectId: projectId,activityId:activityId);
    } catch (e) {
      print(e.toString());
      emit(FailedDeletingInquiry());
    }
  }

  Future updatingInquiry(
      {String token,
      int projectId,
      int activityId,
      int itemId,
      int providerId,
      String descriptionOf,
      String estelamDateFor,
      String estelamAmount}) async {
    emit(UpdatingInquiry());
    try {
      final body = await Routing().updateEstelam(
          token: token,
          itemId: itemId,
          providerId: providerId,
          descriptionOf: descriptionOf,
          estelam_amount: estelamAmount,
          estelam_dateFor: estelamDateFor);
      print(body);
      emit(UpdatedInquiry(body['success']));
      await gettingInquiry(
          token: token, projectId: projectId, activityId: activityId);
    } catch (e) {
      print(e.toString());
      emit(FailedUpdatingInquiry());
    }
  }

  Future addingInquiry(
      {String token,
      int projectId,
      int activityId,
      String dateIn,
      int providerId,
      String descriptionOf,
      String estelamDateFor,
      String estelamAmount}) async {
    emit(AddingInquiry());

    try {
      final body = await Routing().addEstelam(
          token: token,
          projectId: projectId,
          activityId: activityId,
          dateIn: globalDateController.text,
          providerId: providerId,
          descriptionOf: descriptionOf,
          estelam_amount: estelamAmount,
          estelam_dateFor: estelamDateFor);
      print(body);
      emit(AddedInquiry(body['success']));
      await gettingInquiry(
          token: token, projectId: projectId, activityId: activityId);
    } catch (e) {
      print(e.toString());
      emit(FailedAddingInquiry());
    }
  }
}
