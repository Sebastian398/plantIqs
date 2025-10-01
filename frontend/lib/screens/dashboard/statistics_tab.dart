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
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: colors.primary,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<Cultivo1>(
                                isExpanded: true,
                                hint: Text(
                                  loc.selectCrop,
                                  style: TextStyle(
                                    color: colors.onPrimary,
                                    fontSize: 16,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(5),
                                dropdownColor: colors.primary,
                                style: TextStyle(
                                  color: colors.onPrimary,
                                  fontSize: 16,
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
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: colors.primary,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: chartType,
                                isExpanded: true,
                                borderRadius: BorderRadius.circular(5),
                                dropdownColor: colors.primary,
                                style: TextStyle(
                                  color: colors.onPrimary,
                                  fontSize: 16,
                                ),
                                items: [
                                  DropdownMenuItem(
                                    value: 'line',
                                    child: Text(loc.lines),
                                  ),
                                  DropdownMenuItem(
                                    value: 'bar',
                                    child: Text(loc.bars),
                                  ),
                                  DropdownMenuItem(
                                    value: 'radialBar',
                                    child: Text(loc.radial),
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
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: futureLecturas == null
                        ? Center(
                            child: Text(
                              loc.selectPlotInstruction,
                              style: TextStyle(color: colors.onPrimary),
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
                                    color: colors.onPrimary,
                                  ),
                                );
                              }

                              if (lecturaSnapshot.hasError) {
                                return Center(
                                  child: Text(
                                    'Error: ${lecturaSnapshot.error}',
                                  ),
                                );
                              }

                              if (!lecturaSnapshot.hasData ||
                                  lecturaSnapshot.data!.isEmpty) {
                                return Center(
                                  child: Text(
                                    'No hay datos',
                                    style: TextStyle(color: colors.onPrimary),
                                  ),
                                );
                              }

                              final lecturas = lecturaSnapshot.data!;
                              final humedadLecturas = lecturas
                                  .where((l) => l.tipoSensor == 'humedad')
                                  .toList();

                              // ELIMINÉ LA LÓGICA DE LIMITACIÓN AQUÍ
                              // La ventana deslizante se maneja ahora en _buildChart

                              return ListView(
                                padding: const EdgeInsets.all(12),
                                children: [
                                  Text(
                                    loc.humidity,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleLarge,
                                  ),
                                  // AGREGADO: Espacio entre el título y las estadísticas
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    height: 350,
                                    child: _buildChart(
                                      humedadLecturas,
                                      Colors.blueAccent,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: FutureBuilder<bool>(
                future: futureEstadoBomba,
                builder: (context, snapshot) {
                  final isOn = snapshot.data ?? false;
                  return ElevatedButton.icon(
                    onPressed: _toggleBomba,
                    icon: Icon(
                      isOn ? Icons.power_off : Icons.power,
                      color: colors.onPrimary,
                    ),
                    label: Text(
                      isOn ? loc.labelApagarBomba : loc.labelEncenderBomba,
                      style: TextStyle(color: colors.onPrimary),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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

  Widget _buildChart(List<LecturaSensor> lecturas, Color color) {
    if (lecturas.isEmpty) return Center(child: Text('No hay datos'));

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
      final valor = lecturasVentana[i].valor.clamp(0.0, 100.0);
      spots.add(FlSpot(i.toDouble(), valor));
    }

    // Configurar títulos con etiquetas más descriptivas
    final titlesData = FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1.0, // Mostrar cada punto
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            if (index < 0 || index >= lecturasVentana.length)
              return const Text('');

            // Mostrar solo algunos labels para evitar sobrecarga visual
            if (lecturasVentana.length <= 5 || index % 2 == 0) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(fontSize: 10),
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
          getTitlesWidget: (value, meta) {
            if (value < 0 || value > 100) return Container();
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                '${value.toInt()}%',
                style: const TextStyle(fontSize: 12),
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
                      BarChartRodData(toY: spot.y, color: color, width: 15),
                    ],
                  ),
                )
                .toList(),
            titlesData: titlesData,
            borderData: FlBorderData(show: false),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              horizontalInterval: 20.0,
              verticalInterval: 1.0,
            ),
          ),
        );
      case 'radialBar':
        final ultimoValor = lecturasVentana.isNotEmpty
            ? lecturasVentana.last.valor.clamp(0, 100)
            : 0.0;
        // Para el radial, usar los últimos 3 datos para el promedio
        final numUltimos = lecturasVentana.length > 3
            ? 3
            : lecturasVentana.length;
        final ultimos = lecturasVentana.length > numUltimos
            ? lecturasVentana.sublist(lecturasVentana.length - numUltimos)
            : lecturasVentana;
        final promedio = ultimos.isNotEmpty
            ? ultimos.map((l) => l.valor).reduce((a, b) => a + b) /
                  ultimos.length
            : 0.0;
        final valorUsado = (ultimoValor + promedio) / 2;

        return PieChart(
          PieChartData(
            centerSpaceRadius: 40,
            sectionsSpace: 2,
            sections: [
              PieChartSectionData(
                value: valorUsado,
                color: color,
                radius: 60,
                title: '${valorUsado.toStringAsFixed(1)}%',
                titleStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              PieChartSectionData(
                value: 100 - valorUsado,
                color: Colors.grey.shade300,
                radius: 60,
                title: '',
              ),
            ],
          ),
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
                barWidth: 3,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) =>
                      FlDotCirclePainter(
                        radius: 4,
                        color: color,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      ),
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: color.withOpacity(0.3),
                ),
              ),
            ],
            titlesData: titlesData,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              horizontalInterval: 20.0,
              verticalInterval: 1.0,
            ),
            borderData: FlBorderData(show: false),
          ),
        );
    }
  }
}
