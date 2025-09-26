class LecturaSensor {
  final int id;
  final int sensor;
  final double valor;
  final String fechaRegistro;

  LecturaSensor({
    required this.id,
    required this.sensor,
    required this.valor,
    required this.fechaRegistro,
  });

  factory LecturaSensor.fromJson(Map<String, dynamic> json) {
    return LecturaSensor(
      id: json['id'],
      sensor: json['sensor'],
      valor: (json['valor'] as num).toDouble(),
      fechaRegistro: json['fecha_registro'],
    );
  }
}
