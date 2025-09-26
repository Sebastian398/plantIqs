import '../models/riegos.dart';

class Lote {
  final int id;
  final String nombre;
  final List<Riego> riegos;

  Lote({required this.id, required this.nombre, List<Riego>? riegos})
    : riegos = riegos ?? [];

  factory Lote.fromJson(Map<String, dynamic> json) {
    return Lote(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      riegos:
          (json['riegos'] as List<dynamic>?)
              ?.map((r) => Riego.fromJson(r as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
