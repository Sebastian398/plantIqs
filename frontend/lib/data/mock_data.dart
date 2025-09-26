import '../models/lote.dart';
import '../models/riegos.dart';

// Mock data para riegos de lote 1
final List<Riego> mockRiegosLote1 = [
  Riego(
    id: 1,
    nombre: 'Riego 1A',
    fecha: DateTime.now().subtract(const Duration(days: 1)),
    cantidadAgua: 100.0,
    descripcion: 'Riego inicial',
    loteId: 1,
    ph: 6.5,
    humedad: 20.0,
  ),
  Riego(
    id: 2,
    nombre: 'Riego 1B',
    fecha: DateTime.now(),
    cantidadAgua: 120.0,
    descripcion: 'Riego secundario',
    loteId: 1,
    ph: 6.8,
    humedad: 25.0,
  ),
];

// Mock data para riegos de lote 2
final List<Riego> mockRiegosLote2 = [
  Riego(
    id: 3,
    nombre: 'Riego 2A',
    fecha: DateTime.now().subtract(const Duration(days: 2)),
    cantidadAgua: 90.0,
    descripcion: 'Riego inicial',
    loteId: 2,
    ph: 6.6,
    humedad: 18.0,
  ),
  Riego(
    id: 4,
    nombre: 'Riego 2B',
    fecha: DateTime.now().subtract(const Duration(days: 1)),
    cantidadAgua: 110.0,
    descripcion: 'Riego intermedio',
    loteId: 2,
    ph: 6.7,
    humedad: 22.0,
  ),
  Riego(
    id: 5,
    nombre: 'Riego 2C',
    fecha: DateTime.now(),
    cantidadAgua: 130.0,
    descripcion: 'Riego final',
    loteId: 2,
    ph: 7.0,
    humedad: 30.0,
  ),
];

// Mock data para lotes sin aspersores, pero con riegos
final List<Lote> mockLotes = [
  Lote(id: 1, nombre: 'Lote 1', riegos: mockRiegosLote1),
  Lote(id: 2, nombre: 'Lote 2', riegos: mockRiegosLote2),
];
