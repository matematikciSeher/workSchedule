import 'package:flutter/material.dart';

class EventDetailPage extends StatelessWidget {
  final String eventId;

  const EventDetailPage({
    super.key,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Etkinlik Detayı'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Düzenleme sayfasına yönlendir
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                '/task/edit',
                arguments: eventId,
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Etkinlik Başlığı',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Açıklama metni burada yer alacak...',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const Divider(),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 8),
                      Text('01 Ocak 2024'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time),
                      const SizedBox(width: 8),
                      Text('10:00 - 11:30'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

