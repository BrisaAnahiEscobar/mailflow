import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/preferencias.dart';

void main() {
  test('Preferencias serializa y deserializa sin pérdida', () {
    const original = Preferencias(
      idiomaTts: 'en-US',
      velocidadTts: 0.8,
      pitchTts: 1.2,
    );

    final copia = Preferencias.fromJson(original.toJson());

    expect(copia.idiomaTts, 'en-US');
    expect(copia.velocidadTts, 0.8);
    expect(copia.pitchTts, 1.2);
  });

  test('Preferencias.porDefecto coincide con los valores del backend', () {
    expect(Preferencias.porDefecto.idiomaTts, 'es-ES');
    expect(Preferencias.porDefecto.velocidadTts, 0.45);
    expect(Preferencias.porDefecto.pitchTts, 1.0);
  });
}
