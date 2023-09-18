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

  static String m0(month, day, year) => "${month} ${day}, ${year}";

  static String m1(lat, lon, alt) =>
      "Latitude: ${lat}\nLongitude: ${lon}\nAltitude: ${alt}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "bottomExplore": MessageLookupByLibrary.simpleMessage("Explore"),
        "bottomHome": MessageLookupByLibrary.simpleMessage("Home"),
        "bottomMyBirdart": MessageLookupByLibrary.simpleMessage("My Birdart"),
        "bottomRecords": MessageLookupByLibrary.simpleMessage("Records"),
        "homeBirding": MessageLookupByLibrary.simpleMessage("Let\'s birding"),
        "homeDate": MessageLookupByLibrary.simpleMessage("Date"),
        "homeDateFormat": m0,
        "homeEnableTrack": MessageLookupByLibrary.simpleMessage("Enable track"),
        "homeJoinTeam": MessageLookupByLibrary.simpleMessage("Join a team"),
        "homeTime": MessageLookupByLibrary.simpleMessage("Time"),
        "mapCoordinate": m1,
        "mapNameOSM": MessageLookupByLibrary.simpleMessage("OSM"),
        "mapNameSat": MessageLookupByLibrary.simpleMessage("Satellite"),
        "mapNameTDT": MessageLookupByLibrary.simpleMessage("Tianditu")
      };
}
