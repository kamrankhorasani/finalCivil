part of 'itemdeteils2_cubit.dart';

abstract class Itemdeteils2State extends Equatable {
  const Itemdeteils2State();

  @override
  List<Object> get props => [];
}

class Itemdeteils2Initial extends Itemdeteils2State {}

class LoadingItem extends Itemdeteils2State {}

class LoadedItem extends Itemdeteils2State {
  final Map details;

  LoadedItem(this.details);
  @override
  List<Object> get props => [details];
}

class FaildLoadingItem extends Itemdeteils2State {}

class AddingItem extends Itemdeteils2State {}

class AddedItem extends Itemdeteils2State {}

class FaildAddingItem extends Itemdeteils2State {}
