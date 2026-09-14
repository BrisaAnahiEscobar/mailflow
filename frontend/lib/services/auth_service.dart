//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static const _scopesGmail = [
    'https://www.googleapis.com/auth/gmail.readonly',
  ];

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  //final FlutterSecureStorage _storage = const FlutterSecureStorage();

  bool _inicializado = false;

  Future<void> inicializar({required String clientId}) async {
    if (_inicializado) return;
    await _googleSignIn.initialize(clientId: clientId);
    _inicializado = true;
  }

  Stream<GoogleSignInAuthenticationEvent> get authenticationEvents =>
      _googleSignIn.authenticationEvents;

  bool get soportaAuthenticate => _googleSignIn.supportsAuthenticate();

  Future<GoogleSignInAccount?> intentarRestaurarSesion() async {
    try {
      return await _googleSignIn.attemptLightweightAuthentication();
    } catch (e) {
      return null;
    }
  }

  Future<GoogleSignInAccount?> signIn() async {
    try {
      final cuenta = await _googleSignIn.authenticate();
      return cuenta;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return null;
      }
      rethrow;
    }
  }

  Future<String?> autorizarGmail(GoogleSignInAccount cuenta) async {
    final autorizacion = await cuenta.authorizationClient.authorizeScopes(
      _scopesGmail,
    );
    return autorizacion.accessToken;
  }

  /*Future<void> guardarToken(String token) async {
    await _storage.write(key: 'gmail_access_token', value: token);
  }

  Future<String?> obtenerTokenGuardado() async {
    return _storage.read(key: 'gmail_access_token');
  }*/

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    //await _storage.delete(key: 'gmail_access_token');
  }

  //bool get haySesionActiva => _googleSignIn.currentUser != null;
}
