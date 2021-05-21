import 'package:bloc/bloc.dart';
import 'package:civil_project/data/network.dart';
import 'package:civil_project/screens/homee/home_items.dart';
import 'package:equatable/equatable.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(WeatherInitial());

  Future gettingWeather({String token, int projectId, int activityId}) async {
    emit(LoadingWeather());
    try {
      final body = await Routing().getWeather(
          token: token,
          projectId: projectId,
          activityId: activityId,
          dateIn: globalDateController.text);
      print(body);
      emit(LoadedWeather(body));
    } catch (e) {
      print(e.toString());
      emit(FailedLoadingWeather());
    }
  }

  Future deletingWeather(
      {String token, int projectId, int activityId, int itemId}) async {
    emit(DeletingWeather());
    try {
      final body = await Routing().deleteWeather(token: token, itemId: itemId);
      print(body);
      emit(DeletedWeather(body['success']));
      await gettingWeather(
          token: token, projectId: projectId, activityId: activityId);
    } catch (e) {
      print(e.toString());
      emit(FailedDeletingWeather());
    }
  }

  Future updatingWeather(
      {String token,
      int projectId,
      int activityId,
      int itemId,
      String weatherType,
      String degreeOf,
      String timeDay}) async {
    emit(UpdatingWeather());
    try {
      final body = await Routing().updateWeather(
          token: token,
          itemId: itemId,
          weatherType: weatherType,
          degreeOf: degreeOf,
          timeDay: timeDay);
      print(body);
      emit(UpdatedWeather(body['success']));
      await gettingWeather(
          token: token, projectId: projectId, activityId: activityId);
    } catch (e) {
      print(e.toString());
      emit(FailedUpdatingWeather());
    }
  }

  Future addingWeather(
      {String token,
      int projectId,
      int activityId,
      String weatherType,
      String degreeOf,
      String timeDay}) async {
    emit(AddingWeahter());
    try {
      final body = await Routing().addWeather(
          token: token,
          projectId: projectId,
          activityId: activityId,
          dateIn: globalDateController.text,
          weatherType: weatherType,
          degreeOf: degreeOf,
          timeDay: timeDay);
      print(body);
      emit(AddedWeather(body['success']));
      await gettingWeather(
          token: token, projectId: projectId, activityId: activityId);
    } catch (e) {
      print(e.toString());
      emit(FailedAddingWeather());
    }
  }
}
