import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_finger/data/repositories/notification_repository.dart';

import 'noticication_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository repository;

  NotificationCubit({required this.repository}) : super(NotificationInitial());
  Future<void> loadNotifications() async {
    emit(NotificationLoading());
    try {
      final response = await repository.fetchNotifications();

      emit(
        NotificationLoaded(
          notifications: response.notifications,
          count: response.count,
        ),
      );
    } catch (e) {
      emit(NotificationError(message: e.toString()));
    }
  }
}
