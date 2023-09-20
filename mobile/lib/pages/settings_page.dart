import 'package:birdart/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Define the keys for the settings
  static const wifiSyncTrackKey = 'wifi_sync_track';
  static const wifiSyncImageKey = 'wifi_sync_image';
  static const trackIntervalKey = 'track_interval';

  // Define the default values for the settings
  bool wifiSyncTrack = false;
  bool wifiSyncImage = false;
  int trackInterval = 10;

  // Define a shared preferences instance
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    // Initialize the shared preferences and load the settings
    initPrefs();
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      wifiSyncTrack = prefs!.getBool(wifiSyncTrackKey) ?? true;
      wifiSyncImage = prefs!.getBool(wifiSyncImageKey) ?? true;
      trackInterval = prefs!.getInt(trackIntervalKey) ?? 10;
    });
  }

  // A helper method to save a boolean setting
  void saveBoolSetting(String key, bool value) async {
    await prefs!.setBool(key, value);
    setState(() {
      switch (key) {
        case wifiSyncTrackKey:
          wifiSyncTrack = value;
          break;
        case wifiSyncImageKey:
          wifiSyncImage = value;
          break;
      }
    });
  }

  // A helper method to save an int setting
  void saveIntSetting(String key, int value) async {
    await prefs!.setInt(key, value);
    setState(() {
      switch (key) {
        case trackIntervalKey:
          trackInterval = value;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(BdL10n.current.mySettings),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(BdL10n.current.settingsWifiSyncTrack),
            value: wifiSyncTrack,
            onChanged: (value) => saveBoolSetting(wifiSyncTrackKey, value),
          ),
          SwitchListTile(
            title: Text(BdL10n.current.settingsWifiSyncImage),
            value: wifiSyncImage,
            onChanged: (value) => saveBoolSetting(wifiSyncImageKey, value),
          ),
          ListTile(
            title: Text(BdL10n.current.settingsTrackInterval),
            subtitle: Text(BdL10n.current.settingsTrackIntervalSeconds(trackInterval)),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => showTrackIntervalDialog(),
          ),
        ],
      ),
    );
  }

// A method to show a dialog for choosing the track interval
  void showTrackIntervalDialog() async {
    int? selectedValue = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(BdL10n.current.settingsSelectTrackInterval),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<int>(
              title: Text(BdL10n.current.settingsTrackIntervalSeconds(10)),
              value: 10,
              groupValue: trackInterval,
              onChanged: (value) => Navigator.pop(context, value),
            ),
            RadioListTile<int>(
              title: Text(BdL10n.current.settingsTrackIntervalSeconds(30)),
              value: 30,
              groupValue: trackInterval,
              onChanged: (value) => Navigator.pop(context, value),
            ),
            RadioListTile<int>(
              title: Text(BdL10n.current.settingsTrackIntervalSeconds(60)),
              value: 60,
              groupValue: trackInterval,
              onChanged: (value) => Navigator.pop(context, value),
            ),
          ],
        ),
      ),
    );
    if (selectedValue != null && selectedValue != trackInterval) {
      saveIntSetting(trackIntervalKey, selectedValue);
    }
  }
}
