import 'package:flutter/material.dart';
import '../models/wear_os_models.dart';
import '../services/wear_os_data_service.dart';
import '../widgets/wear_os_daily_summary_card.dart';
import '../widgets/wear_os_event_card.dart';
import '../widgets/wear_os_task_card.dart';

/// Wear OS ana sayfa
/// Günlük özet, yaklaşan etkinlikler ve acil görevleri gösterir
class WearOsHomePage extends StatefulWidget {
  const WearOsHomePage({super.key});

  @override
  State<WearOsHomePage> createState() => _WearOsHomePageState();
}

class _WearOsHomePageState extends State<WearOsHomePage> {
  final WearOsDataService _dataService = WearOsDataService();
  WearOsDailySummary? _dailySummary;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    try {
      final today = DateTime.now();
      final summary = await _dataService.getDailySummary(today);
      
      if (mounted) {
        setState(() {
          _dailySummary = summary;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _refreshData() async {
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : RefreshIndicator(
              onRefresh: _refreshData,
              child: CustomScrollView(
                slivers: [
                  // App Bar
                  SliverAppBar(
                    floating: true,
                    backgroundColor: Colors.black,
                    title: const Text(
                      'Work Schedule',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.settings, color: Colors.white),
                        onPressed: () {
                          // Settings sayfasına git
                        },
                      ),
                    ],
                  ),
                  
                  // Günlük Özet
                  if (_dailySummary != null)
                    SliverPadding(
                      padding: const EdgeInsets.all(8),
                      sliver: SliverToBoxAdapter(
                        child: WearOsDailySummaryCard(
                          summary: _dailySummary!,
                          onTap: () {
                            // Tüm detayları göster
                          },
                        ),
                      ),
                    ),
                  
                  // Yaklaşan Etkinlikler
                  if (_dailySummary != null &&
                      _dailySummary!.nextEvent != null)
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      sliver: SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  color: Colors.blue, size: 16),
                              const SizedBox(width: 8),
                              const Text(
                                'Sonraki Etkinlik',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  
                  if (_dailySummary != null &&
                      _dailySummary!.nextEvent != null)
                    SliverPadding(
                      padding: const EdgeInsets.only(bottom: 8),
                      sliver: SliverToBoxAdapter(
                        child: WearOsEventCard(
                          event: _dailySummary!.nextEvent!,
                          isCompact: true,
                        ),
                      ),
                    ),
                  
                  // Acil Görevler
                  if (_dailySummary != null && _dailySummary!.urgentTasks.isNotEmpty)
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      sliver: SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              const Icon(Icons.priority_high,
                                  color: Colors.red, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                'Acil Görevler (${_dailySummary!.urgentTasks.length})',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  
                  // Acil görev listesi
                  if (_dailySummary != null)
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final task = _dailySummary!.urgentTasks[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: WearOsTaskCard(
                              task: task,
                              isCompact: true,
                            ),
                          );
                        },
                        childCount: _dailySummary!.urgentTasks.length,
                      ),
                    ),
                  
                  // Bugünkü Tüm Görevler
                  if (_dailySummary != null &&
                      _dailySummary!.tasks.isNotEmpty)
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      sliver: SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              const Icon(Icons.task_alt,
                                  color: Colors.green, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                'Bugünkü Görevler',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  
                  if (_dailySummary != null)
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final task = _dailySummary!.tasks[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: WearOsTaskCard(
                              task: task,
                              isCompact: true,
                            ),
                          );
                        },
                        childCount: _dailySummary!.tasks.length,
                      ),
                    ),
                  
                  // Boşluk
                  const SliverPadding(
                    padding: EdgeInsets.only(bottom: 16),
                  ),
                ],
              ),
            ),
    );
  }
}

