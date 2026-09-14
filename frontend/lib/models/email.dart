class Email {
  final String? id;
  final String remitente;
  final String asunto;
  final String? cuerpo;
  final String? snippet;
  final DateTime? fecha;
  final bool leido;
  final String idioma;

  Email({
    this.id,
    required this.remitente,
    required this.asunto,
    this.cuerpo,
    this.snippet,
    this.fecha,
    this.leido = false,
    this.idioma = 'es-ES',
  });

  String textoParaLeer() {
    if (cuerpo != null && cuerpo!.isNotEmpty) {
      return 'Correo de $remitente. '
          'Asunto: $asunto. '
          'Mensaje $cuerpo';
    }

    return 'Correo de $remitente. '
        'Asunto: $asunto.';
  }
}
