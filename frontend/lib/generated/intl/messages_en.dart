// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(minutos) => "Duration: ${minutos} minutes";

  static String m1(cultivo) => "Edit irrigation for ${cultivo}";

  static String m2(cultivo) => "Delete irrigation for ${cultivo}?";

  static String m3(error) => "Error loading farm data: ${error}";

  static String m4(error) => "Error: ${error}";

  static String m5(error) => "Error: ${error}";

  static String m6(error) => "Error saving: ${error}";

  static String m7(error) => "Error uploading photo: ${error}";

  static String m8(error) => "Error loading user data: ${error}";

  static String m9(field) => "Please enter ${field}";

  static String m10(hora) => "Start time: ${hora}";

  static String m11(name) => "Irrigation ${name}";

  static String m12(hora) => "Irrigation start: ${hora}";

  static String m13(nombre) =>
      "Are you sure you want to delete the crop \"${nombre}\"? This will also remove its associated irrigation schedules.";

  static String m14(error) => "Error saving: ${error}";

  static String m15(cultivo) => "New irrigation in ${cultivo}";

  static String m16(hora) => "Irrigation at ${hora}";

  static String m17(field) => "Please enter ${field}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "activate": MessageLookupByLibrary.simpleMessage("Activate"),
    "activateSystemForPlot": MessageLookupByLibrary.simpleMessage(
      "Activating system for plot:",
    ),
    "alreadyHaveAccount": MessageLookupByLibrary.simpleMessage(
      "Already have an account? Log in ",
    ),
    "appTitle": MessageLookupByLibrary.simpleMessage("Home Page"),
    "bars": MessageLookupByLibrary.simpleMessage("Bars"),
    "botonGuardar": MessageLookupByLibrary.simpleMessage("Save"),
    "cancelar": MessageLookupByLibrary.simpleMessage("Cancel"),
    "changeLanguagePrompt": MessageLookupByLibrary.simpleMessage(
      "Switch language ",
    ),
    "confirmPasswordEmptyError": MessageLookupByLibrary.simpleMessage(
      "Please re-enter your password",
    ),
    "confirmPasswordErrorEmpty": MessageLookupByLibrary.simpleMessage(
      "Please confirm your password",
    ),
    "confirmPasswordErrorMismatch": MessageLookupByLibrary.simpleMessage(
      "Passwords do not match",
    ),
    "confirmPasswordLabel": MessageLookupByLibrary.simpleMessage(
      "Confirm your password",
    ),
    "confirmPasswordLabelPas": MessageLookupByLibrary.simpleMessage(
      "Confirm password",
    ),
    "confirmarEliminar": MessageLookupByLibrary.simpleMessage(
      "Confirm deletion",
    ),
    "description": MessageLookupByLibrary.simpleMessage(
      "Keep your crops always healthy with our smart irrigation system.",
    ),
    "duracion": MessageLookupByLibrary.simpleMessage("Duration (minutes)"),
    "duracionMinutos": m0,
    "editar": MessageLookupByLibrary.simpleMessage("Edit"),
    "editarRiego": m1,
    "eliminar": MessageLookupByLibrary.simpleMessage("Delete"),
    "eliminarPregunta": m2,
    "emailErrorEmpty": MessageLookupByLibrary.simpleMessage(
      "Please enter your email",
    ),
    "emailErrorEmptyRe": MessageLookupByLibrary.simpleMessage(
      "Please enter your email",
    ),
    "emailErrorInvalid": MessageLookupByLibrary.simpleMessage("Invalid email"),
    "emailErrorInvalidRe": MessageLookupByLibrary.simpleMessage(
      "Invalid email",
    ),
    "emailInvalid": MessageLookupByLibrary.simpleMessage("Invalid email"),
    "emailLabel": MessageLookupByLibrary.simpleMessage("Email"),
    "emailLabelRe": MessageLookupByLibrary.simpleMessage("Email"),
    "emailLabelRes": MessageLookupByLibrary.simpleMessage("Email"),
    "emailRequired": MessageLookupByLibrary.simpleMessage(
      "Please enter your email",
    ),
    "errorConnection": MessageLookupByLibrary.simpleMessage(
      "Connection error with server.",
    ),
    "errorDefault": MessageLookupByLibrary.simpleMessage("Login failed."),
    "errorDialogTitle": MessageLookupByLibrary.simpleMessage("Login error"),
    "errorEliminar": MessageLookupByLibrary.simpleMessage(
      "Error deleting irrigation",
    ),
    "errorFinca": m3,
    "errorGenerico": m4,
    "errorGenericoSnack": m5,
    "errorGuardar": m6,
    "errorGuardarRiego": MessageLookupByLibrary.simpleMessage(
      "Error saving irrigation",
    ),
    "errorNoToken": MessageLookupByLibrary.simpleMessage(
      "No access token received.",
    ),
    "errorSubirFoto": m7,
    "errorUsuario": m8,
    "farm_address": MessageLookupByLibrary.simpleMessage(
      "Farm or Property Address",
    ),
    "farm_edit_title": MessageLookupByLibrary.simpleMessage("Edit Farm Data"),
    "farm_field_required": m9,
    "farm_info": MessageLookupByLibrary.simpleMessage(
      "Information or Description",
    ),
    "farm_name": MessageLookupByLibrary.simpleMessage("Farm or Property Name"),
    "farm_save": MessageLookupByLibrary.simpleMessage("Save"),
    "farm_save_error": MessageLookupByLibrary.simpleMessage(
      "Error saving farm data",
    ),
    "farm_save_success": MessageLookupByLibrary.simpleMessage(
      "Farm data saved",
    ),
    "firstNameError": MessageLookupByLibrary.simpleMessage(
      "Please enter your first name",
    ),
    "firstNameLabel": MessageLookupByLibrary.simpleMessage("First name"),
    "forgotPasswordPrompt": MessageLookupByLibrary.simpleMessage(
      "I forgot my password ",
    ),
    "guardar": MessageLookupByLibrary.simpleMessage("Save"),
    "guardarCambios": MessageLookupByLibrary.simpleMessage("Save changes"),
    "here": MessageLookupByLibrary.simpleMessage("here."),
    "herePas": MessageLookupByLibrary.simpleMessage("here."),
    "hereRes": MessageLookupByLibrary.simpleMessage("here."),
    "horaInicio": m10,
    "humidity": MessageLookupByLibrary.simpleMessage("Humidity"),
    "infoFinca": MessageLookupByLibrary.simpleMessage("Farm information"),
    "inicioRiego": MessageLookupByLibrary.simpleMessage("Start (HH:mm:ss)"),
    "irrigation": m11,
    "labelApagarBomba": MessageLookupByLibrary.simpleMessage("Turn off pump"),
    "labelApellido": MessageLookupByLibrary.simpleMessage("Last Name"),
    "labelCorreo": MessageLookupByLibrary.simpleMessage("Email Address"),
    "labelDireccionFinca": MessageLookupByLibrary.simpleMessage(
      "Farm address:",
    ),
    "labelDuracionRiego": MessageLookupByLibrary.simpleMessage(
      "Irrigation duration",
    ),
    "labelEncenderBomba": MessageLookupByLibrary.simpleMessage("Turn on pump"),
    "labelInicioRiego": m12,
    "labelNombre": MessageLookupByLibrary.simpleMessage("First Name"),
    "labelNombreCultivo": MessageLookupByLibrary.simpleMessage("Crop Name"),
    "labelNombreFinca": MessageLookupByLibrary.simpleMessage(
      "Farm or property name:",
    ),
    "labelNumeroAspersores": MessageLookupByLibrary.simpleMessage(
      "Number of sprinklers per lot",
    ),
    "labelNumeroLotes": MessageLookupByLibrary.simpleMessage("Number of lots"),
    "labelPresentacionFinca": MessageLookupByLibrary.simpleMessage(
      "Information or presentation:",
    ),
    "labelSeleccionaRiego": MessageLookupByLibrary.simpleMessage(
      "Select irrigation start time",
    ),
    "labelTelefono": MessageLookupByLibrary.simpleMessage("Contact Phone"),
    "labelTipoCultivo": MessageLookupByLibrary.simpleMessage("Crop Type"),
    "labelUbicacionFinca": MessageLookupByLibrary.simpleMessage(
      "Farm or property location",
    ),
    "lastNameError": MessageLookupByLibrary.simpleMessage(
      "Please enter your last name",
    ),
    "lastNameLabel": MessageLookupByLibrary.simpleMessage("Last name"),
    "lines": MessageLookupByLibrary.simpleMessage("Lines"),
    "listadoRiegos": MessageLookupByLibrary.simpleMessage(
      "Irrigation list by crop",
    ),
    "loginButton": MessageLookupByLibrary.simpleMessage("Login"),
    "loginHere": MessageLookupByLibrary.simpleMessage("here."),
    "loginText": MessageLookupByLibrary.simpleMessage("Login "),
    "loginTextPas": MessageLookupByLibrary.simpleMessage("Login "),
    "loginTitle": MessageLookupByLibrary.simpleMessage("Login"),
    "menuIrrigations": MessageLookupByLibrary.simpleMessage("Irrigations"),
    "menuProfile": MessageLookupByLibrary.simpleMessage("Profile"),
    "menuSettings": MessageLookupByLibrary.simpleMessage("Settings"),
    "menuStats": MessageLookupByLibrary.simpleMessage("Statistics"),
    "menuSystem": MessageLookupByLibrary.simpleMessage("System"),
    "menuTooltip": MessageLookupByLibrary.simpleMessage("Open menu"),
    "msgBombaApagada": MessageLookupByLibrary.simpleMessage("Pump turned off"),
    "msgBombaEncendida": MessageLookupByLibrary.simpleMessage("Pump turned on"),
    "msgCamposObligatorios": MessageLookupByLibrary.simpleMessage(
      "Please complete all required fields",
    ),
    "msgCamposObligatoriosPe": MessageLookupByLibrary.simpleMessage(
      "All fields are required",
    ),
    "msgCultivoEliminado": MessageLookupByLibrary.simpleMessage(
      "Crop deleted successfully",
    ),
    "msgCultivoGuardado": MessageLookupByLibrary.simpleMessage(
      "Crop and irrigation schedule saved successfully ✅",
    ),
    "msgDatosInvalidos": MessageLookupByLibrary.simpleMessage("Invalid data"),
    "msgDuracionEntero": MessageLookupByLibrary.simpleMessage(
      "Irrigation duration must be an integer",
    ),
    "msgDuracionInvalida": MessageLookupByLibrary.simpleMessage(
      "Enter a valid duration",
    ),
    "msgEliminarCultivo": m13,
    "msgErrorGuardar": m14,
    "msgErrorRiego": MessageLookupByLibrary.simpleMessage(
      "Error saving irrigation schedule",
    ),
    "msgFincaGuardada": MessageLookupByLibrary.simpleMessage(
      "Farm information saved successfully",
    ),
    "msgFotoPerfilOk": MessageLookupByLibrary.simpleMessage(
      "Profile photo updated successfully",
    ),
    "msgHoraRequerida": MessageLookupByLibrary.simpleMessage(
      "Please select a start time",
    ),
    "noCrops": MessageLookupByLibrary.simpleMessage("No plots available"),
    "noCultivos": MessageLookupByLibrary.simpleMessage("No crops available"),
    "noFinca": MessageLookupByLibrary.simpleMessage("No farm data found"),
    "noRiegos": MessageLookupByLibrary.simpleMessage("No irrigation scheduled"),
    "noUsuario": MessageLookupByLibrary.simpleMessage("No user data found"),
    "notRegistered": MessageLookupByLibrary.simpleMessage(
      "If you haven\'t registered yet, sign up ",
    ),
    "notRegisteredPas": MessageLookupByLibrary.simpleMessage(
      "If you haven\'t registered yet ",
    ),
    "notRegisteredRes": MessageLookupByLibrary.simpleMessage(
      "If you haven\'t registered yet, sign up ",
    ),
    "nuevoRiego": m15,
    "passwordEmptyError": MessageLookupByLibrary.simpleMessage(
      "Please enter your password",
    ),
    "passwordErrorEmpty": MessageLookupByLibrary.simpleMessage(
      "Please enter your password",
    ),
    "passwordErrorEmptyRe": MessageLookupByLibrary.simpleMessage(
      "Please enter your password",
    ),
    "passwordErrorShort": MessageLookupByLibrary.simpleMessage(
      "Minimum 6 characters",
    ),
    "passwordErrorShortRe": MessageLookupByLibrary.simpleMessage(
      "Minimum 6 characters",
    ),
    "passwordLabel": MessageLookupByLibrary.simpleMessage("Password"),
    "passwordLabelPas": MessageLookupByLibrary.simpleMessage("Password"),
    "passwordLabelRe": MessageLookupByLibrary.simpleMessage("Password"),
    "passwordTooShortError": MessageLookupByLibrary.simpleMessage(
      "Minimum 6 characters",
    ),
    "ph": MessageLookupByLibrary.simpleMessage("pH"),
    "phoneErrorEmpty": MessageLookupByLibrary.simpleMessage(
      "Please enter a contact phone number",
    ),
    "phoneErrorInvalid": MessageLookupByLibrary.simpleMessage(
      "Invalid phone number",
    ),
    "phoneLabel": MessageLookupByLibrary.simpleMessage("Contact phone"),
    "radial": MessageLookupByLibrary.simpleMessage("Radial"),
    "registerButton": MessageLookupByLibrary.simpleMessage("Register"),
    "registerErrorServer": MessageLookupByLibrary.simpleMessage(
      "Unknown server error",
    ),
    "registerErrorUnknown": MessageLookupByLibrary.simpleMessage(
      "Unknown error.",
    ),
    "registerHere": MessageLookupByLibrary.simpleMessage("here."),
    "registerPrompt": MessageLookupByLibrary.simpleMessage(
      "If you haven\'t registered yet ",
    ),
    "registerTitle": MessageLookupByLibrary.simpleMessage("User Registration"),
    "resetButton": MessageLookupByLibrary.simpleMessage("Reset"),
    "resetError": MessageLookupByLibrary.simpleMessage(
      "Error sending email, please try again",
    ),
    "resetPasswordTitle": MessageLookupByLibrary.simpleMessage(
      "Reset Password",
    ),
    "resetPasswordTitlePas": MessageLookupByLibrary.simpleMessage(
      "Reset password",
    ),
    "riegoALas": m16,
    "riegoActualizado": MessageLookupByLibrary.simpleMessage(
      "Irrigation updated",
    ),
    "riegoEliminado": MessageLookupByLibrary.simpleMessage(
      "Irrigation deleted successfully",
    ),
    "seleccionarHora": MessageLookupByLibrary.simpleMessage(
      "Select start time",
    ),
    "selectCrop": MessageLookupByLibrary.simpleMessage("Select a crop"),
    "selectPlotInstruction": MessageLookupByLibrary.simpleMessage(
      "Select a plot to see its charts",
    ),
    "sendEmail": MessageLookupByLibrary.simpleMessage("Send Email"),
    "settings_auth": MessageLookupByLibrary.simpleMessage("Authentication"),
    "settings_auth_options": MessageLookupByLibrary.simpleMessage(
      "Authentication Options",
    ),
    "settings_cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "settings_change_password": MessageLookupByLibrary.simpleMessage(
      "Change Password",
    ),
    "settings_farm_data": MessageLookupByLibrary.simpleMessage("Farm Data"),
    "settings_language": MessageLookupByLibrary.simpleMessage("Language"),
    "settings_light_mode": MessageLookupByLibrary.simpleMessage("Light Mode"),
    "settings_logout": MessageLookupByLibrary.simpleMessage("Logout"),
    "settings_logout_error": MessageLookupByLibrary.simpleMessage(
      "Error logging out",
    ),
    "settings_title": MessageLookupByLibrary.simpleMessage("Settings"),
    "settings_user_data": MessageLookupByLibrary.simpleMessage("User Data"),
    "sinNombre": MessageLookupByLibrary.simpleMessage("No name"),
    "slogan": MessageLookupByLibrary.simpleMessage(
      "Precise water, productive land.",
    ),
    "startButton": MessageLookupByLibrary.simpleMessage("Start"),
    "temperature": MessageLookupByLibrary.simpleMessage("Temperature"),
    "tituloRegistroCultivos": MessageLookupByLibrary.simpleMessage(
      "Crop Registration",
    ),
    "tituloRegistroLotes": MessageLookupByLibrary.simpleMessage(
      "Crop Lot Registration",
    ),
    "unnamed": MessageLookupByLibrary.simpleMessage("Unnamed"),
    "user_address": MessageLookupByLibrary.simpleMessage("Address"),
    "user_edit_title": MessageLookupByLibrary.simpleMessage("Edit User Data"),
    "user_email": MessageLookupByLibrary.simpleMessage("Email"),
    "user_email_invalid": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid email",
    ),
    "user_field_required": m17,
    "user_first_name": MessageLookupByLibrary.simpleMessage("First Name"),
    "user_last_name": MessageLookupByLibrary.simpleMessage("Last Name"),
    "user_phone": MessageLookupByLibrary.simpleMessage("Contact Phone"),
    "user_role": MessageLookupByLibrary.simpleMessage("Role"),
    "user_save": MessageLookupByLibrary.simpleMessage("Save"),
    "user_save_success": MessageLookupByLibrary.simpleMessage(
      "Data saved successfully",
    ),
  };
}
