// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'es';

  static String m0(minutos) => "Duración: ${minutos} minutos";

  static String m1(cultivo) => "Editar riego para ${cultivo}";

  static String m2(cultivo) => "¿Eliminar riego para ${cultivo}?";

  static String m3(error) => "Error al cargar datos de la finca: ${error}";

  static String m4(error) => "Error: ${error}";

  static String m5(error) => "Error: ${error}";

  static String m6(error) => "Error al cargar datos del usuario: ${error}";

  static String m7(field) => "Por favor ingresa ${field}";

  static String m8(hora) => "Hora inicio: ${hora}";

  static String m9(name) => "Riego ${name}";

  static String m10(hora) => "Inicio riego: ${hora}";

  static String m11(error) => "Error al guardar: ${error}";

  static String m12(cultivo) => "Nuevo riego en ${cultivo}";

  static String m13(hora) => "Riego a las ${hora}";

  static String m14(field) => "Por favor ingresa ${field}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "activate": MessageLookupByLibrary.simpleMessage("Activar"),
    "activateSystemForPlot": MessageLookupByLibrary.simpleMessage(
      "Activando sistema para lote:",
    ),
    "alreadyHaveAccount": MessageLookupByLibrary.simpleMessage(
      "¿Ya tienes cuenta? Inicia sesión ",
    ),
    "appTitle": MessageLookupByLibrary.simpleMessage("Página de Inicio"),
    "bars": MessageLookupByLibrary.simpleMessage("Barras"),
    "botonGuardar": MessageLookupByLibrary.simpleMessage("Guardar"),
    "cancelar": MessageLookupByLibrary.simpleMessage("Cancelar"),
    "changeLanguagePrompt": MessageLookupByLibrary.simpleMessage(
      "Cambiar idioma ",
    ),
    "confirmPasswordEmptyError": MessageLookupByLibrary.simpleMessage(
      "Por favor ingresa de nuevo tu contraseña",
    ),
    "confirmPasswordErrorEmpty": MessageLookupByLibrary.simpleMessage(
      "Por favor confirma la contraseña",
    ),
    "confirmPasswordErrorMismatch": MessageLookupByLibrary.simpleMessage(
      "Las contraseñas no coinciden",
    ),
    "confirmPasswordLabel": MessageLookupByLibrary.simpleMessage(
      "Confirma tu contraseña",
    ),
    "confirmPasswordLabelPas": MessageLookupByLibrary.simpleMessage(
      "Confirmación contraseña",
    ),
    "confirmarEliminar": MessageLookupByLibrary.simpleMessage(
      "Confirmar eliminación",
    ),
    "description": MessageLookupByLibrary.simpleMessage(
      "Tus cultivos siempre saludables con nuestro sistema de riego inteligente.",
    ),
    "duracion": MessageLookupByLibrary.simpleMessage("Duración (minutos)"),
    "duracionMinutos": m0,
    "editar": MessageLookupByLibrary.simpleMessage("Editar"),
    "editarRiego": m1,
    "eliminar": MessageLookupByLibrary.simpleMessage("Eliminar"),
    "eliminarPregunta": m2,
    "emailErrorEmpty": MessageLookupByLibrary.simpleMessage(
      "Por favor ingresa tu correo",
    ),
    "emailErrorEmptyRe": MessageLookupByLibrary.simpleMessage(
      "Por favor ingresa tu correo",
    ),
    "emailErrorInvalid": MessageLookupByLibrary.simpleMessage(
      "Correo inválido",
    ),
    "emailErrorInvalidRe": MessageLookupByLibrary.simpleMessage(
      "Correo inválido",
    ),
    "emailInvalid": MessageLookupByLibrary.simpleMessage("Correo inválido"),
    "emailLabel": MessageLookupByLibrary.simpleMessage("Correo electrónico"),
    "emailLabelRe": MessageLookupByLibrary.simpleMessage("Correo electrónico"),
    "emailLabelRes": MessageLookupByLibrary.simpleMessage("Correo electrónico"),
    "emailRequired": MessageLookupByLibrary.simpleMessage(
      "Por favor ingresa tu correo",
    ),
    "errorConnection": MessageLookupByLibrary.simpleMessage(
      "Error de conexión con el servidor.",
    ),
    "errorDefault": MessageLookupByLibrary.simpleMessage(
      "Error al iniciar sesión.",
    ),
    "errorDialogTitle": MessageLookupByLibrary.simpleMessage(
      "Error de inicio de sesión",
    ),
    "errorEliminar": MessageLookupByLibrary.simpleMessage(
      "Error al eliminar el riego",
    ),
    "errorFinca": m3,
    "errorGenerico": m4,
    "errorGenericoSnack": m5,
    "errorGuardarRiego": MessageLookupByLibrary.simpleMessage(
      "Error al guardar el riego",
    ),
    "errorNoToken": MessageLookupByLibrary.simpleMessage(
      "No se recibió token de acceso.",
    ),
    "errorUsuario": m6,
    "farm_address": MessageLookupByLibrary.simpleMessage(
      "Dirección de la finca o predio",
    ),
    "farm_edit_title": MessageLookupByLibrary.simpleMessage(
      "Editar Datos de la Finca",
    ),
    "farm_field_required": m7,
    "farm_info": MessageLookupByLibrary.simpleMessage(
      "Información o presentación",
    ),
    "farm_name": MessageLookupByLibrary.simpleMessage(
      "Nombre de la finca o predio",
    ),
    "farm_save": MessageLookupByLibrary.simpleMessage("Guardar"),
    "farm_save_error": MessageLookupByLibrary.simpleMessage(
      "Error al guardar los datos de la finca",
    ),
    "farm_save_success": MessageLookupByLibrary.simpleMessage(
      "Datos de la finca guardados",
    ),
    "firstNameError": MessageLookupByLibrary.simpleMessage(
      "Por favor ingresa tus nombres",
    ),
    "firstNameLabel": MessageLookupByLibrary.simpleMessage("Nombres"),
    "forgotPasswordPrompt": MessageLookupByLibrary.simpleMessage(
      "Olvidé mi contraseña ",
    ),
    "guardar": MessageLookupByLibrary.simpleMessage("Guardar"),
    "guardarCambios": MessageLookupByLibrary.simpleMessage("Guardar cambios"),
    "here": MessageLookupByLibrary.simpleMessage("aquí."),
    "herePas": MessageLookupByLibrary.simpleMessage("aquí."),
    "hereRes": MessageLookupByLibrary.simpleMessage("aquí."),
    "horaInicio": m8,
    "humidity": MessageLookupByLibrary.simpleMessage("Humedad"),
    "inicioRiego": MessageLookupByLibrary.simpleMessage("Inicio (HH:mm:ss)"),
    "irrigation": m9,
    "labelApellido": MessageLookupByLibrary.simpleMessage("Apellido"),
    "labelCorreo": MessageLookupByLibrary.simpleMessage("Correo Electrónico"),
    "labelDireccionFinca": MessageLookupByLibrary.simpleMessage(
      "Dirección de la finca:",
    ),
    "labelDuracionRiego": MessageLookupByLibrary.simpleMessage(
      "Duración de riego",
    ),
    "labelInicioRiego": m10,
    "labelNombre": MessageLookupByLibrary.simpleMessage("Nombre"),
    "labelNombreCultivo": MessageLookupByLibrary.simpleMessage(
      "Nombre Cultivo",
    ),
    "labelNombreFinca": MessageLookupByLibrary.simpleMessage(
      "Nombre de la finca o predio:",
    ),
    "labelNumeroAspersores": MessageLookupByLibrary.simpleMessage(
      "Número de aspersores por lote",
    ),
    "labelNumeroLotes": MessageLookupByLibrary.simpleMessage("Número de lotes"),
    "labelPresentacionFinca": MessageLookupByLibrary.simpleMessage(
      "Información o presentación:",
    ),
    "labelSeleccionaRiego": MessageLookupByLibrary.simpleMessage(
      "Selecciona inicio de riego",
    ),
    "labelTelefono": MessageLookupByLibrary.simpleMessage(
      "Teléfono de contacto",
    ),
    "labelTipoCultivo": MessageLookupByLibrary.simpleMessage("Tipo de cultivo"),
    "labelUbicacionFinca": MessageLookupByLibrary.simpleMessage(
      "Ubicación de la finca o predio",
    ),
    "lastNameError": MessageLookupByLibrary.simpleMessage(
      "Por favor ingresa tus apellidos",
    ),
    "lastNameLabel": MessageLookupByLibrary.simpleMessage("Apellidos"),
    "lines": MessageLookupByLibrary.simpleMessage("Líneas"),
    "listadoRiegos": MessageLookupByLibrary.simpleMessage(
      "Listado de Riegos por cultivo",
    ),
    "loginButton": MessageLookupByLibrary.simpleMessage("Iniciar sesión"),
    "loginHere": MessageLookupByLibrary.simpleMessage("aquí."),
    "loginText": MessageLookupByLibrary.simpleMessage("Inicio de sesión "),
    "loginTextPas": MessageLookupByLibrary.simpleMessage("Inicio de sesión "),
    "loginTitle": MessageLookupByLibrary.simpleMessage("Inicio de sesión"),
    "menuIrrigations": MessageLookupByLibrary.simpleMessage("Riegos"),
    "menuProfile": MessageLookupByLibrary.simpleMessage("Perfil"),
    "menuSettings": MessageLookupByLibrary.simpleMessage("Ajustes"),
    "menuStats": MessageLookupByLibrary.simpleMessage("Estadísticas"),
    "menuSystem": MessageLookupByLibrary.simpleMessage("Sistema"),
    "menuTooltip": MessageLookupByLibrary.simpleMessage("Abrir menú"),
    "msgCamposObligatorios": MessageLookupByLibrary.simpleMessage(
      "Por favor completa todos los campos obligatorios",
    ),
    "msgCultivoGuardado": MessageLookupByLibrary.simpleMessage(
      "Cultivo y programación de riego guardados correctamente ✅",
    ),
    "msgDatosInvalidos": MessageLookupByLibrary.simpleMessage(
      "Datos inválidos",
    ),
    "msgDuracionEntero": MessageLookupByLibrary.simpleMessage(
      "Duración de riego debe ser un número entero",
    ),
    "msgDuracionInvalida": MessageLookupByLibrary.simpleMessage(
      "Ingrese duración válida",
    ),
    "msgErrorGuardar": m11,
    "msgErrorRiego": MessageLookupByLibrary.simpleMessage(
      "Error al guardar programación de riego",
    ),
    "msgHoraRequerida": MessageLookupByLibrary.simpleMessage(
      "Seleccione la hora de inicio",
    ),
    "noCrops": MessageLookupByLibrary.simpleMessage("No hay lotes disponibles"),
    "noCultivos": MessageLookupByLibrary.simpleMessage(
      "No hay cultivos disponibles",
    ),
    "noFinca": MessageLookupByLibrary.simpleMessage(
      "No se encontraron datos de la finca",
    ),
    "noRiegos": MessageLookupByLibrary.simpleMessage(
      "No hay riegos programados",
    ),
    "noUsuario": MessageLookupByLibrary.simpleMessage(
      "No se encontraron datos del usuario",
    ),
    "notRegistered": MessageLookupByLibrary.simpleMessage(
      "Si no te has inscrito registrate ",
    ),
    "notRegisteredPas": MessageLookupByLibrary.simpleMessage(
      "Si no te has registrado ",
    ),
    "notRegisteredRes": MessageLookupByLibrary.simpleMessage(
      "Si no te has inscrito regístrate ",
    ),
    "nuevoRiego": m12,
    "passwordEmptyError": MessageLookupByLibrary.simpleMessage(
      "Por favor ingresa tu contraseña",
    ),
    "passwordErrorEmpty": MessageLookupByLibrary.simpleMessage(
      "Por favor ingresa tu contraseña",
    ),
    "passwordErrorEmptyRe": MessageLookupByLibrary.simpleMessage(
      "Por favor ingresa tu contraseña",
    ),
    "passwordErrorShort": MessageLookupByLibrary.simpleMessage(
      "Mínimo 6 caracteres",
    ),
    "passwordErrorShortRe": MessageLookupByLibrary.simpleMessage(
      "Mínimo 6 caracteres",
    ),
    "passwordLabel": MessageLookupByLibrary.simpleMessage("Contraseña"),
    "passwordLabelPas": MessageLookupByLibrary.simpleMessage("Contraseña"),
    "passwordLabelRe": MessageLookupByLibrary.simpleMessage("Contraseña"),
    "passwordTooShortError": MessageLookupByLibrary.simpleMessage(
      "Mínimo 6 caracteres",
    ),
    "ph": MessageLookupByLibrary.simpleMessage("pH"),
    "phoneErrorEmpty": MessageLookupByLibrary.simpleMessage(
      "Por favor ingresa un teléfono de contacto",
    ),
    "phoneErrorInvalid": MessageLookupByLibrary.simpleMessage(
      "Número de teléfono inválido",
    ),
    "phoneLabel": MessageLookupByLibrary.simpleMessage("Teléfono de contacto"),
    "radial": MessageLookupByLibrary.simpleMessage("Radial"),
    "registerButton": MessageLookupByLibrary.simpleMessage("Registrar"),
    "registerErrorServer": MessageLookupByLibrary.simpleMessage(
      "Error desconocido en el servidor",
    ),
    "registerErrorUnknown": MessageLookupByLibrary.simpleMessage(
      "Error desconocido.",
    ),
    "registerHere": MessageLookupByLibrary.simpleMessage("aquí."),
    "registerPrompt": MessageLookupByLibrary.simpleMessage(
      "Si no te has registrado ",
    ),
    "registerTitle": MessageLookupByLibrary.simpleMessage(
      "Registro de usuario",
    ),
    "resetButton": MessageLookupByLibrary.simpleMessage("Restablecer"),
    "resetError": MessageLookupByLibrary.simpleMessage(
      "Error enviando correo, intenta de nuevo",
    ),
    "resetPasswordTitle": MessageLookupByLibrary.simpleMessage(
      "Restablecer contraseña",
    ),
    "resetPasswordTitlePas": MessageLookupByLibrary.simpleMessage(
      "Restablecer contraseña",
    ),
    "riegoALas": m13,
    "riegoActualizado": MessageLookupByLibrary.simpleMessage(
      "Riego actualizado",
    ),
    "riegoEliminado": MessageLookupByLibrary.simpleMessage(
      "Riego eliminado exitosamente",
    ),
    "seleccionarHora": MessageLookupByLibrary.simpleMessage(
      "Selecciona hora de inicio",
    ),
    "selectCrop": MessageLookupByLibrary.simpleMessage("Seleccione un cultivo"),
    "selectPlotInstruction": MessageLookupByLibrary.simpleMessage(
      "Selecciona un lote para ver sus gráficas",
    ),
    "sendEmail": MessageLookupByLibrary.simpleMessage("Enviar Correo"),
    "settings_auth": MessageLookupByLibrary.simpleMessage("Autenticación"),
    "settings_auth_options": MessageLookupByLibrary.simpleMessage(
      "Opciones de Autenticación",
    ),
    "settings_cancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
    "settings_change_password": MessageLookupByLibrary.simpleMessage(
      "Cambiar Contraseña",
    ),
    "settings_farm_data": MessageLookupByLibrary.simpleMessage(
      "Datos de la Finca",
    ),
    "settings_light_mode": MessageLookupByLibrary.simpleMessage("Modo claro"),
    "settings_logout": MessageLookupByLibrary.simpleMessage("Cerrar Sesión"),
    "settings_logout_error": MessageLookupByLibrary.simpleMessage(
      "Error al cerrar sesión",
    ),
    "settings_title": MessageLookupByLibrary.simpleMessage("Ajustes"),
    "settings_user_data": MessageLookupByLibrary.simpleMessage(
      "Datos del Usuario",
    ),
    "sinNombre": MessageLookupByLibrary.simpleMessage("Sin nombre"),
    "slogan": MessageLookupByLibrary.simpleMessage(
      "Agua precisa, tierra productiva.",
    ),
    "startButton": MessageLookupByLibrary.simpleMessage("Comenzar"),
    "temperature": MessageLookupByLibrary.simpleMessage("Temperatura"),
    "tituloRegistroCultivos": MessageLookupByLibrary.simpleMessage(
      "Registro de Cultivos",
    ),
    "tituloRegistroLotes": MessageLookupByLibrary.simpleMessage(
      "Registro de lotes del cultivo",
    ),
    "unnamed": MessageLookupByLibrary.simpleMessage("Sin nombre"),
    "user_address": MessageLookupByLibrary.simpleMessage("Dirección"),
    "user_edit_title": MessageLookupByLibrary.simpleMessage(
      "Editar Datos del usuario",
    ),
    "user_email": MessageLookupByLibrary.simpleMessage("Correo Electrónico"),
    "user_email_invalid": MessageLookupByLibrary.simpleMessage(
      "Por favor ingresa un correo válido",
    ),
    "user_field_required": m14,
    "user_first_name": MessageLookupByLibrary.simpleMessage("Nombres"),
    "user_last_name": MessageLookupByLibrary.simpleMessage("Apellidos"),
    "user_phone": MessageLookupByLibrary.simpleMessage("Teléfono de contacto"),
    "user_role": MessageLookupByLibrary.simpleMessage("Rol"),
    "user_save": MessageLookupByLibrary.simpleMessage("Guardar"),
    "user_save_success": MessageLookupByLibrary.simpleMessage(
      "Datos guardados correctamente",
    ),
  };
}
