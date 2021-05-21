part of 'feed_cubit.dart';

abstract class FeedState extends Equatable {
  const FeedState();

  @override
  List<Object> get props => [];
}

class FeedInitial extends FeedState {}

class LoadedFeedActivity extends FeedState {
  final Map activityList;

  LoadedFeedActivity(this.activityList);
}

class LoadingFeed extends FeedState {}

class LoadedFeed extends FeedState {
  final Map feeds;

  LoadedFeed(this.feeds);

  @override
  List<Object> get props => [feeds];
}

class FailedLoadingFeed extends FeedState {}
