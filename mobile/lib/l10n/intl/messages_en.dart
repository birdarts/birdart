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
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "recordsTitle": MessageLookupByLibrary.simpleMessage("My checklists")
      };
}
