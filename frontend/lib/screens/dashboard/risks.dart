import 'package:flutter/material.dart';
import 'package:plantiq/models/programacion_riego.dart';
import '../../services/api_service.dart';
import '../../models/cultivo.dart';
import 'package:plantiq/generated/l10n.dart';

/// Pantalla principal que muestra la lista de cultivos y sus programaciones de riego.
/// Permite crear, editar y eliminar riegos asociados a cada cultivo.
class RisksListScreen extends StatefulWidget {
  const RisksListScreen({super.key});

  @override
  _RisksListScreenState createState() => _RisksListScreenState();
}

/// Estado de la pantalla `RisksListScreen`.
/// Contiene la lógica para:
/// - Obtener cultivos desde la API.
/// - Crear, editar y eliminar programaciones de riego.
/// - Refrescar la lista de cultivos.
class _RisksListScreenState extends State<RisksListScreen> {
  /// Future que obtiene la lista de cultivos desde la API
  late Future<List<Cultivo>> futureCultivos;

  /// Inicialización del estado.
  /// Aquí se carga inicialmente la lista de cultivos.
  @override
  void initState() {
    super.initState();
    futureCultivos = ApiService.getCultivos();
  }

  /// Método para refrescar la lista de cultivos desde la API.
  Future<void> _refreshData() async {
    setState(() {
      futureCultivos = ApiService.getCultivos();
    });
  }

