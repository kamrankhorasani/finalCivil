import 'package:bloc/bloc.dart';
import 'package:civil_project/data/network.dart';
import 'package:civil_project/models/fileModel.dart';
import 'package:civil_project/screens/homee/home_items.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'worker_state.dart';

class WorkerCubit extends Cubit<WorkerState> {
  WorkerCubit() : super(WorkerInitial());
  TextEditingController contractTitle = TextEditingController();
  TextEditingController contractPrice = TextEditingController();
  TextEditingController contractCondition = TextEditingController();
  TextEditingController contractPrepay = TextEditingController();
  TextEditingController contractPostpay = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();
  List encodedfiles = [];
  List<FileModel> pickedFiles = [];

  disposer() {
    contractPrice.dispose();
    contractTitle.dispose();
    contractPrepay.dispose();
    contractPostpay.dispose();
    startDate.dispose();
    endDate.dispose();
  }

  Future deleteContract(
      {String token, int itemId, int projectId, int activityId}) async {
    emit(DeletingWorker());
    try {
      final body =
          await Routing().deleteDailyContractor(token: token, itemId: itemId);
      print(body);
      emit(WorkerDeleted(body['success']));
      await getWorkers(
          token: token, projectId: projectId, activityId: activityId);
    } catch (e) {
      emit(FailedDeletingWorker());
    }
  }

  Future getWorkers({String token, int projectId, int activityId}) async {
    emit(LoadingWorkers());
    try {
      final body = await Routing().getDailyContractor(
          token: token,
          projectId: projectId,
          activityId: activityId,
          dateIn: globalDateController.text) as Map;
      final body2 = await Routing().getWorkersSkill(token: token) as Map;

      print(body);
      print(body2);
      emit(LoadedWorkers(body, body2['data']));
    } catch (e) {
      print(e);
    }
  }

  Future addingWorker(
      {String token,
      int projectId,
      int activityId,
      String dateIn,
      String firstName,
      String lastName,
      String title,
      String tell,
      String address,
      int skillId,
      String price,
      String prePay,
      String postPay,
      String payCondition,
      String startDate,
      String endDate,
      List files,
      List workers}) async {
    emit(AddingWorker());
    try {
      final body = await Routing().addDailyContractor(
          token: token,
          projectId: projectId,
          activityId: activityId,
          dateIn: dateIn,
          firstName: firstName,
          lastName: lastName,
          title: title,
          tell: tell,
          address: address,
          skillId: skillId,
          price: price,
          prePay: prePay,
          postPay: postPay,
          payCondition: payCondition,
          startDate: startDate,
          endDate: endDate,
          files: files ?? [],
          workers: workers);
      print(body);
      emit(WorkerAdded(body['success']));
      await getWorkers(
          token: token, projectId: projectId, activityId: activityId);
    } catch (e) {
      emit(FailedAddingWorker());
    }
  }

  Future updatingWorker(
      {String token,
      int projectId,
      int activityId,
      String firstName,
      String lastName,
      String title,
      String tell,
      String address,
      int skillId,
      int itemId,
      String price,
      String prePay,
      String postPay,
      String payCondition,
      String startDate,
      String endDate,
      List files,
      List workers}) async {
    emit(UpdatingWorker());
    try {
      final body = await Routing().updateDailyContractor(
          token: token,
          itemId: itemId,
          firstName: firstName,
          lastName: lastName,
          title: title,
          tell: tell,
          address: address,
          skillId: skillId,
          price: price,
          prePay: prePay,
          postPay: postPay,
          payCondition: payCondition,
          startDate: startDate,
          endDate: endDate,
          files: files ?? [],
          workers: workers);
      print(body);
      emit(UpdatedWorker(body['success']));
      await getWorkers(
          token: token, projectId: projectId, activityId: activityId);
    } catch (e) {
      emit(FailedUpdatingWorker());
    }
  }
}
