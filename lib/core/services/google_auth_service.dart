import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

/// Google Authentication servisi - Google hesabı ile giriş ve token yönetimi
class GoogleAuthService {
  static final GoogleAuthService _instance = GoogleAuthService._internal();
  factory GoogleAuthService() => _instance;
  GoogleAuthService._internal();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
      'https://www.googleapis.com/auth/calendar',
      'https://www.googleapis.com/auth/calendar.events',
    ],
  );

  /// Google hesabı ile giriş yap
  /// Hem Firebase Auth hem de Google Sign-In için token alır
  Future<GoogleSignInAccount?> signIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // Kullanıcı girişi iptal etti
        return null;
      }

      // Firebase Authentication ile entegrasyon (opsiyonel)
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase'e giriş yap (mevcut Firebase Auth kullanıyorsanız)
      await firebase_auth.FirebaseAuth.instance.signInWithCredential(credential);

      return googleUser;
    } catch (e) {
      throw Exception('Google Sign-In hatası: $e');
    }
  }

  /// Çıkış yap
  Future<void> signOut() async {
    try {
      await _googleSignIn.signInSilently();
      await _googleSignIn.signOut();
      await firebase_auth.FirebaseAuth.instance.signOut();
    } catch (e) {
      throw Exception('Google Sign-Out hatası: $e');
    }
  }

  /// Mevcut kullanıcıyı al
  GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;

  /// Oturum açık mı kontrol et
  Future<bool> isSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }

  /// Sessizce giriş yapmayı dene (kullanıcı daha önce giriş yapmışsa)
  Future<GoogleSignInAccount?> signInSilently() async {
    try {
      return await _googleSignIn.signInSilently();
    } catch (e) {
      return null;
    }
  }

  /// Access token'ı al (Calendar API için gerekli)
  Future<String?> getAccessToken() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signInSilently();
      if (account == null) return null;

      final GoogleSignInAuthentication auth = await account.authentication;
      return auth.accessToken;
    } catch (e) {
      return null;
    }
  }

  /// Kullanıcı bilgilerini al
  Future<GoogleSignInAccount?> getUser() async {
    return _googleSignIn.currentUser ?? await _googleSignIn.signInSilently();
  }
}

