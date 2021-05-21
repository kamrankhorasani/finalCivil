import 'package:bloc/bloc.dart';
import 'package:civil_project/data/network.dart';
import 'package:equatable/equatable.dart';

part 'homescreen_state.dart';

class HomescreenCubit extends Cubit<HomescreenState> {
  HomescreenCubit() : super(HomescreenInitial());

  Future getProject({String token,}) async {
    emit(HomescreenLoadingProject());
    try {
      final body = await Routing()
          .getProject(token: token) as Map;
      emit(HomescreenLoadedProject(body));
      print(body);
    } catch (e) {
      emit(HomeScreenLoadFailed(e.toString()));
    }
  }
}
