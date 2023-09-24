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

class BdL10n {
  BdL10n();

  static BdL10n? _current;

  static BdL10n get current {
    assert(_current != null,
        'No instance of BdL10n was loaded. Try to initialize the BdL10n delegate before accessing BdL10n.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<BdL10n> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = BdL10n();
      BdL10n._current = instance;

      return instance;
    });
  }

  static BdL10n of(BuildContext context) {
    final instance = BdL10n.maybeOf(context);
    assert(instance != null,
        'No instance of BdL10n present in the widget tree. Did you add BdL10n.delegate in localizationsDelegates?');
    return instance!;
  }

  static BdL10n? maybeOf(BuildContext context) {
    return Localizations.of<BdL10n>(context, BdL10n);
  }

  /// `Birdart`
  String get appName {
    return Intl.message(
      'Birdart',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `birdart`
  String get lowercaseAppName {
    return Intl.message(
      'birdart',
      name: 'lowercaseAppName',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get bottomHome {
    return Intl.message(
      'Home',
      name: 'bottomHome',
      desc: '',
      args: [],
    );
  }

  /// `Checklists`
  String get bottomRecords {
    return Intl.message(
      'Checklists',
      name: 'bottomRecords',
      desc: '',
      args: [],
    );
  }

  /// `Explore`
  String get bottomExplore {
    return Intl.message(
      'Explore',
      name: 'bottomExplore',
      desc: '',
      args: [],
    );
  }

  /// `My Birdart`
  String get bottomMyBirdart {
    return Intl.message(
      'My Birdart',
      name: 'bottomMyBirdart',
      desc: '',
      args: [],
    );
  }

  /// `Database error`
  String get databaseError {
    return Intl.message(
      'Database error',
      name: 'databaseError',
      desc: '',
      args: [],
    );
  }

  /// `Network error`
  String get networkError {
    return Intl.message(
      'Network error',
      name: 'networkError',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get homeDate {
    return Intl.message(
      'Date',
      name: 'homeDate',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get homeTime {
    return Intl.message(
      'Time',
      name: 'homeTime',
      desc: '',
      args: [],
    );
  }

  /// `Track enabled`
  String get homeEnableTrack {
    return Intl.message(
      'Track enabled',
      name: 'homeEnableTrack',
      desc: '',
      args: [],
    );
  }

  /// `Track disabled`
  String get homeDisableTrack {
    return Intl.message(
      'Track disabled',
      name: 'homeDisableTrack',
      desc: '',
      args: [],
    );
  }

  /// `Go birding`
  String get homeBirding {
    return Intl.message(
      'Go birding',
      name: 'homeBirding',
      desc: '',
      args: [],
    );
  }

  /// `Start checklist`
  String get homeOldRecord {
    return Intl.message(
      'Start checklist',
      name: 'homeOldRecord',
      desc: '',
      args: [],
    );
  }

  /// `Join a team`
  String get homeJoinTeam {
    return Intl.message(
      'Join a team',
      name: 'homeJoinTeam',
      desc: '',
      args: [],
    );
  }

  /// `My checklists`
  String get recordsTitle {
    return Intl.message(
      'My checklists',
      name: 'recordsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Explore nearby`
  String get exploreTitle {
    return Intl.message(
      'Explore nearby',
      name: 'exploreTitle',
      desc: '',
      args: [],
    );
  }

  /// `Tianditu`
  String get mapNameTDT {
    return Intl.message(
      'Tianditu',
      name: 'mapNameTDT',
      desc: '',
      args: [],
    );
  }

  /// `OSM`
  String get mapNameOSM {
    return Intl.message(
      'OSM',
      name: 'mapNameOSM',
      desc: '',
      args: [],
    );
  }

  /// `Satellite`
  String get mapNameSat {
    return Intl.message(
      'Satellite',
      name: 'mapNameSat',
      desc: '',
      args: [],
    );
  }

  /// `Latitude: {lat}\nLongitude: {lon}\nAltitude: {alt}`
  String mapCoordinate(String lat, String lon, String alt) {
    return Intl.message(
      'Latitude: $lat\nLongitude: $lon\nAltitude: $alt',
      name: 'mapCoordinate',
      desc: '',
      args: [lat, lon, alt],
    );
  }

  /// `My Birdart`
  String get myTitle {
    return Intl.message(
      'My Birdart',
      name: 'myTitle',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get myRegister {
    return Intl.message(
      'Register',
      name: 'myRegister',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get myLogin {
    return Intl.message(
      'Login',
      name: 'myLogin',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get mySettings {
    return Intl.message(
      'Settings',
      name: 'mySettings',
      desc: '',
      args: [],
    );
  }

  /// `Data center`
  String get myData {
    return Intl.message(
      'Data center',
      name: 'myData',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get myAbout {
    return Intl.message(
      'About',
      name: 'myAbout',
      desc: '',
      args: [],
    );
  }

  /// `Open source`
  String get myOpenSource {
    return Intl.message(
      'Open source',
      name: 'myOpenSource',
      desc: '',
      args: [],
    );
  }

  /// `Auto upload tracks under WiFi`
  String get settingsWifiSyncTrack {
    return Intl.message(
      'Auto upload tracks under WiFi',
      name: 'settingsWifiSyncTrack',
      desc: '',
      args: [],
    );
  }

  /// `Auto upload images under WiFi`
  String get settingsWifiSyncImage {
    return Intl.message(
      'Auto upload images under WiFi',
      name: 'settingsWifiSyncImage',
      desc: '',
      args: [],
    );
  }

  /// `Track time interval`
  String get settingsTrackInterval {
    return Intl.message(
      'Track time interval',
      name: 'settingsTrackInterval',
      desc: '',
      args: [],
    );
  }

  /// `Select time interval`
  String get settingsSelectTrackInterval {
    return Intl.message(
      'Select time interval',
      name: 'settingsSelectTrackInterval',
      desc: '',
      args: [],
    );
  }

  /// `{second} seconds`
  String settingsTrackIntervalSeconds(Object second) {
    return Intl.message(
      '$second seconds',
      name: 'settingsTrackIntervalSeconds',
      desc: '',
      args: [second],
    );
  }

  /// `Login success.`
  String get loginSuccess {
    return Intl.message(
      'Login success.',
      name: 'loginSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Login Failed. `
  String get loginFailed {
    return Intl.message(
      'Login Failed. ',
      name: 'loginFailed',
      desc: '',
      args: [],
    );
  }

  /// `Network error.`
  String get loginNetworkError {
    return Intl.message(
      'Network error.',
      name: 'loginNetworkError',
      desc: '',
      args: [],
    );
  }

  /// `Application internal error.`
  String get loginAppError {
    return Intl.message(
      'Application internal error.',
      name: 'loginAppError',
      desc: '',
      args: [],
    );
  }

  /// `Register success, please check your email inbox.`
  String get registerSuccess {
    return Intl.message(
      'Register success, please check your email inbox.',
      name: 'registerSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Register failed.`
  String get registerFailed {
    return Intl.message(
      'Register failed.',
      name: 'registerFailed',
      desc: '',
      args: [],
    );
  }

  /// `Username should not be empty.`
  String get registerNameNotEmpty {
    return Intl.message(
      'Username should not be empty.',
      name: 'registerNameNotEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Username should contains at least 6 characters.`
  String get registerNameLength {
    return Intl.message(
      'Username should contains at least 6 characters.',
      name: 'registerNameLength',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get loginFormUsername {
    return Intl.message(
      'Username',
      name: 'loginFormUsername',
      desc: '',
      args: [],
    );
  }

  /// `Please choose your favour username.`
  String get loginFormUsernameHint {
    return Intl.message(
      'Please choose your favour username.',
      name: 'loginFormUsernameHint',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get loginFormEmail {
    return Intl.message(
      'Email',
      name: 'loginFormEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address.`
  String get loginFormEmailHint {
    return Intl.message(
      'Please enter a valid email address.',
      name: 'loginFormEmailHint',
      desc: '',
      args: [],
    );
  }

  /// `Email address not right.`
  String get loginFormEmailFormat {
    return Intl.message(
      'Email address not right.',
      name: 'loginFormEmailFormat',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get loginFormPassword {
    return Intl.message(
      'Password',
      name: 'loginFormPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a complex password.`
  String get loginFormPasswordHint {
    return Intl.message(
      'Please enter a complex password.',
      name: 'loginFormPasswordHint',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password`
  String get loginFormConfirmPassword {
    return Intl.message(
      'Confirm password',
      name: 'loginFormConfirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm your password.`
  String get loginFormConfirmPasswordHint {
    return Intl.message(
      'Please confirm your password.',
      name: 'loginFormConfirmPasswordHint',
      desc: '',
      args: [],
    );
  }

  /// `Password should not be empty`
  String get loginFormPasswordNotEmpty {
    return Intl.message(
      'Password should not be empty',
      name: 'loginFormPasswordNotEmpty',
      desc: '',
      args: [],
    );
  }

  /// `The password should contain at least 8 characters, and only letters, numbers, and special symbols.`
  String get loginFormPasswordFormat {
    return Intl.message(
      'The password should contain at least 8 characters, and only letters, numbers, and special symbols.',
      name: 'loginFormPasswordFormat',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match.`
  String get loginFormConfirmNotMatch {
    return Intl.message(
      'Passwords do not match.',
      name: 'loginFormConfirmNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `VerCode`
  String get loginFormVer {
    return Intl.message(
      'VerCode',
      name: 'loginFormVer',
      desc: '',
      args: [],
    );
  }

  /// `Verification code, case insensitive.`
  String get loginFormVerHint {
    return Intl.message(
      'Verification code, case insensitive.',
      name: 'loginFormVerHint',
      desc: '',
      args: [],
    );
  }

  /// `VerCode should not be empty.`
  String get loginFormVerFormat {
    return Intl.message(
      'VerCode should not be empty.',
      name: 'loginFormVerFormat',
      desc: '',
      args: [],
    );
  }

  /// `Have no account? Register now.`
  String get registerHint {
    return Intl.message(
      'Have no account? Register now.',
      name: 'registerHint',
      desc: '',
      args: [],
    );
  }

  /// `Have an account? Login immediately.`
  String get loginHint {
    return Intl.message(
      'Have an account? Login immediately.',
      name: 'loginHint',
      desc: '',
      args: [],
    );
  }

  /// `Search birds`
  String get newListSearch {
    return Intl.message(
      'Search birds',
      name: 'newListSearch',
      desc: '',
      args: [],
    );
  }

  /// `Track disabled`
  String get newListTrackDisabled {
    return Intl.message(
      'Track disabled',
      name: 'newListTrackDisabled',
      desc: '',
      args: [],
    );
  }

  /// `Auto select`
  String get newListAutoHotspot {
    return Intl.message(
      'Auto select',
      name: 'newListAutoHotspot',
      desc: '',
      args: [],
    );
  }

  /// `{hour} h, {minute} min`
  String newListTrackDuration(Object hour, Object minute) {
    return Intl.message(
      '$hour h, $minute min',
      name: 'newListTrackDuration',
      desc: '',
      args: [hour, minute],
    );
  }

  /// `User profile`
  String get profileTitle {
    return Intl.message(
      'User profile',
      name: 'profileTitle',
      desc: '',
      args: [],
    );
  }

  /// `Edit Avatar`
  String get profileChangeAvatar {
    return Intl.message(
      'Edit Avatar',
      name: 'profileChangeAvatar',
      desc: '',
      args: [],
    );
  }

  /// `Pick avatar from storage`
  String get profileChooseAvatar {
    return Intl.message(
      'Pick avatar from storage',
      name: 'profileChooseAvatar',
      desc: '',
      args: [],
    );
  }

  /// `Edit username`
  String get profileEditUserName {
    return Intl.message(
      'Edit username',
      name: 'profileEditUserName',
      desc: '',
      args: [],
    );
  }

  /// `Enter username`
  String get profileEnterUserName {
    return Intl.message(
      'Enter username',
      name: 'profileEnterUserName',
      desc: '',
      args: [],
    );
  }

  /// `User ID`
  String get profileUserID {
    return Intl.message(
      'User ID',
      name: 'profileUserID',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get profileEmail {
    return Intl.message(
      'Email',
      name: 'profileEmail',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get profileLogout {
    return Intl.message(
      'Log out',
      name: 'profileLogout',
      desc: '',
      args: [],
    );
  }

  /// `Location services are disabled. Please enable the services`
  String get locationDisabled {
    return Intl.message(
      'Location services are disabled. Please enable the services',
      name: 'locationDisabled',
      desc: '',
      args: [],
    );
  }

  /// `Location permissions are permanently denied, we cannot request permissions`
  String get locationPermissionDenied {
    return Intl.message(
      'Location permissions are permanently denied, we cannot request permissions',
      name: 'locationPermissionDenied',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<BdL10n> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<BdL10n> load(Locale locale) => BdL10n.load(locale);
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
