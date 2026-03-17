part of 'home_bloc.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeTasksLoading extends HomeState {}

class HomeTasksEmpty extends HomeState {}

class HomeTasksError extends HomeState {
  final String message;
  HomeTasksError({required this.message});
}

class HomeLoggedOut extends HomeState {}

class HomeTasksLoaded extends HomeState {
  final List<PostModel> tasks;
  final List<PostModel> filteredTasks;

  HomeTasksLoaded({
    required this.tasks,
    required this.filteredTasks,
  });
}