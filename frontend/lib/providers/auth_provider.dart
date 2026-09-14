import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _servicio;

  AuthProvider(this._servicio);

  bool _inicializado = false;
  bool _cargando = false;
  String? _mensajeError;

  GoogleSignInAccount? _usuario;
  String? _accessToken;

  StreamSubscription<GoogleSignInAuthenticationEvent>?
  _authenticationSubscription;

  bool get inicializado => _inicializado;

  bool get cargando => _cargando;

  String? get mensajeError => _mensajeError;

  GoogleSignInAccount? get usuario => _usuario;

  String? get accessToken => _accessToken;

  bool get estaAutenticado => _usuario != null;

  bool get tieneAccesoGmail => _accessToken != null;

  Future<void> inicializar({required String clientId}) async {
    if (_inicializado) return;

    try {
      await _servicio.inicializar(clientId: clientId);

      _inicializado = true;

      /*
       * Escuchamos los eventos de autenticación de Google.
       *
       * Esto es especialmente importante en Web porque el botón
       * renderizado por Google no devuelve directamente un usuario
       * desde una función como authenticate().
       */
      _authenticationSubscription = _servicio.authenticationEvents.listen(
        _manejarEventoAutenticacion,
        onError: _manejarErrorAutenticacion,
      );

      /*
       * Intentamos recuperar una sesión existente.
       *
       * Esto NO autoriza Gmail automáticamente.
       * Autenticación y autorización son pasos separados.
       */
      final cuenta = await _servicio.intentarRestaurarSesion();

      if (cuenta != null) {
        _usuario = cuenta;
      }
    } catch (e) {
      debugPrint('AuthProvider error al inicializar: $e');
    }

    notifyListeners();
  }

  Future<void> _manejarEventoAutenticacion(
    GoogleSignInAuthenticationEvent evento,
  ) async {
    if (evento is GoogleSignInAuthenticationEventSignIn) {
      _usuario = evento.user;

      /*
       * El login de Google no significa que Gmail
       * ya esté autorizado.
       *
       * Por eso NO obtenemos el access token acá.
       */
      _accessToken = null;
      _mensajeError = null;

      notifyListeners();
      return;
    }

    if (evento is GoogleSignInAuthenticationEventSignOut) {
      _usuario = null;
      _accessToken = null;

      notifyListeners();
    }
  }

  void _manejarErrorAutenticacion(Object error) {
    debugPrint('AuthProvider error en authenticationEvents: $error');

    _mensajeError = 'Error al iniciar sesión con Google';

    notifyListeners();
  }

  /// Login interactivo para plataformas que soportan authenticate().
  ///
  /// En Web este método no se utiliza porque Google exige
  /// utilizar el botón renderizado mediante renderButton().
  Future<void> iniciarSesion() async {
    if (!_servicio.soportaAuthenticate) {
      return;
    }

    _cargando = true;
    _mensajeError = null;

    notifyListeners();

    try {
      final cuenta = await _servicio.signIn();

      if (cuenta != null) {
        _usuario = cuenta;
      }
    } catch (e) {
      _mensajeError = 'Error al iniciar sesión';

      debugPrint('AuthProvider error en iniciarSesion: $e');
    } finally {
      _cargando = false;

      notifyListeners();
    }
  }

  /// Solicita los permisos necesarios para acceder a Gmail.
  Future<void> autorizarGmail() async {
    if (_usuario == null) {
      debugPrint('autorizarGmail() llamado sin usuario autenticado');
      return;
    }

    _cargando = true;
    _mensajeError = null;

    notifyListeners();

    try {
      final token = await _servicio.autorizarGmail(_usuario!);

      if (token != null) {
        _accessToken = token;
      } else {
        _mensajeError = 'No se otorgó acceso a Gmail';
      }
    } catch (e) {
      _mensajeError = 'Error al autorizar el acceso a Gmail';

      debugPrint('AuthProvider error en autorizarGmail: $e');
    } finally {
      _cargando = false;

      notifyListeners();
    }
  }

  Future<void> cerrarSesion() async {
    try {
      await _servicio.signOut();
    } finally {
      _usuario = null;
      _accessToken = null;
      _mensajeError = null;

      notifyListeners();
    }
  }

  @override
  void dispose() {
    _authenticationSubscription?.cancel();
    super.dispose();
  }
}
