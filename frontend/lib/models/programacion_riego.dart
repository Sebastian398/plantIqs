class ProgramacionRiego {
  final int id;
  final String? inicio;
  final int? duracion;
  final bool activo;
  

  ProgramacionRiego({
    required this.id,
    required this.inicio,
    required this.duracion,
    required this.activo,
  });

  factory ProgramacionRiego.fromJson(Map<String, dynamic> json) {
    return ProgramacionRiego(
      id: json['id'],
      inicio: json['inicio'],
      duracion: json['duracion'],
      activo: json['activo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'inicio': inicio,
      'duracion': duracion,
      'activo': activo,
    };
  }
}