  /// Muestra un diálogo para crear una nueva programación de riego para un cultivo.
  /// Recibe el [cultivo] al que se asociará el riego.
  void _createRiego(Cultivo cultivo) {
    final colors = Theme.of(context).colorScheme; // Colores del tema actual
    final loc = AppLocalizations.of(context); // Traducciones
    final TextEditingController duracionController =
        TextEditingController(); // Duración del riego
    TimeOfDay? selectedTime; // Hora seleccionada

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          // StatefulBuilder permite actualizar el estado dentro del diálogo
          builder: (context, setState) => AlertDialog(
            elevation: 20,
            backgroundColor: colors.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              loc.nuevoRiego(cultivo.nombreCultivo ?? loc.sinNombre),
              style: TextStyle(color: colors.onPrimary),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Botón para seleccionar la hora de inicio del riego
                ElevatedButton(
                  onPressed: () async {
                    // Abrir el TimePicker con colores personalizados
                    TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: colors
                                  .primary, // Cabecera y botones OK/CANCEL
                              onPrimary:
                                  colors.onPrimary, // Texto de los botones
                              surface: colors
                                  .tertiary, // Fondo del cuadro de diálogo
                              onSurface: colors
                                  .onSecondary, // Texto de los números del reloj
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor:
                                    colors.onPrimary, // Color botones
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    // Guardar la hora seleccionada si no es null
                    if (time != null) {
                      setState(() {
                        selectedTime = time;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        colors.tertiary, // Color de fondo del botón
                    foregroundColor:
                        colors.onPrimary, // Color de texto e íconos
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    selectedTime == null
                        ? loc.seleccionarHora
                        : loc.horaInicio(selectedTime!.format(context)),
                    style: TextStyle(fontSize: 16, color: colors.onSecondary),
                  ),
                ),

                const SizedBox(height: 15),
                // Campo para ingresar la duración del riego en minutos
                TextFormField(
                  controller: duracionController,
                  style: TextStyle(
                    color: colors.onSecondary,
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                  ),
                  cursorColor: colors.onSecondary,
                  decoration: InputDecoration(
                    labelText: loc.duracion,
                    labelStyle: TextStyle(
                      color: colors.onSecondary,
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                    ),
                    prefixIcon: Icon(Icons.timer, color: colors.onSecondary),
                    filled: true,
                    fillColor: colors.tertiary,
                    // Línea blanca cuando está deshabilitado o sin foco
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: colors.onPrimary, width: 1),
                    ),
                    // Línea cuando está enfocado
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: colors.secondary, width: 1),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: [
              // Botón para cancelar
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  loc.cancelar,
                  style: TextStyle(color: colors.primary),
                ),
              ),
              // Botón para guardar la programación
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary, // <-- color de fondo
                ),
                onPressed: () async {
                  // Validaciones
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

                  // Formatear la hora para enviar a la API
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

                  // Llamada a la API para crear el riego
                  bool success = await ApiService.createRiego(
                    cultivo.id,
                    horaFormateada,
                    duracion,
                  );

                  // Mostrar resultados
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

  /// Muestra un diálogo para editar una programación de riego existente.
  /// Recibe [programacion] y [cultivo] para editar el riego correspondiente.
  void _editRiegoMenu(ProgramacionRiego programacion, Cultivo cultivo) {
    final loc = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme; // Colores del tema actual
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
          backgroundColor: Theme.of(context).colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            loc.editarRiego(cultivo.nombreCultivo ?? loc.sinNombre),
            style: TextStyle(color: colors.onPrimary),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: inicioController,
                style: TextStyle(
                  color: colors.onSecondary,
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  labelText: loc.inicioRiego,
                  labelStyle: TextStyle(
                    color: colors.onSecondary,
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                  ),
                  prefixIcon: Icon(
                    Icons.access_time,
                    color: colors.onSecondary,
                  ),
                  filled: true,
                  fillColor: colors.tertiary,
                  // Línea blanca cuando está deshabilitado o sin foco
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colors.onPrimary, width: 1),
                  ),
                  // Línea cuando está enfocado
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colors.secondary, width: 1),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: duracionController,
                style: TextStyle(
                  color: colors.onSecondary,
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  labelText: loc.duracion,
                  labelStyle: TextStyle(
                    color: colors.onSecondary,
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                  ),
                  prefixIcon: Icon(Icons.timer, color: colors.onSecondary),
                  filled: true,
                  fillColor: colors.tertiary,
                  // Línea blanca cuando está deshabilitado o sin foco
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colors.onPrimary, width: 1),
                  ),
                  // Línea cuando está enfocado
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colors.secondary, width: 1),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            // Botón para cancelar
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                loc.cancelar,
                style: TextStyle(color: colors.primary),
              ),
            ),
            // Botón para guardar los cambios
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary, // <-- color de fondo
              ),
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

  /// Elimina una programación de riego después de confirmar con el usuario.
  void _deleteRiego(ProgramacionRiego programacion, Cultivo cultivo) async {
    final colors = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context);

    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(
          loc.confirmarEliminar,
          style: TextStyle(color: colors.onPrimary),
        ),
        content: Text(
          loc.eliminarPregunta(cultivo.nombreCultivo ?? loc.sinNombre),
          style: TextStyle(color: colors.onPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(loc.cancelar),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              backgroundColor: Colors.redAccent, // Color de fondo
              foregroundColor: colors.onPrimary, // Color del texto
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Borde redondeado
              ),
            ),
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

  void _deleteCultivo(Cultivo cultivo) async {
    final colors = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context);

    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(
          loc.confirmarEliminar,
          style: TextStyle(color: colors.onPrimary),
        ),
        content: Text(
          AppLocalizations.of(context).msgEliminarCultivo(
            cultivo.nombreCultivo ?? AppLocalizations.of(context).sinNombre,
          ),
          style: TextStyle(color: colors.onPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(loc.cancelar),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              backgroundColor: Colors.redAccent, // Color de fondo
              foregroundColor: colors.onPrimary, // Color del texto
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Borde redondeado
              ),
            ),
            child: Text(loc.eliminar),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        bool success = await ApiService.eliminarCultivo(cultivo.id);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).msgCultivoEliminado),
            ), // Puedes agregar una clave en l10n si prefieres
          );
          _refreshData();
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(loc.errorEliminar)));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar cultivo: ${e.toString()}')),
        );
      }
    }
  }

  /// Construcción de la interfaz de usuario.
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.secondary,
      body: SafeArea(
        child: Center(
          child: Container(
            width: 1000,
            margin: const EdgeInsets.all(100), // margen externo
            padding: const EdgeInsets.all(20), // padding interno
            decoration: BoxDecoration(
              color: colors.primary, // fondo del contenedor principal
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  loc.listadoRiegos,
                  style: TextStyle(
                    color: colors.tertiary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: FutureBuilder<List<Cultivo>>(
                    future: futureCultivos,
                    builder: (context, snapshot) {
                      // Mostrar indicador de carga
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: colors.onPrimary,
                          ),
                        );
                      }
                      // Mostrar mensaje de error
                      else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            loc.errorGenerico(snapshot.error.toString()),
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 18,
                            ),
                          ),
                        );
                      }
                      // Mostrar mensaje si no hay cultivos
                      else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(
                            loc.noCultivos,
                            style: TextStyle(color: colors.onPrimary),
                          ),
                        );
                      }

                      final cultivos = snapshot.data!;

                      // Lista de cultivos con refresco
                      return RefreshIndicator(
                        onRefresh: _refreshData,
                        color: colors.onPrimary,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: cultivos.length,
                          itemBuilder: (context, index) {
                            final cultivo = cultivos[index];

                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: colors.tertiary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Nombre del cultivo y botón de agregar riego
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween, // separa el texto de los botones
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center, // alinea verticalmente
                                    children: [
                                      // Nombre del cultivo
                                      Text(
                                        cultivo.nombreCultivo ?? loc.sinNombre,
                                        style: TextStyle(
                                          color: colors.onSecondary,
                                          fontSize: 20,
                                        ),
                                      ),

                                      // Contenedor de botones
                                      Row(
                                        children: [
                                          // Primer botón
                                          Container(
                                            decoration: BoxDecoration(
                                              color: colors.onPrimary,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.add,
                                                color: colors.secondary,
                                              ),
                                              tooltip: loc.nuevoRiego(
                                                cultivo.nombreCultivo ??
                                                    loc.sinNombre,
                                              ),
                                              onPressed: () =>
                                                  _createRiego(cultivo),
                                              splashRadius: 20,
                                              padding: const EdgeInsets.all(8),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ), // espacio entre botones
                                          // Segundo botón
                                          // Segundo botón (ahora para eliminar cultivo)
                                          Container(
                                            decoration: BoxDecoration(
                                              color: colors.onPrimary,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.redAccent,
                                              ),
                                              tooltip:
                                                  loc.eliminar, // O usa loc.eliminarCultivo si agregas la clave en l10n
                                              onPressed: () => _deleteCultivo(
                                                cultivo,
                                              ), // <-- CAMBIO: Llama al nuevo método
                                              splashRadius: 20,
                                              padding: const EdgeInsets.all(8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  // Mostrar las programaciones de riego
                                  if (cultivo.programaciones.isNotEmpty)
                                    ...cultivo.programaciones.map((
                                      programacion,
                                    ) {
                                      return Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 10,
                                        ),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: colors.tertiary,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: colors
                                                .onPrimary, // Color del borde
                                            width: 1, // Grosor del borde
                                          ),
                                        ),
                                        child: ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: Text(
                                            loc.riegoALas(
                                              programacion.inicio ?? 'N/A',
                                            ),
                                            style: TextStyle(
                                              color: colors.onSecondary,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16,
                                            ),
                                          ),
                                          subtitle: Text(
                                            loc.duracionMinutos(
                                              programacion.duracion
                                                      ?.toString() ??
                                                  'N/A',
                                            ),
                                            style: TextStyle(
                                              color: colors.onSecondary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          trailing: Wrap(
                                            spacing: 8,
                                            children: [
                                              // Botón de editar riego
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: colors.onPrimary,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: IconButton(
                                                  icon: Icon(
                                                    Icons.edit,
                                                    color: colors.secondary,
                                                  ),
                                                  tooltip: loc.editar,
                                                  onPressed: () =>
                                                      _editRiegoMenu(
                                                        programacion,
                                                        cultivo,
                                                      ),
                                                  splashRadius: 20,
                                                  padding: const EdgeInsets.all(
                                                    8,
                                                  ),
                                                ),
                                              ),
                                              // Botón de eliminar riego
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: colors.onPrimary,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: IconButton(
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Colors.redAccent,
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
                                    // Mensaje si no hay riegos
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      child: Text(
                                        loc.noRiegos,
                                        style: TextStyle(
                                          color: colors.onSecondary,
                                        ),
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
      ),
    );
  }
}
