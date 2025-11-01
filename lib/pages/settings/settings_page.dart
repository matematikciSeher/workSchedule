import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../shared/widgets/decorative_background.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: false,
      body: DecorativeBackground(
        style: BackgroundStyle.elegant,
        child: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.sync),
            title: const Text('Senkronizasyon Ayarları'),
            subtitle: const Text('Bulut senkronizasyon ve yedekleme'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.syncSettings);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.preview),
            title: const Text('Widget Önizleme'),
            subtitle: const Text('Ana ekran widget\'ını önizle'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.widgetPreview);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Bildirimler'),
            onTap: () {
              // Bildirim ayarları
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text('Tema ve Yazı Tipi'),
            subtitle: const Text('Tema renkleri ve yazı tipi boyutu'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.themeSettings);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Hakkında'),
            onTap: () {
              // Hakkında sayfası
            },
          ),
        ],
        ),
      ),
    );
  }
}

