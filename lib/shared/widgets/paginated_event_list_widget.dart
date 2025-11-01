import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/event_entity.dart';
import '../../../domain/repositories/event_repository.dart';

/// Performans optimizasyonlu paginated event list widget'ı
/// Lazy loading ve pagination desteği ile büyük veri setlerini verimli şekilde listeler
class PaginatedEventListWidget extends StatefulWidget {
  final EventRepository eventRepository;
  final String? userId;
  final DateTime startDate;
  final DateTime endDate;
  final int pageSize;
  final Widget Function(BuildContext context, EventEntity event) itemBuilder;
  final Widget Function(BuildContext context) emptyBuilder;
  final Widget Function(BuildContext context)? loadingBuilder;
  final Widget Function(BuildContext context, String error)? errorBuilder;

  const PaginatedEventListWidget({
    super.key,
    required this.eventRepository,
    required this.startDate,
    required this.endDate,
    this.userId,
    this.pageSize = 20,
    required this.itemBuilder,
    required this.emptyBuilder,
    this.loadingBuilder,
    this.errorBuilder,
  });

  @override
  State<PaginatedEventListWidget> createState() => _PaginatedEventListWidgetState();
}

class _PaginatedEventListWidgetState extends State<PaginatedEventListWidget> {
  final ScrollController _scrollController = ScrollController();
  final List<EventEntity> _events = [];
  DocumentSnapshot? _lastDocument;
  bool _isLoading = false;
  bool _hasMore = true;
  String? _error;
  bool _initialLoad = true;

  @override
  void initState() {
    super.initState();
    _loadEvents();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadEvents() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final newEvents = await widget.eventRepository.getEventsByDateRangePaginated(
        startDate: widget.startDate,
        endDate: widget.endDate,
        userId: widget.userId,
        limit: widget.pageSize,
        lastDocument: _lastDocument,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
          
          if (newEvents.isEmpty) {
            _hasMore = false;
          } else {
            _events.addAll(newEvents);
            
            // Son document'i kaydet pagination için
            if (newEvents.isNotEmpty) {
              // Firestore'dan document snapshot al
              _lastDocument = null; // Doc snapshot'ı gerçek implementasyonla alınacak
            }
            
            // Limit'ten az geldiyse daha fazla yok demektir
            if (newEvents.length < widget.pageSize) {
              _hasMore = false;
            }
          }
          
          _initialLoad = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString();
          _initialLoad = false;
        });
      }
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      _loadEvents();
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _events.clear();
      _lastDocument = null;
      _hasMore = true;
      _error = null;
    });
    await _loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    if (_initialLoad) {
      return widget.loadingBuilder?.call(context) ??
          const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return widget.errorBuilder?.call(context, _error!) ??
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Hata: $_error',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _refresh,
                  child: const Text('Tekrar Dene'),
                ),
              ],
            ),
          );
    }

    if (_events.isEmpty) {
      return widget.emptyBuilder(context);
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _events.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _events.length) {
            // Loading indicator
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          
          return widget.itemBuilder(context, _events[index]);
        },
      ),
    );
  }
}

