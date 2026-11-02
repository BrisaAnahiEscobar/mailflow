class Preferencias {
  final String idiomaTts;
  final double velocidadTts;
  final double pitchTts;

  const Preferencias({
    required this.idiomaTts,
    required this.velocidadTts,
    required this.pitchTts,
  });

  static const porDefecto = Preferencias(
    idiomaTts: 'es-ES',
    velocidadTts: 0.45,
    pitchTts: 1.0,
  );

  factory Preferencias.fromJson(Map<String, dynamic> json) => Preferencias(
    idiomaTts: json['idiomaTts'] as String,
    velocidadTts: (json['velocidadTts'] as num).toDouble(),
    pitchTts: (json['pitchTts'] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'idiomaTts': idiomaTts,
    'velocidadTts': velocidadTts,
    'pitchTts': pitchTts,
  };

  Preferencias copyWith({
    String? idiomaTts,
    double? velocidadTts,
    double? pitchTts,
  }) => Preferencias(
    idiomaTts: idiomaTts ?? this.idiomaTts,
    velocidadTts: velocidadTts ?? this.velocidadTts,
    pitchTts: pitchTts ?? this.pitchTts,
  );
}
