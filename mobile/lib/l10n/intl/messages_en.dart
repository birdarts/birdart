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

  static String m0(lat, lon, alt) =>
      "Latitude: ${lat}\nLongitude: ${lon}\nAltitude: ${alt}";

  static String m1(second) => "${second} seconds";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "appName": MessageLookupByLibrary.simpleMessage("Birdart"),
        "bottomExplore": MessageLookupByLibrary.simpleMessage("Explore"),
        "bottomHome": MessageLookupByLibrary.simpleMessage("Home"),
        "bottomMyBirdart": MessageLookupByLibrary.simpleMessage("My Birdart"),
        "bottomRecords": MessageLookupByLibrary.simpleMessage("Checklists"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "databaseError": MessageLookupByLibrary.simpleMessage("Database error"),
        "exploreTitle": MessageLookupByLibrary.simpleMessage("Explore nearby"),
        "homeBirding": MessageLookupByLibrary.simpleMessage("Go birding"),
        "homeDate": MessageLookupByLibrary.simpleMessage("Date"),
        "homeDisableTrack":
            MessageLookupByLibrary.simpleMessage("Track disabled"),
        "homeEnableTrack":
            MessageLookupByLibrary.simpleMessage("Track enabled"),
        "homeJoinTeam": MessageLookupByLibrary.simpleMessage("Join a team"),
        "homeOldRecord":
            MessageLookupByLibrary.simpleMessage("Start checklist"),
        "homeTime": MessageLookupByLibrary.simpleMessage("Time"),
        "loginAppError":
            MessageLookupByLibrary.simpleMessage("Application internal error."),
        "loginFailed": MessageLookupByLibrary.simpleMessage("Login Failed. "),
        "loginFormConfirmNotMatch":
            MessageLookupByLibrary.simpleMessage("Passwords do not match."),
        "loginFormConfirmPassword":
            MessageLookupByLibrary.simpleMessage("Confirm password"),
        "loginFormConfirmPasswordHint": MessageLookupByLibrary.simpleMessage(
            "Please confirm your password."),
        "loginFormEmail": MessageLookupByLibrary.simpleMessage("Email"),
        "loginFormEmailFormat":
            MessageLookupByLibrary.simpleMessage("Email address not right."),
        "loginFormEmailHint": MessageLookupByLibrary.simpleMessage(
            "Please enter a valid email address."),
        "loginFormPassword": MessageLookupByLibrary.simpleMessage("Password"),
        "loginFormPasswordFormat": MessageLookupByLibrary.simpleMessage(
            "The password should contain at least 8 characters, and only letters, numbers, and special symbols."),
        "loginFormPasswordHint": MessageLookupByLibrary.simpleMessage(
            "Please enter a complex password."),
        "loginFormPasswordNotEmpty": MessageLookupByLibrary.simpleMessage(
            "Password should not be empty"),
        "loginFormUsername": MessageLookupByLibrary.simpleMessage("Username"),
        "loginFormUsernameHint": MessageLookupByLibrary.simpleMessage(
            "Please choose your favour username."),
        "loginFormVer": MessageLookupByLibrary.simpleMessage("VerCode"),
        "loginFormVerFormat": MessageLookupByLibrary.simpleMessage(
            "VerCode should not be empty."),
        "loginFormVerHint": MessageLookupByLibrary.simpleMessage(
            "Verification code, case insensitive."),
        "loginHint": MessageLookupByLibrary.simpleMessage(
            "Have an account? Login immediately."),
        "loginNetworkError":
            MessageLookupByLibrary.simpleMessage("Network error."),
        "loginSuccess": MessageLookupByLibrary.simpleMessage("Login success."),
        "lowercaseAppName": MessageLookupByLibrary.simpleMessage("birdart"),
        "mapCoordinate": m0,
        "mapNameOSM": MessageLookupByLibrary.simpleMessage("OSM"),
        "mapNameSat": MessageLookupByLibrary.simpleMessage("Satellite"),
        "mapNameTDT": MessageLookupByLibrary.simpleMessage("Tianditu"),
        "myAbout": MessageLookupByLibrary.simpleMessage("About"),
        "myData": MessageLookupByLibrary.simpleMessage("Data center"),
        "myLogin": MessageLookupByLibrary.simpleMessage("Login"),
        "myOpenSource": MessageLookupByLibrary.simpleMessage("Open source"),
        "myRegister": MessageLookupByLibrary.simpleMessage("Register"),
        "mySettings": MessageLookupByLibrary.simpleMessage("Settings"),
        "myTitle": MessageLookupByLibrary.simpleMessage("My Birdart"),
        "networkError": MessageLookupByLibrary.simpleMessage("Network error"),
        "newListSearch": MessageLookupByLibrary.simpleMessage("Search birds"),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "profileChangeAvatar":
            MessageLookupByLibrary.simpleMessage("Edit Avatar"),
        "profileChooseAvatar":
            MessageLookupByLibrary.simpleMessage("Pick avatar from storage"),
        "profileEditUserName":
            MessageLookupByLibrary.simpleMessage("Edit username"),
        "profileEmail": MessageLookupByLibrary.simpleMessage("Email"),
        "profileEnterUserName":
            MessageLookupByLibrary.simpleMessage("Enter username"),
        "profileLogout": MessageLookupByLibrary.simpleMessage("Log out"),
        "profileTitle": MessageLookupByLibrary.simpleMessage("User profile"),
        "profileUserID": MessageLookupByLibrary.simpleMessage("User ID"),
        "recordsTitle": MessageLookupByLibrary.simpleMessage("My checklists"),
        "registerFailed":
            MessageLookupByLibrary.simpleMessage("Register failed."),
        "registerHint": MessageLookupByLibrary.simpleMessage(
            "Have no account? Register now."),
        "registerNameLength": MessageLookupByLibrary.simpleMessage(
            "Username should contains at least 6 characters."),
        "registerNameNotEmpty": MessageLookupByLibrary.simpleMessage(
            "Username should not be empty."),
        "registerSuccess": MessageLookupByLibrary.simpleMessage(
            "Register success, please check your email inbox."),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "settingsSelectTrackInterval":
            MessageLookupByLibrary.simpleMessage("Select time interval"),
        "settingsTrackInterval":
            MessageLookupByLibrary.simpleMessage("Track time interval"),
        "settingsTrackIntervalSeconds": m1,
        "settingsWifiSyncImage": MessageLookupByLibrary.simpleMessage(
            "Auto upload images under WiFi"),
        "settingsWifiSyncTrack": MessageLookupByLibrary.simpleMessage(
            "Auto upload tracks under WiFi")
      };
}
