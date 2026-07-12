import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.syncSettings),
      ),
      body: ListView(
        padding: EdgeInsets.all(padding),
        children: [
          SwitchListTile(
            title: Text(l10n.enableSync),
            subtitle: Text(l10n.enableSyncSubtitle),
            value: _syncEnabled,
            onChanged: (value) {
              setState(() {
                _syncEnabled = value;
              });
            },
          ),
          const Divider(),
          SwitchListTile(
            title: Text(l10n.autoSync),
            subtitle: Text(l10n.autoSyncSubtitle),
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
            title: Text(l10n.wifiOnlySync),
            subtitle: Text(l10n.wifiOnlySyncSubtitle),
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
            title: Text(l10n.manualSync),
            subtitle: Text(l10n.syncNow),
            trailing: const Icon(Icons.sync),
            enabled: _syncEnabled,
            onTap: _syncEnabled
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.syncStarted)),
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
                    l10n.lastSync,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.notSyncedYet,
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
