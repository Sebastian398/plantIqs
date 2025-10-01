// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class AppLocalizations {
  AppLocalizations();

  static AppLocalizations? _current;

  static AppLocalizations get current {
    assert(
      _current != null,
      'No instance of AppLocalizations was loaded. Try to initialize the AppLocalizations delegate before accessing AppLocalizations.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<AppLocalizations> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = AppLocalizations();
      AppLocalizations._current = instance;

      return instance;
    });
  }

  static AppLocalizations of(BuildContext context) {
    final instance = AppLocalizations.maybeOf(context);
    assert(
      instance != null,
      'No instance of AppLocalizations present in the widget tree. Did you add AppLocalizations.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static AppLocalizations? maybeOf(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// `Error loading user data: {error}`
  String errorUsuario(Object error) {
    return Intl.message(
      'Error loading user data: $error',
      name: 'errorUsuario',
      desc: '',
      args: [error],
    );
  }

  /// `No user data found`
  String get noUsuario {
    return Intl.message(
      'No user data found',
      name: 'noUsuario',
      desc: '',
      args: [],
    );
  }

  /// `Error loading farm data: {error}`
  String errorFinca(Object error) {
    return Intl.message(
      'Error loading farm data: $error',
      name: 'errorFinca',
      desc: '',
      args: [error],
    );
  }

  /// `No farm data found`
  String get noFinca {
    return Intl.message(
      'No farm data found',
      name: 'noFinca',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get labelNombre {
    return Intl.message('First Name', name: 'labelNombre', desc: '', args: []);
  }

  /// `Last Name`
  String get labelApellido {
    return Intl.message('Last Name', name: 'labelApellido', desc: '', args: []);
  }

  /// `Contact Phone`
  String get labelTelefono {
    return Intl.message(
      'Contact Phone',
      name: 'labelTelefono',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get labelCorreo {
    return Intl.message(
      'Email Address',
      name: 'labelCorreo',
      desc: '',
      args: [],
    );
  }

  /// `Farm or property name:`
  String get labelNombreFinca {
    return Intl.message(
      'Farm or property name:',
      name: 'labelNombreFinca',
      desc: '',
      args: [],
    );
  }

  /// `Farm address:`
  String get labelDireccionFinca {
    return Intl.message(
      'Farm address:',
      name: 'labelDireccionFinca',
      desc: '',
      args: [],
    );
  }

  /// `Information or presentation:`
  String get labelPresentacionFinca {
    return Intl.message(
      'Information or presentation:',
      name: 'labelPresentacionFinca',
      desc: '',
      args: [],
    );
  }

  /// `Farm or property location`
  String get labelUbicacionFinca {
    return Intl.message(
      'Farm or property location',
      name: 'labelUbicacionFinca',
      desc: '',
      args: [],
    );
  }

  /// `Farm information`
  String get infoFinca {
    return Intl.message(
      'Farm information',
      name: 'infoFinca',
      desc: '',
      args: [],
    );
  }

  /// `All fields are required`
  String get msgCamposObligatoriosPe {
    return Intl.message(
      'All fields are required',
      name: 'msgCamposObligatoriosPe',
      desc: '',
      args: [],
    );
  }

  /// `Farm information saved successfully`
  String get msgFincaGuardada {
    return Intl.message(
      'Farm information saved successfully',
      name: 'msgFincaGuardada',
      desc: '',
      args: [],
    );
  }

  /// `Profile photo updated successfully`
  String get msgFotoPerfilOk {
    return Intl.message(
      'Profile photo updated successfully',
      name: 'msgFotoPerfilOk',
      desc: '',
      args: [],
    );
  }

  /// `Error uploading photo: {error}`
  String errorSubirFoto(Object error) {
    return Intl.message(
      'Error uploading photo: $error',
      name: 'errorSubirFoto',
      desc: '',
      args: [error],
    );
  }

  /// `Error saving: {error}`
  String errorGuardar(Object error) {
    return Intl.message(
      'Error saving: $error',
      name: 'errorGuardar',
      desc: '',
      args: [error],
    );
  }

  /// `Please complete all required fields`
  String get msgCamposObligatorios {
    return Intl.message(
      'Please complete all required fields',
      name: 'msgCamposObligatorios',
      desc: '',
      args: [],
    );
  }

  /// `Irrigation duration must be an integer`
  String get msgDuracionEntero {
    return Intl.message(
      'Irrigation duration must be an integer',
      name: 'msgDuracionEntero',
      desc: '',
      args: [],
    );
  }

  /// `Crop and irrigation schedule saved successfully ✅`
  String get msgCultivoGuardado {
    return Intl.message(
      'Crop and irrigation schedule saved successfully ✅',
      name: 'msgCultivoGuardado',
      desc: '',
      args: [],
    );
  }

  /// `Error saving irrigation schedule`
  String get msgErrorRiego {
    return Intl.message(
      'Error saving irrigation schedule',
      name: 'msgErrorRiego',
      desc: '',
      args: [],
    );
  }

  /// `Error saving: {error}`
  String msgErrorGuardar(Object error) {
    return Intl.message(
      'Error saving: $error',
      name: 'msgErrorGuardar',
      desc: '',
      args: [error],
    );
  }

  /// `Crop Registration`
  String get tituloRegistroCultivos {
    return Intl.message(
      'Crop Registration',
      name: 'tituloRegistroCultivos',
      desc: '',
      args: [],
    );
  }

  /// `Crop Name`
  String get labelNombreCultivo {
    return Intl.message(
      'Crop Name',
      name: 'labelNombreCultivo',
      desc: '',
      args: [],
    );
  }

  /// `Crop Type`
  String get labelTipoCultivo {
    return Intl.message(
      'Crop Type',
      name: 'labelTipoCultivo',
      desc: '',
      args: [],
    );
  }

  /// `Crop Lot Registration`
  String get tituloRegistroLotes {
    return Intl.message(
      'Crop Lot Registration',
      name: 'tituloRegistroLotes',
      desc: '',
      args: [],
    );
  }

  /// `Number of lots`
  String get labelNumeroLotes {
    return Intl.message(
      'Number of lots',
      name: 'labelNumeroLotes',
      desc: '',
      args: [],
    );
  }

  /// `Number of sprinklers per lot`
  String get labelNumeroAspersores {
    return Intl.message(
      'Number of sprinklers per lot',
      name: 'labelNumeroAspersores',
      desc: '',
      args: [],
    );
  }

  /// `Select irrigation start time`
  String get labelSeleccionaRiego {
    return Intl.message(
      'Select irrigation start time',
      name: 'labelSeleccionaRiego',
      desc: '',
      args: [],
    );
  }

  /// `Irrigation start: {hora}`
  String labelInicioRiego(Object hora) {
    return Intl.message(
      'Irrigation start: $hora',
      name: 'labelInicioRiego',
      desc: '',
      args: [hora],
    );
  }

  /// `Irrigation duration`
  String get labelDuracionRiego {
    return Intl.message(
      'Irrigation duration',
      name: 'labelDuracionRiego',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get botonGuardar {
    return Intl.message('Save', name: 'botonGuardar', desc: '', args: []);
  }

  /// `Are you sure you want to delete the crop "{nombre}"? This will also remove its associated irrigation schedules.`
  String msgEliminarCultivo(Object nombre) {
    return Intl.message(
      'Are you sure you want to delete the crop "$nombre"? This will also remove its associated irrigation schedules.',
      name: 'msgEliminarCultivo',
      desc: '',
      args: [nombre],
    );
  }

  /// `Crop deleted successfully`
  String get msgCultivoEliminado {
    return Intl.message(
      'Crop deleted successfully',
      name: 'msgCultivoEliminado',
      desc: '',
      args: [],
    );
  }

  /// `Irrigation list by crop`
  String get listadoRiegos {
    return Intl.message(
      'Irrigation list by crop',
      name: 'listadoRiegos',
      desc: '',
      args: [],
    );
  }

  /// `Error: {error}`
  String errorGenerico(Object error) {
    return Intl.message(
      'Error: $error',
      name: 'errorGenerico',
      desc: '',
      args: [error],
    );
  }

  /// `No crops available`
  String get noCultivos {
    return Intl.message(
      'No crops available',
      name: 'noCultivos',
      desc: '',
      args: [],
    );
  }

  /// `New irrigation in {cultivo}`
  String nuevoRiego(Object cultivo) {
    return Intl.message(
      'New irrigation in $cultivo',
      name: 'nuevoRiego',
      desc: '',
      args: [cultivo],
    );
  }

  /// `Select start time`
  String get seleccionarHora {
    return Intl.message(
      'Select start time',
      name: 'seleccionarHora',
      desc: '',
      args: [],
    );
  }

  /// `Start time: {hora}`
  String horaInicio(Object hora) {
    return Intl.message(
      'Start time: $hora',
      name: 'horaInicio',
      desc: '',
      args: [hora],
    );
  }

  /// `Duration (minutes)`
  String get duracion {
    return Intl.message(
      'Duration (minutes)',
      name: 'duracion',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancelar {
    return Intl.message('Cancel', name: 'cancelar', desc: '', args: []);
  }

  /// `Save`
  String get guardar {
    return Intl.message('Save', name: 'guardar', desc: '', args: []);
  }

  /// `Please select a start time`
  String get msgHoraRequerida {
    return Intl.message(
      'Please select a start time',
      name: 'msgHoraRequerida',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid duration`
  String get msgDuracionInvalida {
    return Intl.message(
      'Enter a valid duration',
      name: 'msgDuracionInvalida',
      desc: '',
      args: [],
    );
  }

  /// `Error saving irrigation`
  String get errorGuardarRiego {
    return Intl.message(
      'Error saving irrigation',
      name: 'errorGuardarRiego',
      desc: '',
      args: [],
    );
  }

  /// `Edit irrigation for {cultivo}`
  String editarRiego(Object cultivo) {
    return Intl.message(
      'Edit irrigation for $cultivo',
      name: 'editarRiego',
      desc: '',
      args: [cultivo],
    );
  }

  /// `Start (HH:mm:ss)`
  String get inicioRiego {
    return Intl.message(
      'Start (HH:mm:ss)',
      name: 'inicioRiego',
      desc: '',
      args: [],
    );
  }

  /// `Invalid data`
  String get msgDatosInvalidos {
    return Intl.message(
      'Invalid data',
      name: 'msgDatosInvalidos',
      desc: '',
      args: [],
    );
  }

  /// `Irrigation updated`
  String get riegoActualizado {
    return Intl.message(
      'Irrigation updated',
      name: 'riegoActualizado',
      desc: '',
      args: [],
    );
  }

  /// `Error: {error}`
  String errorGenericoSnack(Object error) {
    return Intl.message(
      'Error: $error',
      name: 'errorGenericoSnack',
      desc: '',
      args: [error],
    );
  }

  /// `Save changes`
  String get guardarCambios {
    return Intl.message(
      'Save changes',
      name: 'guardarCambios',
      desc: '',
      args: [],
    );
  }

  /// `Confirm deletion`
  String get confirmarEliminar {
    return Intl.message(
      'Confirm deletion',
      name: 'confirmarEliminar',
      desc: '',
      args: [],
    );
  }

  /// `Delete irrigation for {cultivo}?`
  String eliminarPregunta(Object cultivo) {
    return Intl.message(
      'Delete irrigation for $cultivo?',
      name: 'eliminarPregunta',
      desc: '',
      args: [cultivo],
    );
  }

  /// `Delete`
  String get eliminar {
    return Intl.message('Delete', name: 'eliminar', desc: '', args: []);
  }

  /// `Irrigation deleted successfully`
  String get riegoEliminado {
    return Intl.message(
      'Irrigation deleted successfully',
      name: 'riegoEliminado',
      desc: '',
      args: [],
    );
  }

  /// `Error deleting irrigation`
  String get errorEliminar {
    return Intl.message(
      'Error deleting irrigation',
      name: 'errorEliminar',
      desc: '',
      args: [],
    );
  }

  /// `No name`
  String get sinNombre {
    return Intl.message('No name', name: 'sinNombre', desc: '', args: []);
  }

  /// `Irrigation at {hora}`
  String riegoALas(Object hora) {
    return Intl.message(
      'Irrigation at $hora',
      name: 'riegoALas',
      desc: '',
      args: [hora],
    );
  }

  /// `Duration: {minutos} minutes`
  String duracionMinutos(Object minutos) {
    return Intl.message(
      'Duration: $minutos minutes',
      name: 'duracionMinutos',
      desc: '',
      args: [minutos],
    );
  }

  /// `Edit`
  String get editar {
    return Intl.message('Edit', name: 'editar', desc: '', args: []);
  }

  /// `No irrigation scheduled`
  String get noRiegos {
    return Intl.message(
      'No irrigation scheduled',
      name: 'noRiegos',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings_title {
    return Intl.message('Settings', name: 'settings_title', desc: '', args: []);
  }

  /// `Language`
  String get settings_language {
    return Intl.message(
      'Language',
      name: 'settings_language',
      desc: '',
      args: [],
    );
  }

  /// `Light Mode`
  String get settings_light_mode {
    return Intl.message(
      'Light Mode',
      name: 'settings_light_mode',
      desc: '',
      args: [],
    );
  }

  /// `User Data`
  String get settings_user_data {
    return Intl.message(
      'User Data',
      name: 'settings_user_data',
      desc: '',
      args: [],
    );
  }

  /// `Farm Data`
  String get settings_farm_data {
    return Intl.message(
      'Farm Data',
      name: 'settings_farm_data',
      desc: '',
      args: [],
    );
  }

  /// `Authentication`
  String get settings_auth {
    return Intl.message(
      'Authentication',
      name: 'settings_auth',
      desc: '',
      args: [],
    );
  }

  /// `Authentication Options`
  String get settings_auth_options {
    return Intl.message(
      'Authentication Options',
      name: 'settings_auth_options',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get settings_change_password {
    return Intl.message(
      'Change Password',
      name: 'settings_change_password',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get settings_logout {
    return Intl.message('Logout', name: 'settings_logout', desc: '', args: []);
  }

  /// `Cancel`
  String get settings_cancel {
    return Intl.message('Cancel', name: 'settings_cancel', desc: '', args: []);
  }

  /// `Error logging out`
  String get settings_logout_error {
    return Intl.message(
      'Error logging out',
      name: 'settings_logout_error',
      desc: '',
      args: [],
    );
  }

  /// `Edit User Data`
  String get user_edit_title {
    return Intl.message(
      'Edit User Data',
      name: 'user_edit_title',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get user_first_name {
    return Intl.message(
      'First Name',
      name: 'user_first_name',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get user_last_name {
    return Intl.message(
      'Last Name',
      name: 'user_last_name',
      desc: '',
      args: [],
    );
  }

  /// `Contact Phone`
  String get user_phone {
    return Intl.message(
      'Contact Phone',
      name: 'user_phone',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get user_email {
    return Intl.message('Email', name: 'user_email', desc: '', args: []);
  }

  /// `Role`
  String get user_role {
    return Intl.message('Role', name: 'user_role', desc: '', args: []);
  }

  /// `Address`
  String get user_address {
    return Intl.message('Address', name: 'user_address', desc: '', args: []);
  }

  /// `Data saved successfully`
  String get user_save_success {
    return Intl.message(
      'Data saved successfully',
      name: 'user_save_success',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get user_save {
    return Intl.message('Save', name: 'user_save', desc: '', args: []);
  }

  /// `Please enter {field}`
  String user_field_required(Object field) {
    return Intl.message(
      'Please enter $field',
      name: 'user_field_required',
      desc: '',
      args: [field],
    );
  }

  /// `Please enter a valid email`
  String get user_email_invalid {
    return Intl.message(
      'Please enter a valid email',
      name: 'user_email_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Edit Farm Data`
  String get farm_edit_title {
    return Intl.message(
      'Edit Farm Data',
      name: 'farm_edit_title',
      desc: '',
      args: [],
    );
  }

  /// `Farm or Property Name`
  String get farm_name {
    return Intl.message(
      'Farm or Property Name',
      name: 'farm_name',
      desc: '',
      args: [],
    );
  }

  /// `Farm or Property Address`
  String get farm_address {
    return Intl.message(
      'Farm or Property Address',
      name: 'farm_address',
      desc: '',
      args: [],
    );
  }

  /// `Information or Description`
  String get farm_info {
    return Intl.message(
      'Information or Description',
      name: 'farm_info',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get farm_save {
    return Intl.message('Save', name: 'farm_save', desc: '', args: []);
  }

  /// `Farm data saved`
  String get farm_save_success {
    return Intl.message(
      'Farm data saved',
      name: 'farm_save_success',
      desc: '',
      args: [],
    );
  }

  /// `Error saving farm data`
  String get farm_save_error {
    return Intl.message(
      'Error saving farm data',
      name: 'farm_save_error',
      desc: '',
      args: [],
    );
  }

  /// `Please enter {field}`
  String farm_field_required(Object field) {
    return Intl.message(
      'Please enter $field',
      name: 'farm_field_required',
      desc: '',
      args: [field],
    );
  }

  /// `Select a crop`
  String get selectCrop {
    return Intl.message(
      'Select a crop',
      name: 'selectCrop',
      desc: '',
      args: [],
    );
  }

  /// `No plots available`
  String get noCrops {
    return Intl.message(
      'No plots available',
      name: 'noCrops',
      desc: '',
      args: [],
    );
  }

  /// `Select a plot to see its charts`
  String get selectPlotInstruction {
    return Intl.message(
      'Select a plot to see its charts',
      name: 'selectPlotInstruction',
      desc: '',
      args: [],
    );
  }

  /// `Lines`
  String get lines {
    return Intl.message('Lines', name: 'lines', desc: '', args: []);
  }

  /// `Bars`
  String get bars {
    return Intl.message('Bars', name: 'bars', desc: '', args: []);
  }

  /// `Radial`
  String get radial {
    return Intl.message('Radial', name: 'radial', desc: '', args: []);
  }

  /// `Activate`
  String get activate {
    return Intl.message('Activate', name: 'activate', desc: '', args: []);
  }

  /// `Activating system for plot:`
  String get activateSystemForPlot {
    return Intl.message(
      'Activating system for plot:',
      name: 'activateSystemForPlot',
      desc: '',
      args: [],
    );
  }

  /// `Irrigation {name}`
  String irrigation(Object name) {
    return Intl.message(
      'Irrigation $name',
      name: 'irrigation',
      desc: '',
      args: [name],
    );
  }

  /// `Unnamed`
  String get unnamed {
    return Intl.message('Unnamed', name: 'unnamed', desc: '', args: []);
  }

  /// `Humidity`
  String get humidity {
    return Intl.message('Humidity', name: 'humidity', desc: '', args: []);
  }

  /// `Temperature`
  String get temperature {
    return Intl.message('Temperature', name: 'temperature', desc: '', args: []);
  }

  /// `pH`
  String get ph {
    return Intl.message('pH', name: 'ph', desc: '', args: []);
  }

  /// `Pump turned on`
  String get msgBombaEncendida {
    return Intl.message(
      'Pump turned on',
      name: 'msgBombaEncendida',
      desc: '',
      args: [],
    );
  }

  /// `Pump turned off`
  String get msgBombaApagada {
    return Intl.message(
      'Pump turned off',
      name: 'msgBombaApagada',
      desc: '',
      args: [],
    );
  }

  /// `Turn off pump`
  String get labelApagarBomba {
    return Intl.message(
      'Turn off pump',
      name: 'labelApagarBomba',
      desc: '',
      args: [],
    );
  }

  /// `Turn on pump`
  String get labelEncenderBomba {
    return Intl.message(
      'Turn on pump',
      name: 'labelEncenderBomba',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get loginTitle {
    return Intl.message('Login', name: 'loginTitle', desc: '', args: []);
  }

  /// `Email`
  String get emailLabel {
    return Intl.message('Email', name: 'emailLabel', desc: '', args: []);
  }

  /// `Please enter your email`
  String get emailErrorEmpty {
    return Intl.message(
      'Please enter your email',
      name: 'emailErrorEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email`
  String get emailErrorInvalid {
    return Intl.message(
      'Invalid email',
      name: 'emailErrorInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get passwordLabel {
    return Intl.message('Password', name: 'passwordLabel', desc: '', args: []);
  }

  /// `Please enter your password`
  String get passwordErrorEmpty {
    return Intl.message(
      'Please enter your password',
      name: 'passwordErrorEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Minimum 6 characters`
  String get passwordErrorShort {
    return Intl.message(
      'Minimum 6 characters',
      name: 'passwordErrorShort',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get loginButton {
    return Intl.message('Login', name: 'loginButton', desc: '', args: []);
  }

  /// `If you haven't registered yet `
  String get registerPrompt {
    return Intl.message(
      'If you haven\'t registered yet ',
      name: 'registerPrompt',
      desc: '',
      args: [],
    );
  }

  /// `here.`
  String get registerHere {
    return Intl.message('here.', name: 'registerHere', desc: '', args: []);
  }

  /// `I forgot my password `
  String get forgotPasswordPrompt {
    return Intl.message(
      'I forgot my password ',
      name: 'forgotPasswordPrompt',
      desc: '',
      args: [],
    );
  }

  /// `Switch language `
  String get changeLanguagePrompt {
    return Intl.message(
      'Switch language ',
      name: 'changeLanguagePrompt',
      desc: '',
      args: [],
    );
  }

  /// `Login error`
  String get errorDialogTitle {
    return Intl.message(
      'Login error',
      name: 'errorDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `No access token received.`
  String get errorNoToken {
    return Intl.message(
      'No access token received.',
      name: 'errorNoToken',
      desc: '',
      args: [],
    );
  }

  /// `Login failed.`
  String get errorDefault {
    return Intl.message(
      'Login failed.',
      name: 'errorDefault',
      desc: '',
      args: [],
    );
  }

  /// `Connection error with server.`
  String get errorConnection {
    return Intl.message(
      'Connection error with server.',
      name: 'errorConnection',
      desc: '',
      args: [],
    );
  }

  /// `User Registration`
  String get registerTitle {
    return Intl.message(
      'User Registration',
      name: 'registerTitle',
      desc: '',
      args: [],
    );
  }

  /// `First name`
  String get firstNameLabel {
    return Intl.message(
      'First name',
      name: 'firstNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your first name`
  String get firstNameError {
    return Intl.message(
      'Please enter your first name',
      name: 'firstNameError',
      desc: '',
      args: [],
    );
  }

  /// `Last name`
  String get lastNameLabel {
    return Intl.message('Last name', name: 'lastNameLabel', desc: '', args: []);
  }

  /// `Please enter your last name`
  String get lastNameError {
    return Intl.message(
      'Please enter your last name',
      name: 'lastNameError',
      desc: '',
      args: [],
    );
  }

  /// `Contact phone`
  String get phoneLabel {
    return Intl.message(
      'Contact phone',
      name: 'phoneLabel',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a contact phone number`
  String get phoneErrorEmpty {
    return Intl.message(
      'Please enter a contact phone number',
      name: 'phoneErrorEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Invalid phone number`
  String get phoneErrorInvalid {
    return Intl.message(
      'Invalid phone number',
      name: 'phoneErrorInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get emailLabelRe {
    return Intl.message('Email', name: 'emailLabelRe', desc: '', args: []);
  }

  /// `Please enter your email`
  String get emailErrorEmptyRe {
    return Intl.message(
      'Please enter your email',
      name: 'emailErrorEmptyRe',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email`
  String get emailErrorInvalidRe {
    return Intl.message(
      'Invalid email',
      name: 'emailErrorInvalidRe',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get passwordLabelRe {
    return Intl.message(
      'Password',
      name: 'passwordLabelRe',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password`
  String get passwordErrorEmptyRe {
    return Intl.message(
      'Please enter your password',
      name: 'passwordErrorEmptyRe',
      desc: '',
      args: [],
    );
  }

  /// `Minimum 6 characters`
  String get passwordErrorShortRe {
    return Intl.message(
      'Minimum 6 characters',
      name: 'passwordErrorShortRe',
      desc: '',
      args: [],
    );
  }

  /// `Confirm your password`
  String get confirmPasswordLabel {
    return Intl.message(
      'Confirm your password',
      name: 'confirmPasswordLabel',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm your password`
  String get confirmPasswordErrorEmpty {
    return Intl.message(
      'Please confirm your password',
      name: 'confirmPasswordErrorEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get confirmPasswordErrorMismatch {
    return Intl.message(
      'Passwords do not match',
      name: 'confirmPasswordErrorMismatch',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get registerButton {
    return Intl.message('Register', name: 'registerButton', desc: '', args: []);
  }

  /// `Unknown error.`
  String get registerErrorUnknown {
    return Intl.message(
      'Unknown error.',
      name: 'registerErrorUnknown',
      desc: '',
      args: [],
    );
  }

  /// `Unknown server error`
  String get registerErrorServer {
    return Intl.message(
      'Unknown server error',
      name: 'registerErrorServer',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account? Log in `
  String get alreadyHaveAccount {
    return Intl.message(
      'Already have an account? Log in ',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `here.`
  String get loginHere {
    return Intl.message('here.', name: 'loginHere', desc: '', args: []);
  }

  /// `Home Page`
  String get appTitle {
    return Intl.message('Home Page', name: 'appTitle', desc: '', args: []);
  }

  /// `Precise water, productive land.`
  String get slogan {
    return Intl.message(
      'Precise water, productive land.',
      name: 'slogan',
      desc: '',
      args: [],
    );
  }

  /// `Keep your crops always healthy with our smart irrigation system.`
  String get description {
    return Intl.message(
      'Keep your crops always healthy with our smart irrigation system.',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get startButton {
    return Intl.message('Start', name: 'startButton', desc: '', args: []);
  }

  /// `If you haven't registered yet, sign up `
  String get notRegistered {
    return Intl.message(
      'If you haven\'t registered yet, sign up ',
      name: 'notRegistered',
      desc: '',
      args: [],
    );
  }

  /// `here.`
  String get here {
    return Intl.message('here.', name: 'here', desc: '', args: []);
  }

  /// `Reset Password`
  String get resetPasswordTitle {
    return Intl.message(
      'Reset Password',
      name: 'resetPasswordTitle',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get emailLabelRes {
    return Intl.message('Email', name: 'emailLabelRes', desc: '', args: []);
  }

  /// `Please enter your email`
  String get emailRequired {
    return Intl.message(
      'Please enter your email',
      name: 'emailRequired',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email`
  String get emailInvalid {
    return Intl.message(
      'Invalid email',
      name: 'emailInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Send Email`
  String get sendEmail {
    return Intl.message('Send Email', name: 'sendEmail', desc: '', args: []);
  }

  /// `Error sending email, please try again`
  String get resetError {
    return Intl.message(
      'Error sending email, please try again',
      name: 'resetError',
      desc: '',
      args: [],
    );
  }

  /// `If you haven't registered yet, sign up `
  String get notRegisteredRes {
    return Intl.message(
      'If you haven\'t registered yet, sign up ',
      name: 'notRegisteredRes',
      desc: '',
      args: [],
    );
  }

  /// `here.`
  String get hereRes {
    return Intl.message('here.', name: 'hereRes', desc: '', args: []);
  }

  /// `Login `
  String get loginText {
    return Intl.message('Login ', name: 'loginText', desc: '', args: []);
  }

  /// `Reset password`
  String get resetPasswordTitlePas {
    return Intl.message(
      'Reset password',
      name: 'resetPasswordTitlePas',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get passwordLabelPas {
    return Intl.message(
      'Password',
      name: 'passwordLabelPas',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password`
  String get confirmPasswordLabelPas {
    return Intl.message(
      'Confirm password',
      name: 'confirmPasswordLabelPas',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password`
  String get passwordEmptyError {
    return Intl.message(
      'Please enter your password',
      name: 'passwordEmptyError',
      desc: '',
      args: [],
    );
  }

  /// `Minimum 6 characters`
  String get passwordTooShortError {
    return Intl.message(
      'Minimum 6 characters',
      name: 'passwordTooShortError',
      desc: '',
      args: [],
    );
  }

  /// `Please re-enter your password`
  String get confirmPasswordEmptyError {
    return Intl.message(
      'Please re-enter your password',
      name: 'confirmPasswordEmptyError',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get resetButton {
    return Intl.message('Reset', name: 'resetButton', desc: '', args: []);
  }

  /// `If you haven't registered yet `
  String get notRegisteredPas {
    return Intl.message(
      'If you haven\'t registered yet ',
      name: 'notRegisteredPas',
      desc: '',
      args: [],
    );
  }

  /// `Login `
  String get loginTextPas {
    return Intl.message('Login ', name: 'loginTextPas', desc: '', args: []);
  }

  /// `here.`
  String get herePas {
    return Intl.message('here.', name: 'herePas', desc: '', args: []);
  }

  /// `Profile`
  String get menuProfile {
    return Intl.message('Profile', name: 'menuProfile', desc: '', args: []);
  }

  /// `Irrigations`
  String get menuIrrigations {
    return Intl.message(
      'Irrigations',
      name: 'menuIrrigations',
      desc: '',
      args: [],
    );
  }

  /// `Statistics`
  String get menuStats {
    return Intl.message('Statistics', name: 'menuStats', desc: '', args: []);
  }

  /// `System`
  String get menuSystem {
    return Intl.message('System', name: 'menuSystem', desc: '', args: []);
  }

  /// `Settings`
  String get menuSettings {
    return Intl.message('Settings', name: 'menuSettings', desc: '', args: []);
  }

  /// `Open menu`
  String get menuTooltip {
    return Intl.message('Open menu', name: 'menuTooltip', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
