import 'package:bloc/bloc.dart';
import 'package:civil_project/data/network.dart';
import 'package:equatable/equatable.dart';

part 'feed_state.dart';

class FeedCubit extends Cubit<FeedState> {
  FeedCubit() : super(FeedInitial());

  getFeed(
      {String token,
      String tbl,
      String activityList,
      String fromDate,
      String toDate}) async {
    try {
      emit(LoadingFeed());
      final body = await Routing().getReport(
          token: token,
          tbl: tbl,
          activityList: activityList,
          fromDate: fromDate,
          toDate: toDate);
      emit(LoadedFeed(body));
      print(body);
    } catch (e) {
      print(e);
      emit(FailedLoadingFeed());
    }
  }

  getActivityList({String token, int projectId}) async {
    try {
      final body =
          await Routing().getAllWBSActivity(token: token, projectId: projectId);
      emit(LoadedFeedActivity(body));
    } catch (e) {
      print(e);
    }
  }
}
