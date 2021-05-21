import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'configur_state.dart';

class ConfigurCubit extends Cubit<ConfigurState> {
  ConfigurCubit() : super(ConfigurInitial(""));
  int itemId;
  int providerId;
  List users;
  activityTitleset(String str) => emit(ConfigurInitial(str));
}
