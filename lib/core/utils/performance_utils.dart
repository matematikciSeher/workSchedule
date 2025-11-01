import 'dart:async';
import 'package:flutter/material.dart';

/// Performance optimization utilities for calendar app
class PerformanceUtils {
  /// Debounce function - Son çağrıdan belirli süre sonra callback'i çalıştırır
  /// Arama ve filtreleme gibi sık çağrılan işlemler için kullanılır
  static Function debounce(VoidCallback callback, {Duration delay = const Duration(milliseconds: 300)}) {
    Timer? timer;
    
    return () {
      timer?.cancel();
      timer = Timer(delay, callback);
    };
  }

  /// Throttle function - Belirli süre içinde sadece bir kez callback'i çalıştırır
  /// Scroll ve resize gibi sık olaylar için kullanılır
  static Function throttle(VoidCallback callback, {Duration delay = const Duration(milliseconds: 100)}) {
    bool isThrottled = false;
    
    return () {
      if (!isThrottled) {
        callback();
        isThrottled = true;
        Timer(delay, () {
          isThrottled = false;
        });
      }
    };
  }

  /// Memoization helper - Aynı parametrelerle tekrar hesaplamayı önler
  static R Function(T) memoize<R, T>(R Function(T) function) {
    final Map<T, R> cache = {};
    
    return (T input) {
      if (cache.containsKey(input)) {
        return cache[input]!;
      }
      final result = function(input);
      cache[input] = result;
      return result;
    };
  }

  /// Date range cache için utility
  /// Aynı tarih aralığı için tekrar hesaplamayı önler
  static R Function(DateTime, DateTime) memoizeDateRange<R>(
    R Function(DateTime, DateTime) function,
  ) {
    final Map<String, R> cache = {};
    
    return (DateTime start, DateTime end) {
      final key = '${start.millisecondsSinceEpoch}-${end.millisecondsSinceEpoch}';
      if (cache.containsKey(key)) {
        return cache[key]!;
      }
      final result = function(start, end);
      cache[key] = result;
      return result;
    };
  }

  /// Batch processing - Liste işlemlerini parçalara böl
  static Future<List<R>> batchProcess<T, R>({
    required List<T> items,
    required Future<R> Function(T) processor,
    int batchSize = 50,
    void Function(int processed, int total)? onProgress,
  }) async {
    final results = <R>[];
    
    for (int i = 0; i < items.length; i += batchSize) {
      final batch = items.skip(i).take(batchSize).toList();
      
      final batchResults = await Future.wait(
        batch.map((item) => processor(item)),
      );
      
      results.addAll(batchResults);
      
      if (onProgress != null) {
        onProgress(results.length, items.length);
      }
    }
    
    return results;
  }

  /// Cache invalidation helper
  static void clearCaches() {
    // Runtime'da önbellek temizleme için genel yardımcı
    // Spesifik cache'ler için ayrı metodlar eklenebilir
  }
}

/// Lazy loading state management
class LazyLoadingState<T> {
  final List<T> items;
  final bool isLoading;
  final bool hasMore;
  final String? error;
  final Object? lastCursor;

  const LazyLoadingState({
    this.items = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.error,
    this.lastCursor,
  });

  LazyLoadingState<T> copyWith({
    List<T>? items,
    bool? isLoading,
    bool? hasMore,
    String? error,
    Object? lastCursor,
    bool clearError = false,
    bool clearItems = false,
  }) {
    return LazyLoadingState<T>(
      items: clearItems ? [] : (items ?? this.items),
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: clearError ? null : (error ?? this.error),
      lastCursor: lastCursor ?? this.lastCursor,
    );
  }
}

/// Widget rebuild optimization - select kullanımı için
/// Sadece değişen state parçası için rebuild tetikler
class RebuildOptimizer {
  /// Select ile rebuild optimizasyonu
  /// Örnek kullanım:
  /// ```dart
  /// RebuildOptimizer.select<MyState, String>(
  ///   context,
  ///   (state) => state.title,
  ///   builder: (title) => Text(title),
  /// );
  /// ```
  static Widget select<R, T>(
    BuildContext context,
    R Function() selector, {
    required Widget Function(T) builder,
  }) {
    // Bu example implementation - gerçek kullanımda Riverpod/Bloc select kullanın
    final value = selector();
    return builder(value as T);
  }
}

