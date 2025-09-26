class Riego {
  final int id;
  final String? nombre;
  final DateTime? fecha; // nullable
  final double? cantidadAgua;
  final String? descripcion;
  final int? loteId;

  final double? ph;
  final double? humedad;

  Riego({
    required this.id,
    this.nombre,
    this.fecha,
    this.cantidadAgua,
    this.descripcion,
    this.loteId,
    this.ph,
    this.humedad,
  });

  factory Riego.fromJson(Map<String, dynamic> json) {
    return Riego(
      id: json['id'] as int,
      nombre: json['nombre'] as String? ?? '',
      fecha: json['fecha'] != null ? DateTime.tryParse(json['fecha']) : null,
      cantidadAgua: (json['cantidad_agua'] as num?)?.toDouble(),
      descripcion: json['descripcion'] as String? ?? '',
      loteId: json['lote_id'] as int?,
      ph: (json['ph'] as num?)?.toDouble(),
      humedad: (json['humedad'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'fecha': fecha?.toIso8601String(),
      'cantidad_agua': cantidadAgua,
      'descripcion': descripcion,
      'lote_id': loteId,
      'ph': ph,
      'humedad': humedad,
    };
  }
}
