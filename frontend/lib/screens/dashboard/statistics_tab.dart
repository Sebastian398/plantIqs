import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Librería para gráficos
import 'package:plantiq/generated/l10n.dart'; // Traducciones i18n
import '../../models/cultivo.dart'; // Modelo Cultivo
import '../../models/Riego.dart'; // Modelo LecturaSensor
import '../../services/api_service.dart'; // Servicios API

/// Pantalla que muestra estadísticas de los cultivos,
/// incluyendo gráficos de humedad y temperatura.
class StatisticsTab extends StatefulWidget {
  const StatisticsTab({super.key});

  @override
  State<StatisticsTab> createState() => _StatisticsTabState();
}

class _StatisticsTabState extends State<StatisticsTab> {
  /// Lista de cultivos obtenida desde la API
  late Future<List<Cultivo1>> futureCultivos;

  /// Lista de lecturas de sensores (humedad, temperatura)
  Future<List<LecturaSensor>>? futureLecturas;

  /// Cultivo seleccionado en el dropdown
  Cultivo1? selectedCultivo;

  /// Tipo de gráfico: 'line' | 'bar' | 'radialBar'
  String chartType = 'line';

  @override
  void initState() {
    super.initState();
    // Carga inicial de cultivos
    futureCultivos = ApiService.getCultivos1();
    // No se cargan lecturas todavía hasta seleccionar un cultivo
  }

  /// Función que carga las lecturas de sensores de un cultivo
  void cargarLecturas(int cultivoId) {
    futureLecturas = ApiService.getLecturasSensores(cultivoId: cultivoId);
    setState(() {}); // Actualiza la UI al asignar las lecturas
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme; // Colores del tema actual
    final loc = AppLocalizations.of(context); // Traducciones

    return Scaffold(
      backgroundColor: colors.secondary,
      body: FutureBuilder<List<Cultivo1>>(
        future: futureCultivos, // Future que obtiene los cultivos
        builder: (context, cultivoSnapshot) {
          // Mientras se cargan los cultivos
          if (cultivoSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: colors.tertiary),
            );
          }
          // Si ocurre un error al cargar los cultivos
          else if (cultivoSnapshot.hasError) {
            return Center(child: Text('Error: ${cultivoSnapshot.error}'));
          }
          // Si no hay cultivos disponibles
          else if (!cultivoSnapshot.hasData || cultivoSnapshot.data!.isEmpty) {
            return Center(child: Text(loc.noCrops));
          }

          // Cultivos cargados correctamente
          final cultivos = cultivoSnapshot.data!;

          return Column(
            children: [
              /// Fila con los dropdowns para seleccionar cultivo y tipo de gráfico
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // Dropdown de cultivos
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
                                cargarLecturas(
                                  c.id,
                                ); // Cargar lecturas al seleccionar
                              }
                            },
                            icon: Icon(
                              Icons.arrow_drop_down, // Icono de la flecha
                              color: colors.onPrimary, // Color de la flecha
                              size: 30, // Tamaño de la flecha
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Dropdown de tipo de gráfico
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
                                chartType =
                                    v ?? 'line'; // Cambiar tipo de gráfico
                              });
                            },
                            icon: Icon(
                              Icons.arrow_drop_down, // Icono de la flecha
                              color: colors.onPrimary, // Color de la flecha
                              size: 30, // Tamaño de la flecha
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// Área principal donde se muestran los gráficos
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
                          // Mientras se cargan las lecturas
                          if (lecturaSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: colors.onPrimary,
                              ),
                            );
                          }
                          // Error al cargar lecturas
                          else if (lecturaSnapshot.hasError) {
                            return Center(
                              child: Text('Error: ${lecturaSnapshot.error}'),
                            );
                          }
                          // Si no hay datos
                          else if (!lecturaSnapshot.hasData ||
                              lecturaSnapshot.data!.isEmpty) {
                            return Center(
                              child: Text(
                                'No hay datos',
                                style: TextStyle(color: colors.onPrimary),
                              ),
                            );
                          }

                          final lecturas = lecturaSnapshot.data!;

                          // Filtrar lecturas por tipo de sensor
                          final humedadLecturas = lecturas
                              .where((l) => l.tipoSensor == 'humedad')
                              .toList();
                          final temperaturaLecturas = lecturas
                              .where((l) => l.tipoSensor == 'temperatura')
                              .toList();

                          // Depuración: imprimir lecturas
                          print('Lecturas recibidas (${lecturas.length}):');
                          for (var l in lecturas) {
                            print(
                              'id:${l.id} tipo:${l.tipoSensor} valor:${l.valor}',
                            );
                          }

                          // Lista con gráficos de humedad y temperatura
                          return ListView(
                            padding: const EdgeInsets.all(12),
                            children: [
                              // Gráfico de humedad
                              Text(
                                loc.humidity,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              SizedBox(
                                height: 250,
                                child: _buildChart(
                                  humedadLecturas,
                                  Colors.blueAccent,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Gráfico de temperatura
                              Text(
                                loc.temperature,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              SizedBox(
                                height: 250,
                                child: _buildChart(
                                  temperaturaLecturas,
                                  Colors.greenAccent,
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
    );
  }

  /// Construye un gráfico según el tipo seleccionado
  Widget _buildChart(List<LecturaSensor> lecturas, Color color) {
    if (lecturas.isEmpty) return Center(child: Text('No hay datos'));

    // Transformar lecturas a puntos para los gráficos
    final spots = <FlSpot>[];
    for (int i = 0; i < lecturas.length; i++) {
      spots.add(FlSpot(i.toDouble(), lecturas[i].valor));
    }

    switch (chartType) {
      case 'bar':
        // Gráfico de barras
        return BarChart(
          BarChartData(
            barGroups: spots
                .map(
                  (spot) => BarChartGroupData(
                    x: spot.x.toInt(),
                    barRods: [
                      BarChartRodData(toY: spot.y, color: color, width: 16),
                    ],
                  ),
                )
                .toList(),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
            ),
            borderData: FlBorderData(show: false),
          ),
        );

      case 'radialBar':
        // Gráfico radial (tipo PieChart)
        final lastValue = spots.last.y;
        return PieChart(
          PieChartData(
            centerSpaceRadius: 35,
            sectionsSpace: 3,
            sections: [
              PieChartSectionData(
                value: lastValue,
                color: color,
                radius: 55,
                title: lastValue.toStringAsFixed(1),
                titleStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              PieChartSectionData(
                value: 100 - lastValue,
                color: Colors.grey.shade800,
                radius: 55,
                title: '',
              ),
            ],
          ),
        );

      default:
        // Gráfico de líneas
        return LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: color,
                barWidth: 3,
                dotData: FlDotData(show: true),
                belowBarData: BarAreaData(
                  show: true,
                  color: color.withOpacity(0.3),
                ),
              ),
            ],
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
            ),
            gridData: FlGridData(show: true),
          ),
        );
    }
  }
}
