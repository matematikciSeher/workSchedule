import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/services/auth_service.dart';
import '../../pages/auth/login_page.dart';

/// Kullanıcı oturum durumunu kontrol eden widget
class AuthWrapper extends StatelessWidget {
  final Widget child;

  const AuthWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    
    // Debug: Mevcut durumu kontrol et
    final currentUser = FirebaseAuth.instance.currentUser;
    print('AuthWrapper - Current User: ${currentUser?.email ?? "null"}');
    print('AuthWrapper - isAuthenticated: ${authService.isAuthenticated}');

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      initialData: currentUser, // İlk durumu al
      builder: (context, snapshot) {
        // Debug: Stream durumu
        print('AuthWrapper - Stream State: ${snapshot.connectionState}');
        print('AuthWrapper - Has Data: ${snapshot.hasData}');
        print('AuthWrapper - Snapshot User: ${snapshot.data?.email ?? "null"}');
        
        // Yükleniyor - ilk başlatma (sadece gerçekten yükleniyorsa)
        if (snapshot.connectionState == ConnectionState.waiting && 
            !snapshot.hasData && 
            currentUser == null) {
          print('AuthWrapper - Showing loading...');
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Yükleniyor...'),
                ],
              ),
            ),
          );
        }

        // Kullanıcı durumunu kontrol et
        final user = snapshot.data ?? currentUser ?? authService.currentUser;
        
        // Kullanıcı giriş yapmamışsa login sayfasına yönlendir
        if (user == null) {
          print('AuthWrapper - No user, showing login page');
          return const LoginPage();
        }

        // Kullanıcı giriş yapmışsa ana içeriği göster
        print('AuthWrapper - User authenticated, showing home page');
        return child;
      },
    );
  }
}

