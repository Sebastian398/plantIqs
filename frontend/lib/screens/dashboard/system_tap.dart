import 'package:flutter/material.dart';
import 'package:plantiq/services/api_service.dart'; // Servicio para interactuar con la API
import 'package:plantiq/generated/l10n.dart'; // Traducciones / localización

/// Widget principal que representa la pantalla de registro de cultivos y riegos
class SystemTap extends StatefulWidget {
  const SystemTap({super.key});

  @override
  _SystemTapState createState() => _SystemTapState();
}

/// Estado del widget SystemTap, donde se maneja toda la lógica
class _SystemTapState extends State<SystemTap> {
  // ===============================
  // CONTROLADORES DE TEXTO
  // ===============================

  /// Controlador para el campo "Nombre del cultivo"
  final TextEditingController nombreCultivoController = TextEditingController();

  /// Controlador para el campo "Tipo de cultivo"
  final TextEditingController tipoCultivoController = TextEditingController();

  /// Controlador para el campo "Duración del riego" (en minutos)
  final TextEditingController duracionRiegoController = TextEditingController();

  // ===============================
  // VARIABLES DE ESTADO
  // ===============================

  /// Cantidad de lotes seleccionados en el Dropdown
  int? numero_lotes;

  /// Cantidad de aspersores seleccionados en el Dropdown
  int? numero_aspersores;

  /// Hora de inicio del riego seleccionada
  TimeOfDay? inicio;

  // ===============================
  // MÉTODOS DEL CICLO DE VIDA
  // ===============================

  /// Liberar recursos al destruir el widget
  @override
  void dispose() {
    nombreCultivoController.dispose();
    tipoCultivoController.dispose();
    duracionRiegoController.dispose();
    super.dispose();
  }

  // ===============================
  // FUNCIONES PERSONALIZADAS
  // ===============================

  /// Función para seleccionar la hora de inicio del riego
  /// Muestra un TimePicker con colores personalizados y formato AM/PM
  Future<void> seleccionarHoraInicioRiego() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: inicio ?? TimeOfDay.now(),
      builder: (context, child) {
        // Obtener el esquema de colores actual del tema
        final colors = Theme.of(context).colorScheme;

        // Aplicar tema personalizado al TimePicker
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: colors.primary, // Color del header y botones OK
              onPrimary: colors.onPrimary, // Color del texto en el header
              surface: colors.tertiary, // Fondo de los números
              onSurface: colors.onSecondary, // Color de los números
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    colors.primary, // Color de botones "Cancelar" y "OK"
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    // Actualizar estado si se seleccionó una hora
    if (time != null) {
      setState(() {
        inicio = time;
      });
    }
  }

