import 'package:flutter/material.dart';

class SyncSettingsPage extends StatefulWidget {
  const SyncSettingsPage({super.key});

  @override
  State<SyncSettingsPage> createState() => _SyncSettingsPageState();
}

class _SyncSettingsPageState extends State<SyncSettingsPage> {
  bool _syncEnabled = false;
  bool _autoSync = false;
  bool _wifiOnly = true;

  @override
  Widget build(BuildContext context) {
    final padding = 16.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Senkronizasyon Ayarları'),
      ),
      body: ListView(
        padding: EdgeInsets.all(padding),
        children: [
          SwitchListTile(
            title: const Text('Senkronizasyonu Etkinleştir'),
            subtitle: const Text('Bulut senkronizasyonu aç/kapat'),
            value: _syncEnabled,
            onChanged: (value) {
              setState(() {
                _syncEnabled = value;
              });
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Otomatik Senkronizasyon'),
            subtitle:
                const Text('Değişiklikleri otomatik olarak senkronize et'),
            value: _autoSync,
            onChanged: _syncEnabled
                ? (value) {
                    setState(() {
                      _autoSync = value;
                    });
                  }
                : null,
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Sadece Wi-Fi\'da Senkronize Et'),
            subtitle: const Text('Mobil veri kullanımını azalt'),
            value: _wifiOnly,
            onChanged: _syncEnabled
                ? (value) {
                    setState(() {
                      _wifiOnly = value;
                    });
                  }
                : null,
          ),
          const Divider(),
          ListTile(
            title: const Text('Manuel Senkronizasyon'),
            subtitle: const Text('Şimdi senkronize et'),
            trailing: const Icon(Icons.sync),
            enabled: _syncEnabled,
            onTap: _syncEnabled
                ? () {
                    // Manuel senkronizasyon işlemi
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Senkronizasyon başlatıldı')),
                    );
                  }
                : null,
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Son Senkronizasyon',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Henüz senkronize edilmedi',
                    style: Theme.of(context).textTheme.bodyMedium,
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
