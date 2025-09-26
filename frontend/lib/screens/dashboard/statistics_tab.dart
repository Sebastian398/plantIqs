import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:plantiq/generated/l10n.dart';
import '../../models/cultivo.dart';
import '../../models/Riego.dart';
import '../../services/api_service.dart';

class StatisticsTab extends StatefulWidget {
  const StatisticsTab({super.key});

  @override
  State<StatisticsTab> createState() => _StatisticsTabState();
}

class _StatisticsTabState extends State<StatisticsTab> {
  late Future<List<Cultivo1>> futureCultivos;
  Future<List<LecturaSensor>>? futureLecturas;
  Cultivo1? selectedCultivo;
  String chartType = 'line';

  @override
  void initState() {
    super.initState();
    futureCultivos = ApiService.getCultivos1();
    // futureLecturas no se carga aquí para evitar carga al inicio sin cultivo
  }

  void cargarLecturas(int cultivoId) {
    futureLecturas = ApiService.getLecturasSensores(cultivoId: cultivoId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: colors.surface,
      body: FutureBuilder<List<Cultivo1>>(
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
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<Cultivo1>(
                            isExpanded: true,
                            hint: Text(
                              loc.selectCrop,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            dropdownColor: colors.surface,
                            style: Theme.of(context).textTheme.bodyLarge,
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
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: chartType,
                            isExpanded: true,
                            dropdownColor: colors.surface,
                            style: Theme.of(context).textTheme.bodyLarge,
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
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: futureLecturas == null
                    ? Center(child: Text(loc.selectPlotInstruction))
                    : FutureBuilder<List<LecturaSensor>>(
                        future: futureLecturas,
                        builder: (context, lecturaSnapshot) {
                          if (lecturaSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: colors.tertiary,
                              ),
                            );
                          } else if (lecturaSnapshot.hasError) {
                            return Center(
                              child: Text('Error: ${lecturaSnapshot.error}'),
                            );
                          } else if (!lecturaSnapshot.hasData ||
                              lecturaSnapshot.data!.isEmpty) {
                            return Center(child: Text('No hay datos'));
                          }

                          final lecturas = lecturaSnapshot.data!;
                          final humedadLecturas = lecturas
                              .where((l) => l.tipoSensor == 'humedad')
                              .toList();
                          final temperaturaLecturas = lecturas
                              .where((l) => l.tipoSensor == 'temperatura')
                              .toList();

                          print('Lecturas recibidas (${lecturas.length}):');
                          for (var l in lecturas) {
                            print(
                              'id:${l.id} tipo:${l.tipoSensor} valor:${l.valor}',
                            );
                          }

                          return ListView(
                            padding: const EdgeInsets.all(12),
                            children: [
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

  Widget _buildChart(List<LecturaSensor> lecturas, Color color) {
    if (lecturas.isEmpty) return Center(child: Text('No hay datos'));

    final spots = <FlSpot>[];
    for (int i = 0; i < lecturas.length; i++) {
      spots.add(FlSpot(i.toDouble(), lecturas[i].valor));
    }

    switch (chartType) {
      case 'bar':
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