  /// Función para guardar los datos del cultivo y programar el riego
  Future<void> guardarDatos() async {
    final loc = AppLocalizations.of(context); // Obtener traducciones

    // Obtener valores de los campos
    String nombre = nombreCultivoController.text.trim();
    String tipo = tipoCultivoController.text.trim();
    String duracion = duracionRiegoController.text.trim();

    // Validar campos obligatorios
    if (nombre.isEmpty || tipo.isEmpty || inicio == null || duracion.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.msgCamposObligatorios)));
      return;
    }

    // Convertir duración a entero
    int? duracionRiego = int.tryParse(duracion);
    if (duracionRiego == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.msgDuracionEntero)));
      return;
    }

    try {
      // Crear cultivo mediante la API
      final cultivo = await ApiService.crearCultivo(
        nombre: nombre,
        tipo: tipo,
        numero_lotes: numero_lotes,
        numero_aspersores: numero_aspersores,
      );

      // Formatear hora para enviar a la API (HH:mm)
      final horaFormateada =
          '${inicio!.hour.toString().padLeft(2, '0')}:${inicio!.minute.toString().padLeft(2, '0')}';

      // Crear riego para el cultivo
      final exitoRiego = await ApiService.createRiego(
        cultivo.id,
        horaFormateada,
        duracionRiego,
      );

      // Mostrar mensaje según el resultado
      if (exitoRiego) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(loc.msgCultivoGuardado)));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(loc.msgErrorRiego)));
      }

      // Limpiar formulario
      nombreCultivoController.clear();
      tipoCultivoController.clear();
      duracionRiegoController.clear();
      setState(() {
        numero_lotes = null;
        numero_aspersores = null;
        inicio = null;
      });
    } catch (e) {
      // Mostrar error si falla la llamada a la API
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.msgErrorGuardar(e.toString()))),
      );
    }
  }

  // ===============================
  // WIDGET PRINCIPAL
  // ===============================

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme; // Esquema de colores del tema
    final loc = AppLocalizations.of(context); // Traducciones / localización

    return Scaffold(
      backgroundColor: colors.secondary, // Color de fondo de la pantalla
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ===============================
              // BLOQUE 1: Registro de datos del cultivo
              // ===============================
              Container(
                width: 800, // Ancho fijo del contenedor
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.primary, // Color de fondo
                  borderRadius: BorderRadius.circular(12), // Bordes redondeados
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título
                    Text(
                      loc.tituloRegistroCultivos,
                      style: TextStyle(fontSize: 16, color: colors.onPrimary),
                    ),
                    const SizedBox(height: 16),

                    // Campo nombre del cultivo
                    TextField(
                      controller: nombreCultivoController,
                      style: TextStyle(
                        color: colors.onSecondary,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                      cursorColor: colors.onSecondary,
                      decoration: InputDecoration(
                        labelText: loc.labelNombreCultivo,
                        labelStyle: TextStyle(
                          color: colors.onSecondary,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                        prefixIcon: Icon(
                          Icons.grass,
                          color: colors.onSecondary,
                          size: 20,
                        ),
                        filled: true,
                        fillColor: colors.tertiary,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: colors.onPrimary),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: colors.secondary,
                            width: 1,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Campo tipo de cultivo
                    TextField(
                      controller: tipoCultivoController,
                      style: TextStyle(
                        color: colors.onSecondary,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                      cursorColor: colors.onSecondary,
                      decoration: InputDecoration(
                        labelText: loc.labelTipoCultivo,
                        labelStyle: TextStyle(
                          color: colors.onSecondary,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                        prefixIcon: Icon(
                          Icons.eco,
                          color: colors.onSecondary,
                          size: 20,
                        ),
                        filled: true,
                        fillColor: colors.tertiary,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: colors.onPrimary),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: colors.secondary,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ===============================
              // BLOQUE 2: Registro de lotes y riego
              // ===============================
              Container(
                width: 800,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título del bloque
                    Text(
                      loc.tituloRegistroLotes,
                      style: TextStyle(fontSize: 16, color: colors.onPrimary),
                    ),

                    const SizedBox(height: 16),

                    // Dropdown: Número de lotes
                    DropdownButtonFormField<int>(
                      style: TextStyle(
                        color: colors.onSecondary,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        labelText: loc.labelNumeroLotes,
                        labelStyle: TextStyle(
                          color: colors.onSecondary,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                        prefixIcon: Icon(
                          Icons.numbers,
                          color: colors.onSecondary,
                          size: 20,
                        ),
                        filled: true,
                        fillColor: colors.tertiary,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: colors.onPrimary),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: colors.secondary,
                            width: 1,
                          ),
                        ),
                      ),
                      dropdownColor: colors.tertiary,
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
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: colors.onPrimary,
                        size: 30,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Dropdown: Número de aspersores
                    DropdownButtonFormField<int>(
                      style: TextStyle(
                        color: colors.onSecondary,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        labelText: loc.labelNumeroAspersores,
                        labelStyle: TextStyle(
                          color: colors.onSecondary,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                        prefixIcon: Icon(
                          Icons.numbers,
                          color: colors.onSecondary,
                          size: 20,
                        ),
                        filled: true,
                        fillColor: colors.tertiary,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: colors.onPrimary),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: colors.secondary,
                            width: 1,
                          ),
                        ),
                      ),
                      dropdownColor: colors.tertiary,
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
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: colors.onPrimary,
                        size: 30,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // TextField: Hora de inicio del riego
                    TextField(
                      readOnly: true,
                      onTap: seleccionarHoraInicioRiego,
                      style: TextStyle(
                        color: colors.onSecondary,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                      cursorColor: colors.tertiary,
                      decoration: InputDecoration(
                        labelText: inicio == null
                            ? loc.labelSeleccionaRiego
                            : loc.labelInicioRiego(
                                inicio!.format(context), // Formato AM/PM
                              ),
                        labelStyle: TextStyle(
                          color: colors.onSecondary,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                        prefixIcon: Icon(
                          Icons.access_time,
                          color: colors.onSecondary,
                          size: 20,
                        ),
                        filled: true,
                        fillColor: colors.tertiary,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: colors.onPrimary),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: colors.secondary,
                            width: 1,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // TextField: Duración del riego
                    TextField(
                      controller: duracionRiegoController,
                      style: TextStyle(
                        color: colors.onSecondary,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                      cursorColor: colors.onSecondary,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: loc.labelDuracionRiego,
                        labelStyle: TextStyle(
                          color: colors.onSecondary,
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                        ),
                        prefixIcon: Icon(
                          Icons.timer,
                          color: colors.onSecondary,
                          size: 20,
                        ),
                        filled: true,
                        fillColor: colors.tertiary,
                        // Línea blanca cuando está deshabilitado o sin foco
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: colors.onPrimary,
                            width: 1,
                          ),
                        ),
                        // Línea cuando está enfocado
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: colors.secondary,
                            width: 1,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Botón para guardar los datos
                    Center(
                      child: ElevatedButton(
                        onPressed: guardarDatos,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.onSurface,
                          foregroundColor: colors.onPrimary,
                          minimumSize: const Size(200, 40), // ancho fijo
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                        child: Text(
                          loc.botonGuardar,
                          style: TextStyle(
                            color: colors.onPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
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
      ),
    );
  }
}
