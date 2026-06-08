import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

/// Bildirim tıklamalarından sayfa yönlendirmesi
class NotificationNavigationService {
  NotificationNavigationService._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static String? _pendingSnoozeTaskId;

  static void openSnoozePage(String taskId) {
    _pendingSnoozeTaskId = taskId;
    _tryNavigate();
  }

  static void processPendingNavigation() {
    _tryNavigate();
  }

  static void _tryNavigate() {
    final taskId = _pendingSnoozeTaskId;
    if (taskId == null) return;

    final navigator = navigatorKey.currentState;
    if (navigator == null) return;

    _pendingSnoozeTaskId = null;
    navigator.pushNamed(AppRoutes.taskSnooze, arguments: taskId);
  }
}
