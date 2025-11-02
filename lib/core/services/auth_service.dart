import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Firebase Authentication servisi
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // SharedPreferences keys
  static const String _rememberMeKey = 'remember_me';
  static const String _savedEmailKey = 'saved_email';
  static const String _savedPasswordKey = 'saved_password';

  /// Mevcut kullanıcıyı al
  User? get currentUser => _auth.currentUser;

  /// Kullanıcı oturum açmış mı?
  bool get isAuthenticated => currentUser != null;

  /// Oturum durumu stream'i
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Email ve şifre ile giriş yap
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Remember me özelliği
      if (rememberMe) {
        await _saveCredentials(email.trim(), password);
      } else {
        await _clearSavedCredentials();
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthException(e));
    } catch (e) {
      throw Exception('Giriş yapılırken bir hata oluştu: $e');
    }
  }

  /// Email ve şifre ile kayıt ol
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Email doğrulama gönder
      if (userCredential.user != null && !userCredential.user!.emailVerified) {
        try {
          await userCredential.user!.sendEmailVerification();
        } catch (e) {
          // Email doğrulama gönderilemese bile kayıt başarılı
          print('Email verification gönderilemedi: $e');
        }
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthException(e));
    } catch (e) {
      final errorString = e.toString();
      if (errorString.contains('CONFIGURATION_NOT_FOUND') || 
          errorString.contains('configuration-not-found')) {
        throw Exception('Firebase yapılandırması bulunamadı. Firebase Console\'da Authentication > Sign-in method bölümünden Email/Password\'u etkinleştirin.');
      }
      throw Exception('Kayıt olurken bir hata oluştu: $e');
    }
  }

  /// Şifre sıfırlama e-postası gönder
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthException(e));
    } catch (e) {
      throw Exception('Şifre sıfırlama e-postası gönderilirken bir hata oluştu: $e');
    }
  }

  /// Çıkış yap
  Future<void> signOut() async {
    await _clearSavedCredentials();
    await _auth.signOut();
  }

  /// Email doğrulama e-postası gönder
  Future<void> sendEmailVerification() async {
    final user = currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  /// Email doğrulandı mı?
  bool get isEmailVerified => currentUser?.emailVerified ?? false;

  /// Kaydedilmiş bilgileri al
  Future<Map<String, String?>> getSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool(_rememberMeKey) ?? false;
    
    if (rememberMe) {
      return {
        'email': prefs.getString(_savedEmailKey),
        'password': prefs.getString(_savedPasswordKey),
        'rememberMe': 'true',
      };
    }
    
    return {
      'email': null,
      'password': null,
      'rememberMe': 'false',
    };
  }

  /// Bilgileri kaydet
  Future<void> _saveCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, true);
    await prefs.setString(_savedEmailKey, email);
    await prefs.setString(_savedPasswordKey, password);
  }

  /// Kaydedilmiş bilgileri temizle
  Future<void> _clearSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_rememberMeKey);
    await prefs.remove(_savedEmailKey);
    await prefs.remove(_savedPasswordKey);
  }

  /// Firebase Auth hatalarını Türkçe'ye çevir
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Bu e-posta adresine kayıtlı kullanıcı bulunamadı.';
      case 'wrong-password':
        return 'Şifre hatalı. Lütfen tekrar deneyin.';
      case 'email-already-in-use':
        return 'Bu e-posta adresi zaten kullanılıyor.';
      case 'invalid-email':
        return 'Geçersiz e-posta adresi.';
      case 'weak-password':
        return 'Şifre çok zayıf. En az 6 karakter kullanın.';
      case 'user-disabled':
        return 'Bu kullanıcı hesabı devre dışı bırakılmış.';
      case 'too-many-requests':
        return 'Çok fazla başarısız giriş denemesi. Lütfen daha sonra tekrar deneyin.';
      case 'operation-not-allowed':
        return 'Bu işlem şu anda izin verilmiyor. Firebase Console\'da Email/Password authentication\'ı etkinleştirin.';
      case 'network-request-failed':
        return 'İnternet bağlantınızı kontrol edin.';
      default:
        // CONFIGURATION_NOT_FOUND kontrolü
        if (e.code == 'configuration-not-found' || 
            e.code == 'CONFIGURATION_NOT_FOUND' ||
            (e.message?.contains('CONFIGURATION_NOT_FOUND') ?? false)) {
          return 'Firebase yapılandırması bulunamadı. Lütfen Firebase Console\'da Authentication > Sign-in method bölümünden Email/Password\'u etkinleştirin.';
        }
        return e.message ?? 'Bir hata oluştu: ${e.code}';
    }
  }
}

