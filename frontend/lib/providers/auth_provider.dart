import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../services/auth_service.dart';
import '../services/backend_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _servicio;
  final BackendService _backend;

  AuthProvider(this._servicio, this._backend);

  /* --------------------------------------------
                  ESTADO INTERNO
  -------------------------------------------- */
  bool _inicializado = false;
  bool _cargando = false;
  bool _sincronizando = false;
  String? _mensajeError;

  GoogleSignInAccount? _usuario;
  String? _accessToken;
  SesionBackend? _sesionBackend;

  StreamSubscription<GoogleSignInAuthenticationEvent>?
  _authenticationSubscription;

  void Function(bool listo)? onBackendListoCambio;

  /* --------------------------------------------
                      GETTERS
  -------------------------------------------- */
  bool get inicializado => _inicializado;

  bool get cargando => _cargando;

  bool get sincronizando => _sincronizando;

  String? get mensajeError => _mensajeError;

  GoogleSignInAccount? get usuario => _usuario;

  String? get accessToken => _accessToken;

  bool get estaAutenticado => _usuario != null;

  bool get tieneAccesoGmail => _accessToken != null;

  bool get backendListo => _sesionBackend != null;

  /* --------------------------------------------
                    INICIALIZACION
  -------------------------------------------- */
  Future<void> inicializar({
    required String clientId,
    String? serverClientId,
  }) async {
    if (_inicializado) return;

    try {
      await _servicio.inicializar(
        clientId: clientId,
        serverClientId: serverClientId,
      );

      _inicializado = true;

      _authenticationSubscription = _servicio.authenticationEvents.listen(
        _manejarEventoAutenticacion,
        onError: _manejarErrorAutenticacion,
      );

      final cuenta = await _servicio.intentarRestaurarSesion();

      if (cuenta != null) {
        _usuario = cuenta;
        unawaited(_sincronizarConBackend(cuenta));
      }
    } catch (e) {
      debugPrint('AuthProvider error al inicializar: $e');
    }

    notifyListeners();
  }

  /* --------------------------------------------
                EVENTOS DE AUTENTICACION
  -------------------------------------------- */
  Future<void> _manejarEventoAutenticacion(
    GoogleSignInAuthenticationEvent evento,
  ) async {
    if (evento is GoogleSignInAuthenticationEventSignIn) {
      _usuario = evento.user;

      _accessToken = null;
      _mensajeError = null;

      notifyListeners();

      await _sincronizarConBackend(evento.user);
      return;
    }

    if (evento is GoogleSignInAuthenticationEventSignOut) {
      _usuario = null;
      _accessToken = null;
      _limpiarBackend();

      notifyListeners();
    }
  }

  void _manejarErrorAutenticacion(Object error) {
    debugPrint('AuthProvider error en authenticationEvents: $error');

    _mensajeError = 'Error al iniciar sesión con Google';

    notifyListeners();
  }

  /* --------------------------------------------
                  LOGIN INTERACTIVO
  -------------------------------------------- */

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
        await _sincronizarConBackend(cuenta);
      }
    } catch (e) {
      _mensajeError = 'Error al iniciar sesión';

      debugPrint('AuthProvider error en iniciarSesion: $e');
    } finally {
      _cargando = false;

      notifyListeners();
    }
  }

  /* --------------------------------------------
                  AUTORIZACION GMAIL
  -------------------------------------------- */
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

  /* --------------------------------------------
                  SINCRONIZACION BACKEND
  -------------------------------------------- */

  /// Canjea el ID token de Google por el JWT propio del backend.
  Future<void> _sincronizarConBackend(GoogleSignInAccount cuenta) async {
    if (_sincronizando || _sesionBackend != null) return;

    _sincronizando = true;
    _mensajeError = null;

    notifyListeners();

    try {
      final idToken = cuenta.authentication.idToken;

      if (idToken == null || idToken.isEmpty) {
        throw StateError('Google no devolvió un idToken');
      }

      _sesionBackend = await _backend.loginConGoogle(idToken);

      onBackendListoCambio?.call(true);
    } catch (e) {
      debugPrint('AuthProvider error al sincronizar con backend: $e');

      _limpiarBackend();
      _mensajeError = 'No se pudo conectar con el servidor de MailFlow';
    } finally {
      _sincronizando = false;

      notifyListeners();
    }
  }

  Future<void> reintentarBackend() async {
    final cuenta = _usuario;

    if (cuenta != null) {
      await _sincronizarConBackend(cuenta);
    }
  }

  void _limpiarBackend() {
    _sesionBackend = null;
    _backend.establecerToken(null);
    onBackendListoCambio?.call(false);
  }

  /* --------------------------------------------
                    CERRAR SESION
  -------------------------------------------- */
  Future<void> cerrarSesion() async {
    try {
      await _servicio.signOut();
    } finally {
      _usuario = null;
      _accessToken = null;
      _mensajeError = null;
      _limpiarBackend();

      notifyListeners();
    }
  }

  /* --------------------------------------------
                      LIMPIEZA
  -------------------------------------------- */
  @override
  void dispose() {
    _authenticationSubscription?.cancel();
    super.dispose();
  }
}
