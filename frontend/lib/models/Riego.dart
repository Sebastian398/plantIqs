class LecturaSensor {
  final int id;
  final String tipoSensor; // "humedad" o "temperatura"
  final double valor;
  final DateTime fechaRegistro;
  final int? cultivoId; // id del cultivo relacionado

  LecturaSensor({
    required this.id,
    required this.tipoSensor,
    required this.valor,
    required this.fechaRegistro,
    required this.cultivoId,
  });

  factory LecturaSensor.fromJson(Map<String, dynamic> json) {
    return LecturaSensor(
      id: json['id'] as int,
      tipoSensor: json['tipo'] as String? ?? 'desconocido',
      valor: (json['valor'] as num).toDouble(),
      fechaRegistro: DateTime.parse(json['fecha_registro']),
      cultivoId: json['cultivo'] as int,
    );
  }
}
