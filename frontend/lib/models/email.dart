class Email {
  final String? id;
  final String remitente;
  final String asunto;
  final String? cuerpo;
  final DateTime? fecha;
  final bool leido;

  Email({
    this.id, // opcional puede no venir
    required this.remitente, // obligatorio
    required this.asunto, // obligatorio
    this.cuerpo,
    this.fecha,
    this.leido = false,
  });

  String textoParaLeer() {
    if (cuerpo != null && cuerpo!.isNotEmpty) {
      return 'Correo de $remitente.'
          'Asunto: $asunto.'
          'Mensaje $cuerpo';
    }
    return 'Correo de $remitente.'
        'Asunto: $asunto';
  }
}
