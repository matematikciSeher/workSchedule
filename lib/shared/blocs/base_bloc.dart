import 'package:bloc/bloc.dart';

/// Base BLoC class for common functionality
abstract class BaseBloc<Event, State> extends Bloc<Event, State> {
  BaseBloc(super.initialState);
  
  /// Handle async operation with error handling
  Future<void> handleAsyncOperation<T>({
    required Future<T> Function() operation,
    required Function(T data) onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      final data = await operation();
      onSuccess(data);
    } catch (e) {
      onError(e.toString());
    }
  }
}

