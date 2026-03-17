import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:note_helper/core/model/post.model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
 
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  DatabaseReference? _ref;

  HomeBloc() : super(HomeInitial()) {
    _user = _auth.currentUser;
    if (_user != null) {
      _ref = FirebaseDatabase.instance.ref().child('Post').child(_user!.uid);
    }

    on<HomeLoadTasksEvent>(_onLoadTasks);
    on<HomeSearchEvent>(_onSearch);
    on<HomeDeleteTaskEvent>(_onDeleteTask);
    on<HomeUpdateTaskEvent>(_onUpdateTask);
    on<HomeLogoutEvent>(_onLogout);
  }

  // ── Load Tasks ───────────────────────────────────────
  Future<void> _onLoadTasks(
      HomeLoadTasksEvent event, Emitter<HomeState> emit) async {
    emit(HomeTasksLoading());
    try {
      await emit.forEach<DatabaseEvent>(
        _ref!.onValue,
        onData: (DatabaseEvent dbEvent) {
          final snapVal = dbEvent.snapshot.value;

          if (snapVal == null) return HomeTasksEmpty();

          final Map<String, dynamic> data =
              Map<String, dynamic>.from(snapVal as Map<Object?, dynamic>);

          final List<PostModel> tasks = data.values
              .map((e) => PostModel.fromMap(Map<String, dynamic>.from(e)))
              .toList();

          return HomeTasksLoaded(tasks: tasks, filteredTasks: tasks);
        },
        onError: (_, __) => HomeTasksError(message: 'Failed to load tasks'),
      );
    } catch (e) {
      emit(HomeTasksError(message: e.toString()));
    }
  }

  // ── Search ───────────────────────────────────────────
  void _onSearch(HomeSearchEvent event, Emitter<HomeState> emit) {
    final current = state;
    if (current is HomeTasksLoaded) {
      if (event.query.trim().isEmpty) {
        emit(HomeTasksLoaded(
          tasks: current.tasks,
          filteredTasks: current.tasks,
        ));
      } else {
        final filtered = current.tasks
            .where((t) => t.taskName
                .toLowerCase()
                .contains(event.query.trim().toLowerCase()))
            .toList();
        emit(HomeTasksLoaded(
          tasks: current.tasks,
          filteredTasks: filtered,
        ));
      }
    }
  }

  // ── Delete ───────────────────────────────────────────
  Future<void> _onDeleteTask(
      HomeDeleteTaskEvent event, Emitter<HomeState> emit) async {
    try {
      await _ref!.child(event.taskId).remove();
    } catch (e) {
      emit(HomeTasksError(message: e.toString()));
    }
  }

  // ── Update ───────────────────────────────────────────
  Future<void> _onUpdateTask(
      HomeUpdateTaskEvent event, Emitter<HomeState> emit) async {
    try {
      await _ref!.child(event.taskId).update({'taskName': event.newTitle});
    } catch (e) {
      emit(HomeTasksError(message: e.toString()));
    }
  }

  // ── Logout ───────────────────────────────────────────
  Future<void> _onLogout(HomeLogoutEvent event, Emitter<HomeState> emit) async {
    try {
      await _auth.signOut();
      emit(HomeLoggedOut());
    } catch (e) {
      emit(HomeTasksError(message: e.toString()));
    }
  }
}
