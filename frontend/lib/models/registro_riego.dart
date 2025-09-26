class RegistroRiego {
  final int id;
  final String sensor; // Es string en serializer
  final String usuario; // Es string en serializer
  final String inicio;
  final int duracionMinutos;
  final bool activo;

  RegistroRiego({
    required this.id,
    required this.sensor,
    required this.usuario,
    required this.inicio,
    required this.duracionMinutos,
    required this.activo,
  });

  factory RegistroRiego.fromJson(Map<String, dynamic> json) {
    return RegistroRiego(
      id: json['id'] as int,
      sensor: json['sensor'] as String,
      usuario: json['usuario'] as String,
      inicio: json['inicio'] as String,
      duracionMinutos: json['duracion_minutos'] as int,
      activo: json['activo'] as bool,
    );
  }
}
