import 'package:flutter/material.dart';
import 'package:plantiq/services/api_service.dart';
import 'package:plantiq/generated/l10n.dart';

class SystemTap extends StatefulWidget {
  const SystemTap({super.key});

  @override
  _SystemTapState createState() => _SystemTapState();
}

class _SystemTapState extends State<SystemTap> {
  final TextEditingController nombreCultivoController = TextEditingController();
  final TextEditingController tipoCultivoController = TextEditingController();
  final TextEditingController duracionRiegoController = TextEditingController();

  int? numero_lotes;
  int? numero_aspersores;

  TimeOfDay? inicio;

  @override
  void dispose() {
    nombreCultivoController.dispose();
    tipoCultivoController.dispose();
    duracionRiegoController.dispose();
    super.dispose();
  }

  Future<void> seleccionarHoraInicioRiego() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: inicio ?? TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        inicio = time;
      });
    }
  }

  Future<void> guardarDatos() async {
    final loc = AppLocalizations.of(context);
    String nombre = nombreCultivoController.text.trim();
    String tipo = tipoCultivoController.text.trim();
    String duracion = duracionRiegoController.text.trim();

    if (nombre.isEmpty || tipo.isEmpty || inicio == null || duracion.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.msgCamposObligatorios)));
      return;
    }

    int? duracionRiego = int.tryParse(duracion);
    if (duracionRiego == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.msgDuracionEntero)));
      return;
    }

    try {
      final cultivo = await ApiService.crearCultivo(
        nombre: nombre,
        tipo: tipo,
        numero_lotes: numero_lotes,
        numero_aspersores: numero_aspersores,
      );

      final horaFormateada =
          '${inicio!.hour.toString().padLeft(2, '0')}:${inicio!.minute.toString().padLeft(2, '0')}';

      final exitoRiego = await ApiService.createRiego(
        cultivo.id,
        horaFormateada,
        duracionRiego,
      );

      if (exitoRiego) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(loc.msgCultivoGuardado)));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(loc.msgErrorRiego)));
      }

      // limpiar formulario
      nombreCultivoController.clear();
      tipoCultivoController.clear();
      duracionRiegoController.clear();
      setState(() {
        numero_lotes = null;
        numero_aspersores = null;
        inicio = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.msgErrorGuardar(e.toString()))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: colors.surface,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 124, right: 124),
              child: SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Bloque cultivo
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                loc.tituloRegistroCultivos,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 17),
                              TextField(
                                controller: nombreCultivoController,
                                style: TextStyle(color: colors.tertiary),
                                cursorColor: colors.tertiary,
                                decoration: InputDecoration(
                                  labelText: loc.labelNombreCultivo,
                                  prefixIcon: const Icon(Icons.grass),
                                ),
                              ),
                              const SizedBox(height: 13),
                              TextField(
                                controller: tipoCultivoController,
                                style: TextStyle(color: colors.tertiary),
                                cursorColor: colors.tertiary,
                                decoration: InputDecoration(
                                  labelText: loc.labelTipoCultivo,
                                  prefixIcon: const Icon(Icons.eco),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Bloque lotes/riego
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                loc.tituloRegistroLotes,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 17),
                              DropdownButtonFormField<int>(
                                decoration: InputDecoration(
                                  labelText: loc.labelNumeroLotes,
                                  prefixIcon: const Icon(Icons.numbers),
                                ),
                                dropdownColor: colors.surface,
                                style: TextStyle(color: colors.tertiary),
                                items: List.generate(10, (index) => index + 1)
                                    .map(
                                      (e) => DropdownMenuItem<int>(
                                        value: e,
                                        child: Text(e.toString()),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    numero_lotes = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              DropdownButtonFormField<int>(
                                decoration: InputDecoration(
                                  labelText: loc.labelNumeroAspersores,
                                  prefixIcon: const Icon(Icons.numbers),
                                ),
                                dropdownColor: colors.surface,
                                style: TextStyle(color: colors.tertiary),
                                items: List.generate(10, (index) => index + 1)
                                    .map(
                                      (e) => DropdownMenuItem<int>(
                                        value: e,
                                        child: Text(e.toString()),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    numero_aspersores = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                readOnly: true,
                                onTap: seleccionarHoraInicioRiego,
                                style: TextStyle(color: colors.tertiary),
                                cursorColor: colors.tertiary,
                                decoration: InputDecoration(
                                  labelText: inicio == null
                                      ? loc.labelSeleccionaRiego
                                      : loc.labelInicioRiego(
                                          inicio!.format(context),
                                        ),
                                  prefixIcon: Icon(
                                    Icons.access_time,
                                    color: colors.tertiary,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: colors.tertiary,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: colors.primary,
                                      width: 2,
                                    ),
                                  ),
                                  labelStyle: TextStyle(color: colors.tertiary),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: duracionRiegoController,
                                style: TextStyle(color: colors.tertiary),
                                cursorColor: colors.tertiary,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: loc.labelDuracionRiego,
                                  prefixIcon: const Icon(Icons.timer),
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: guardarDatos,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colors.primary,
                                  foregroundColor: colors.onPrimary,
                                  minimumSize: const Size(double.infinity, 40),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 3,
                                ),
                                child: Text(
                                  loc.botonGuardar,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
