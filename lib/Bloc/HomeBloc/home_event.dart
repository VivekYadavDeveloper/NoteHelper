part of 'home_bloc.dart';

abstract class HomeEvent {}

class HomeLoadTasksEvent extends HomeEvent {}

class HomeSearchEvent extends HomeEvent {
  final String query;
  HomeSearchEvent({required this.query});
}

class HomeDeleteTaskEvent extends HomeEvent {
  final String taskId;
  HomeDeleteTaskEvent({required this.taskId});
}

class HomeUpdateTaskEvent extends HomeEvent {
  final String taskId;
  final String newTitle;
  HomeUpdateTaskEvent({required this.taskId, required this.newTitle});
}

class HomeLogoutEvent extends HomeEvent {}