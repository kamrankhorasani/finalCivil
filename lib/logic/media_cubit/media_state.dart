part of 'media_cubit.dart';

abstract class MediaState extends Equatable {
  const MediaState();

  @override
  List<Object> get props => [];
}

class MediaInitial extends MediaState {}

class LoadingMedia extends MediaState {}

class LoadedMedia extends MediaState {
  final Map medis;

  LoadedMedia({this.medis});
  @override
  List<Object> get props => [medis];
}

class FailedLoadingMedia extends MediaState {}

class DeletingMedia extends MediaState {}

class DeletedMedia extends MediaState {
  final bool success;

  DeletedMedia(this.success);
}

class FailedDeletingMedia extends MediaState {}

class AddingMedia extends MediaState {}

class AddedMedia extends MediaState {
  final bool success;

  AddedMedia(this.success);
}

class FailedAddingMedia extends MediaState {}

class UpdatingMedia extends MediaState {}

class UpdatedMedia extends MediaState {
  final bool success;

  UpdatedMedia(this.success);
}

class FailedUpdatingMedia extends MediaState {}
