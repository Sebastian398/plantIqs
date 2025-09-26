class Sensor {
  final int id;
  final String tipo;
  final double valor;
  final String fechaRegistro;
  final bool activo;

  Sensor({
    required this.id,
    required this.tipo,
    required this.valor,
    required this.fechaRegistro,
    required this.activo,
  });

  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(
      id: json['id'] as int,
      tipo: json['tipo'] as String,
      valor: (json['valor'] as num).toDouble(),
      fechaRegistro: json['fecha_registro'] as String,
      activo: json['activo'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipo': tipo,
      'valor': valor,
      'fecha_registro': fechaRegistro,
      'activo': activo,
    };
  }
}
