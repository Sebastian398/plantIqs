import 'dart:async'; // Import necesario para Timer
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Librería para gráficos
import 'package:plantiq/generated/l10n.dart'; // Traducciones i18n
import '../../models/cultivo.dart'; // Modelo Cultivo
import '../../models/Riego.dart'; // Modelo LecturaSensor
import '../../services/api_service.dart'; // Servicios API
import 'package:collection/collection.dart';

/// Pantalla que muestra estadísticas de los cultivos,
/// incluyendo gráficos de humedad.
class StatisticsTab extends StatefulWidget {
  const StatisticsTab({super.key});

  @override
  State<StatisticsTab> createState() => _StatisticsTabState();
}

class _StatisticsTabState extends State<StatisticsTab> {
  late Future<List<Cultivo1>> futureCultivos;
  Future<List<LecturaSensor>>? futureLecturas;
  Future<bool>? futureEstadoBomba;
  Cultivo1? selectedCultivo;
  String chartType = 'line';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    futureCultivos = ApiService.getCultivos1();
    futureEstadoBomba = ApiService.getEstadoBomba();

    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _refreshData();
    });
  }

  void _refreshData() async {
    // MODIFICADO: Indicar que se está actualizando (opcional)
    setState(() {
      // Los datos se mantienen, solo se actualiza el estado de carga
    });

    try {
      final cultivos = await ApiService.getCultivos1();
      final estadoBomba = await ApiService.getEstadoBomba();

      setState(() {
        futureCultivos = Future.value(cultivos);
        futureEstadoBomba = Future.value(estadoBomba);

        if (selectedCultivo != null) {
          var cultivoActualizado = cultivos.firstWhereOrNull(
            (c) => c.id == selectedCultivo!.id,
          );
          selectedCultivo = cultivoActualizado;

          if (selectedCultivo != null) {
            futureLecturas = ApiService.getLecturasSensores(
              cultivoId: selectedCultivo!.id,
            );
          } else {
            futureLecturas = null;
          }
        }
      });
    } catch (e) {
      // AGREGADO: Manejar errores sin afectar los datos actuales
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error actualizando datos: $e"),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void cargarLecturas(int cultivoId) {
    futureLecturas = ApiService.getLecturasSensores(cultivoId: cultivoId);
    setState(() {});
  }

  void _toggleBomba() async {
    try {
      final currentState = await futureEstadoBomba ?? false;
      bool newState = !currentState;
      await ApiService.activarBomba(newState);

      setState(() {
        futureEstadoBomba = ApiService.getEstadoBomba();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newState
                ? AppLocalizations.of(context).msgBombaEncendida
                : AppLocalizations.of(context).msgBombaApagada,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: colors.secondary,
      body: Stack(
        children: [
          FutureBuilder<List<Cultivo1>>(
            future: futureCultivos,
            builder: (context, cultivoSnapshot) {
              if (cultivoSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: colors.tertiary),
                );
              } else if (cultivoSnapshot.hasError) {
                return Center(child: Text('Error: ${cultivoSnapshot.error}'));
              } else if (!cultivoSnapshot.hasData ||
                  cultivoSnapshot.data!.isEmpty) {
                return Center(child: Text(loc.noCrops));
              }

              final cultivos = cultivoSnapshot.data!;

              return Column(
                children: [
                  // MEJORADO: Controles con mejor diseño
                  Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: colors.shadow.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Seleccionar Cultivo',
                                style: TextStyle(
                                  color: colors.onSurface,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: colors.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<Cultivo1>(
                                    isExpanded: true,
                                    hint: Text(
                                      loc.selectCrop,
                                      style: TextStyle(
                                        color: colors.onPrimary,
                                        fontSize: 14,
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    dropdownColor: colors.primary,
                                    style: TextStyle(
                                      color: colors.onPrimary,
                                      fontSize: 14,
                                    ),
                                    value: selectedCultivo,
                                    items: cultivos
                                        .map(
                                          (c) => DropdownMenuItem<Cultivo1>(
                                            value: c,
                                            child: Text(c.nombreCultivo),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (c) {
                                      setState(() {
                                        selectedCultivo = c;
                                      });
                                      if (c != null) {
                                        cargarLecturas(c.id);
                                      }
                                    },
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: colors.onPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tipo de Gráfica',
                                style: TextStyle(
                                  color: colors.onSurface,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: colors.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: chartType,
                                    isExpanded: true,
                                    borderRadius: BorderRadius.circular(8),
                                    dropdownColor: colors.primary,
                                    style: TextStyle(
                                      color: colors.onPrimary,
                                      fontSize: 14,
                                    ),
                                    items: [
                                      DropdownMenuItem(
                                        value: 'line',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.show_chart,
                                              color: colors.onPrimary,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(loc.lines),
                                          ],
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 'bar',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.bar_chart,
                                              color: colors.onPrimary,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(loc.bars),
                                          ],
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 'radialBar',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.donut_small,
                                              color: colors.onPrimary,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(loc.radial),
                                          ],
                                        ),
                                      ),
                                    ],
                                    onChanged: (v) {
                                      setState(() {
                                        chartType = v ?? 'line';
                                      });
                                    },
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: colors.onPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: futureLecturas == null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.analytics_outlined,
                                  size: 64,
                                  color: colors.onSecondary.withOpacity(0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  loc.selectPlotInstruction,
                                  style: TextStyle(
                                    color: colors.onSecondary.withOpacity(0.7),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : FutureBuilder<List<LecturaSensor>>(
                            future: futureLecturas,
                            builder: (context, lecturaSnapshot) {
                              bool showSpinner =
                                  lecturaSnapshot.connectionState ==
                                      ConnectionState.waiting &&
                                  !lecturaSnapshot.hasData;

                              if (showSpinner) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: colors.primary,
                                  ),
                                );
                              }

                              if (lecturaSnapshot.hasError) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        size: 48,
                                        color: colors.error,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Error: ${lecturaSnapshot.error}',
                                        style: TextStyle(color: colors.error),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              if (!lecturaSnapshot.hasData ||
                                  lecturaSnapshot.data!.isEmpty) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.data_usage_outlined,
                                        size: 48,
                                        color: colors.onSecondary.withOpacity(
                                          0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No hay datos disponibles',
                                        style: TextStyle(
                                          color: colors.onSecondary.withOpacity(
                                            0.7,
                                          ),
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              final lecturas = lecturaSnapshot.data!;
                              final humedadLecturas = lecturas
                                  .where((l) => l.tipoSensor == 'humedad')
                                  .toList();

                              if (humedadLecturas.isEmpty) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.opacity_outlined,
                                        size: 48,
                                        color: colors.onSecondary.withOpacity(
                                          0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No hay datos de humedad disponibles',
                                        style: TextStyle(
                                          color: colors.onSecondary.withOpacity(
                                            0.7,
                                          ),
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              return SingleChildScrollView(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // MEJORADO: Título con card y estadísticas resumidas
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            colors.tertiary,
                                            colors.tertiary.withOpacity(0.8),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: colors.tertiary.withOpacity(
                                              0.3,
                                            ),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(
                                                  8,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: colors.onTertiary
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Icon(
                                                  Icons.opacity,
                                                  color: colors.onTertiary,
                                                  size: 24,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Text(
                                                loc.humidity,
                                                style: TextStyle(
                                                  color: colors.onTertiary,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          _buildHumidityStats(
                                            humedadLecturas,
                                            colors,
                                          ),
                                        ],
                                      ),
                                    ),

                                    // AUMENTADO: Más espacio entre título y gráfica
                                    const SizedBox(height: 32),

                                    // MEJORADO: Container para la gráfica
                                    Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: colors.surface,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: colors.shadow.withOpacity(
                                              0.05,
                                            ),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Gráfica de Tendencia',
                                                style: TextStyle(
                                                  color: colors.onSurface,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const Spacer(),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: colors.tertiary
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  'Últimos 10 registros',
                                                  style: TextStyle(
                                                    color: colors.tertiary,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          SizedBox(
                                            height: 400,
                                            child: _buildChart(
                                              humedadLecturas,
                                              colors.tertiary,
                                              colors,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Espacio adicional para el botón flotante
                                    const SizedBox(height: 100),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
          // MEJORADO: Botón de bomba con mejor diseño
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: FutureBuilder<bool>(
                future: futureEstadoBomba,
                builder: (context, snapshot) {
                  final isOn = snapshot.data ?? false;
                  final buttonColor = isOn ? colors.tertiary : colors.outline;
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: buttonColor.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _toggleBomba,
                      icon: Icon(
                        isOn ? Icons.power_off : Icons.power,
                        color: isOn ? colors.onTertiary : colors.onSurface,
                        size: 24,
                      ),
                      label: Text(
                        isOn ? loc.labelApagarBomba : loc.labelEncenderBomba,
                        style: TextStyle(
                          color: isOn ? colors.onTertiary : colors.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // NUEVO: Widget para mostrar estadísticas resumidas
  Widget _buildHumidityStats(
    List<LecturaSensor> humedadLecturas,
    ColorScheme colors,
  ) {
    if (humedadLecturas.isEmpty) {
      return Text(
        'Sin datos disponibles',
        style: TextStyle(color: colors.onTertiary.withOpacity(0.7)),
      );
    }

    // Ordenar por fecha
    humedadLecturas.sort((a, b) {
      final fechaA =
          a.fechaRegistro ?? DateTime.fromMillisecondsSinceEpoch(a.id * 1000);
      final fechaB =
          b.fechaRegistro ?? DateTime.fromMillisecondsSinceEpoch(b.id * 1000);
      return fechaA.compareTo(fechaB);
    });

    // CORREGIDO: Usar double.parse y toDouble() para asegurar tipo double
    final ultimoValor =
        (humedadLecturas.last.valor is String
                ? double.parse(humedadLecturas.last.valor.toString())
                : humedadLecturas.last.valor.toDouble())
            .clamp(0.0, 100.0);

    final valores = humedadLecturas
        .map(
          (l) =>
              (l.valor is String
                      ? double.parse(l.valor.toString())
                      : l.valor.toDouble())
                  .clamp(0.0, 100.0),
        )
        .toList();

    final promedio = valores.reduce((a, b) => a + b) / valores.length;
    final maximo = valores.reduce((a, b) => a > b ? a : b);
    final minimo = valores.reduce((a, b) => a < b ? a : b);

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Actual',
            '${ultimoValor.toStringAsFixed(1)}%',
            Icons.water_drop,
            colors,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Promedio',
            '${promedio.toStringAsFixed(1)}%',
            Icons.analytics,
            colors,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Máximo',
            '${maximo.toStringAsFixed(1)}%',
            Icons.trending_up,
            colors,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Mínimo',
            '${minimo.toStringAsFixed(1)}%',
            Icons.trending_down,
            colors,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    ColorScheme colors,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.onTertiary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.onTertiary.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: colors.onTertiary, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: colors.onTertiary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: colors.onTertiary.withOpacity(0.8),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(
    List<LecturaSensor> lecturas,
    Color color,
    ColorScheme colors,
  ) {
    if (lecturas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              size: 48,
              color: colors.onSurface.withOpacity(0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay datos para mostrar',
              style: TextStyle(
                color: colors.onSurface.withOpacity(0.6),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    // Ordenar las lecturas por fecha
    lecturas.sort((a, b) {
      final fechaA =
          a.fechaRegistro ?? DateTime.fromMillisecondsSinceEpoch(a.id * 1000);
      final fechaB =
          b.fechaRegistro ?? DateTime.fromMillisecondsSinceEpoch(b.id * 1000);
      return fechaA.compareTo(fechaB);
    });

    // Ventana deslizante: siempre mostrar los últimos 10 datos
    const maxDatos = 10;
    List<LecturaSensor> lecturasVentana = lecturas.length > maxDatos
        ? lecturas.sublist(lecturas.length - maxDatos)
        : lecturas;

    // Crear spots para la gráfica con índices consecutivos (0, 1, 2, ...)
    final spots = <FlSpot>[];
    for (int i = 0; i < lecturasVentana.length; i++) {
      // CORREGIDO: Asegurar que el valor sea double
      final valor =
          (lecturasVentana[i].valor is String
                  ? double.parse(lecturasVentana[i].valor.toString())
                  : lecturasVentana[i].valor.toDouble())
              .clamp(0.0, 100.0);
      spots.add(FlSpot(i.toDouble(), valor));
    }

    // MEJORADO: Configurar títulos con etiquetas más claras y fechas
    final titlesData = FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1.0,
          reservedSize: 40,
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            if (index < 0 || index >= lecturasVentana.length)
              return const Text('');

            // Mostrar etiquetas más espaciadas
            if (lecturasVentana.length <= 5 || index % 2 == 0) {
              final fecha =
                  lecturasVentana[index].fechaRegistro ??
                  DateTime.fromMillisecondsSinceEpoch(
                    lecturasVentana[index].id * 1000,
                  );

              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  '${fecha.day}/${fecha.month}\n${fecha.hour}:${fecha.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 10,
                    color: colors.onSurface.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return const Text('');
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 20.0,
          reservedSize: 50,
          getTitlesWidget: (value, meta) {
            if (value < 0 || value > 100) return Container();
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                '${value.toInt()}%',
                style: TextStyle(
                  fontSize: 12,
                  color: colors.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          },
        ),
      ),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );

    switch (chartType) {
      case 'bar':
        return BarChart(
          BarChartData(
            maxY: 100,
            minY: 0,
            barGroups: spots
                .map(
                  (spot) => BarChartGroupData(
                    x: spot.x.toInt(),
                    barRods: [
                      BarChartRodData(
                        toY: spot.y,
                        color: color,
                        width: 20,
                        borderRadius: BorderRadius.circular(4),
                        gradient: LinearGradient(
                          colors: [color, color.withOpacity(0.7)],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
            titlesData: titlesData,
            borderData: FlBorderData(show: false),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 20.0,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: colors.onSurface.withOpacity(0.1),
                  strokeWidth: 1,
                );
              },
            ),
            backgroundColor: Colors.transparent,
          ),
        );

      case 'radialBar':
        // CORREGIDO: Asegurar que ultimoValor sea double
        final ultimoValor = lecturasVentana.isNotEmpty
            ? (lecturasVentana.last.valor is String
                      ? double.parse(lecturasVentana.last.valor.toString())
                      : lecturasVentana.last.valor.toDouble())
                  .clamp(0.0, 100.0)
            : 0.0;

        // Calcular estado de la humedad usando colores del tema
        String estado;
        Color estadoColor;
        if (ultimoValor < 30) {
          estado = 'Baja';
          estadoColor = colors.error;
        } else if (ultimoValor < 70) {
          estado = 'Normal';
          estadoColor = colors.tertiary;
        } else {
          estado = 'Alta';
          estadoColor = colors.primary;
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 80,
                  sectionsSpace: 4,
                  sections: [
                    PieChartSectionData(
                      value: ultimoValor,
                      color: estadoColor,
                      radius: 80,
                      title: '',
                      gradient: LinearGradient(
                        colors: [estadoColor, estadoColor.withOpacity(0.7)],
                      ),
                    ),
                    PieChartSectionData(
                      value: 100 - ultimoValor,
                      color: colors.onSurface.withOpacity(0.1),
                      radius: 80,
                      title: '',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: estadoColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: estadoColor.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Text(
                    '${ultimoValor.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: estadoColor,
                    ),
                  ),
                  Text(
                    'Humedad $estado',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: estadoColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );

      default: // line chart
        return LineChart(
          LineChartData(
            maxY: 100,
            minY: 0,
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: color,
                barWidth: 4,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) =>
                      FlDotCirclePainter(
                        radius: 6,
                        color: color,
                        strokeWidth: 3,
                        strokeColor: colors.surface,
                      ),
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.4), color.withOpacity(0.1)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                shadow: Shadow(
                  color: color.withOpacity(0.3),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ),
            ],
            titlesData: titlesData,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 20.0,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: colors.onSurface.withOpacity(0.1),
                  strokeWidth: 1,
                );
              },
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(
                color: colors.onSurface.withOpacity(0.1),
                width: 1,
              ),
            ),
            backgroundColor: Colors.transparent,
            lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                tooltipRoundedRadius: 8,
                tooltipPadding: const EdgeInsets.all(8),
                getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                  return touchedBarSpots.map((barSpot) {
                    final index = barSpot.x.toInt();
                    if (index < lecturasVentana.length) {
                      final lectura = lecturasVentana[index];
                      final fecha =
                          lectura.fechaRegistro ??
                          DateTime.fromMillisecondsSinceEpoch(
                            lectura.id * 1000,
                          );

                      return LineTooltipItem(
                        'Humedad: ${barSpot.y.toStringAsFixed(1)}%\n${fecha.day}/${fecha.month} ${fecha.hour}:${fecha.minute.toString().padLeft(2, '0')}',
                        TextStyle(color: color, fontWeight: FontWeight.w600),
                      );
                    }
                    return null;
                  }).toList();
                },
              ),
            ),
          ),
        );
    }
  }
}
