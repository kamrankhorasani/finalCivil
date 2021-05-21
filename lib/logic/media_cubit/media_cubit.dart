import 'package:bloc/bloc.dart';
import 'package:civil_project/data/network.dart';
import 'package:civil_project/screens/homee/home_items.dart';
import 'package:equatable/equatable.dart';

part 'media_state.dart';

class MediaCubit extends Cubit<MediaState> {
  MediaCubit() : super(MediaInitial());

  Future gettingMedia({String token, int activityId, int projectId}) async {
    emit(LoadingMedia());
    try {
      final body = await Routing().getMedia(
          token: token,
          activityId: activityId,
          projectId: projectId,
          dateIn: globalDateController.text) as Map;
      print(body);
      emit(LoadedMedia(medis: body));
    } catch (e) {
      print(e.toString());
      emit(FailedLoadingMedia());
    }
  }



  Future deletingMedia(
      {String token, int projectId, int activityId, int itemId}) async {
    emit(DeletingMedia());
    try {
      final body = await Routing().deleteMedia(itemId: itemId, token: token);
      print(body);
      emit(DeletedMedia(body['success']));
      await gettingMedia(
          token: token, projectId: projectId, activityId: activityId);
    } catch (e) {
      print(e.toString());
      emit(FailedDeletingMedia());
    }
  }

  Future updatingMedia(
      {String token,
      int projectId,
      int activityId,
      int itemId,
      List<dynamic> file}) async {
    emit(UpdatingMedia());
    try {
      final body =
          await Routing().updateMedia(token: token, itemId: itemId, file: file);
      print(body);
      emit(UpdatedMedia(body['success']));
      await gettingMedia(
          token: token, projectId: projectId, activityId: activityId);
    } catch (e) {
      print(e.toString());
      emit(FailedUpdatingMedia());
    }
  }

  Future addingMedia(
      {String token, int projectId, int activityId, List file}) async {
    emit(AddingMedia());
    try {
      final body = await Routing().addMedia(
          token: token,
          activityId: activityId,
          projectId: projectId,
          dateIn: globalDateController.text,
          file: file);
      print(body);
      emit(AddedMedia(body['success']));
      await gettingMedia(
          token: token, projectId: projectId, activityId: activityId);
    } catch (e) {
      print(e.toString());
      emit(FailedAddingMedia());
    }
  }
}
