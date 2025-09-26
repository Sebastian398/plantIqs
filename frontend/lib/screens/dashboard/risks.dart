import 'package:flutter/material.dart';
import 'package:plantiq/models/programacion_riego.dart';
import '../../services/api_service.dart';
import '../../models/cultivo.dart';
import 'package:plantiq/generated/l10n.dart';

class RisksListScreen extends StatefulWidget {
  const RisksListScreen({super.key});

  @override
  _RisksListScreenState createState() => _RisksListScreenState();
}

class _RisksListScreenState extends State<RisksListScreen> {
  late Future<List<Cultivo>> futureCultivos;

  @override
  void initState() {
    super.initState();
    futureCultivos = ApiService.getCultivos();
  }

  Future<void> _refreshData() async {
    setState(() {
      futureCultivos = ApiService.getCultivos();
    });
  }

  void _createRiego(Cultivo cultivo) {
    final loc = AppLocalizations.of(context);
    final TextEditingController duracionController = TextEditingController();
    TimeOfDay? selectedTime;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              loc.nuevoRiego(cultivo.nombreCultivo ?? loc.sinNombre),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      setState(() {
                        selectedTime = time;
                      });
                    }
                  },
                  child: Text(
                    selectedTime == null
                        ? loc.seleccionarHora
                        : loc.horaInicio(selectedTime!.format(context)),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: duracionController,
                  decoration: InputDecoration(
                    labelText: loc.duracion,
                    prefixIcon: const Icon(Icons.timer),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(loc.cancelar),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (selectedTime == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(loc.msgHoraRequerida)),
                    );
                    return;
                  }

                  final duracion = int.tryParse(duracionController.text) ?? 0;
                  if (duracion <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(loc.msgDuracionInvalida)),
                    );
                    return;
                  }

                  final ahora = DateTime.now();
                  final dt = DateTime(
                    ahora.year,
                    ahora.month,
                    ahora.day,
                    selectedTime!.hour,
                    selectedTime!.minute,
                  );
                  final horaFormateada =
                      "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:00";

                  bool success = await ApiService.createRiego(
                    cultivo.id,
                    horaFormateada,
                    duracion,
                  );

                  if (success) {
                    Navigator.pop(context);
                    _refreshData();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(loc.riegoActualizado)),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(loc.errorGuardarRiego)),
                    );
                  }
                },
                child: Text(loc.guardar),
              ),
            ],
          ),
        );
      },
    );
  }

  void _editRiegoMenu(ProgramacionRiego programacion, Cultivo cultivo) {
    final loc = AppLocalizations.of(context);
    final TextEditingController inicioController = TextEditingController(
      text: programacion.inicio ?? "",
    );
    final TextEditingController duracionController = TextEditingController(
      text: programacion.duracion?.toString() ?? "",
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            loc.editarRiego(cultivo.nombreCultivo ?? loc.sinNombre),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: inicioController,
                decoration: InputDecoration(
                  labelText: loc.inicioRiego,
                  prefixIcon: const Icon(Icons.access_time),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: duracionController,
                decoration: InputDecoration(
                  labelText: loc.duracion,
                  prefixIcon: const Icon(Icons.timer),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(loc.cancelar),
            ),
            ElevatedButton(
              onPressed: () async {
                final nuevoInicio = inicioController.text.trim();
                final nuevaDuracion =
                    int.tryParse(duracionController.text) ?? 0;

                if (nuevoInicio.isEmpty || nuevaDuracion <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(loc.msgDatosInvalidos)),
                  );
                  return;
                }

                final programacionEditada = ProgramacionRiego(
                  id: programacion.id,
                  inicio: nuevoInicio,
                  duracion: nuevaDuracion,
                  activo: programacion.activo,
                );

                try {
                  await ApiService.editarProgramacionRiego(programacionEditada);

                  Navigator.pop(context);
                  _refreshData();

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(loc.riegoActualizado)));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(loc.errorGenericoSnack(e.toString())),
                    ),
                  );
                }
              },
              child: Text(loc.guardarCambios),
            ),
          ],
        );
      },
    );
  }

  void _deleteRiego(ProgramacionRiego programacion, Cultivo cultivo) async {
    final loc = AppLocalizations.of(context);
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.confirmarEliminar),
        content: Text(
          loc.eliminarPregunta(cultivo.nombreCultivo ?? loc.sinNombre),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(loc.cancelar),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(loc.eliminar),
          ),
        ],
      ),
    );

    if (confirm == true) {
      bool success = await ApiService.eliminarRiego(programacion.id);
      if (success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(loc.riegoEliminado)));
        _refreshData();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(loc.errorEliminar)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                loc.listadoRiegos,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<Cultivo>>(
                  future: futureCultivos,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: colors.tertiary,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          loc.errorGenerico(snapshot.error.toString()),
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 18,
                          ),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          loc.noCultivos,
                          style: TextStyle(color: colors.tertiary),
                        ),
                      );
                    }
                    final cultivos = snapshot.data!;
                    return RefreshIndicator(
                      onRefresh: _refreshData,
                      color: colors.tertiary,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: cultivos.length,
                        itemBuilder: (context, index) {
                          final cultivo = cultivos[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: colors.surface,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      cultivo.nombreCultivo ?? loc.sinNombre,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: colors.surface,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          color: colors.tertiary,
                                        ),
                                        tooltip: loc.nuevoRiego(
                                          cultivo.nombreCultivo ??
                                              loc.sinNombre,
                                        ),
                                        onPressed: () => _createRiego(cultivo),
                                        splashRadius: 20,
                                        padding: const EdgeInsets.all(8),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                if (cultivo.programaciones.isNotEmpty)
                                  ...cultivo.programaciones.map((programacion) {
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: colors.surface,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(
                                          loc.riegoALas(
                                            programacion.inicio ?? 'N/A',
                                          ),
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                        ),
                                        subtitle: Text(
                                          loc.duracionMinutos(
                                            programacion.duracion?.toString() ??
                                                'N/A',
                                          ),
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyLarge,
                                        ),
                                        trailing: Wrap(
                                          spacing: 8,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: colors.surface,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.edit,
                                                  color: colors.tertiary,
                                                ),
                                                tooltip: loc.editar,
                                                onPressed: () => _editRiegoMenu(
                                                  programacion,
                                                  cultivo,
                                                ),
                                                splashRadius: 20,
                                                padding: const EdgeInsets.all(
                                                  8,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.redAccent,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: IconButton(
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                ),
                                                tooltip: loc.eliminar,
                                                onPressed: () => _deleteRiego(
                                                  programacion,
                                                  cultivo,
                                                ),
                                                splashRadius: 20,
                                                padding: const EdgeInsets.all(
                                                  8,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  })
                                else
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    child: Text(
                                      loc.noRiegos,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
