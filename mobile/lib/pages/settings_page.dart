import 'package:flutter/material.dart';
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
  static const instantUploadKey = 'instant_upload';
  static const trackIntervalKey = 'track_interval';

  // Define the default values for the settings
  bool wifiSyncTrack = false;
  bool wifiSyncImage = false;
  bool instantUpload = false;
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
      instantUpload = prefs!.getBool(instantUploadKey) ?? true;
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
        case instantUploadKey:
          instantUpload = value;
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
        title: const Text('设置'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('WiFi下自动同步轨迹'),
            value: wifiSyncTrack,
            onChanged: (value) => saveBoolSetting(wifiSyncTrackKey, value),
          ),
          SwitchListTile(
            title: const Text('WiFi下自动同步图片'),
            value: wifiSyncImage,
            onChanged: (value) => saveBoolSetting(wifiSyncImageKey, value),
          ),
          /*SwitchListTile(
            title: const Text('即时上传'),
            subtitle: const Text('您新增的数据（项目、调查地、病虫害调查记录及植物调查记录）将被实时上传到云端，这可能消耗您的流量。'),
            value: instantUpload,
            onChanged: (value) => saveBoolSetting(instantUploadKey, value),
          ),*/
          ListTile(
            title: const Text('轨迹时间间隔'),
            subtitle: Text('$trackInterval 秒'),
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
        title: const Text('选择轨迹时间间隔'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<int>(
              title: const Text('10 秒'),
              value: 10,
              groupValue: trackInterval,
              onChanged: (value) => Navigator.pop(context, value),
            ),
            RadioListTile<int>(
              title: const Text('30 秒'),
              value: 30,
              groupValue: trackInterval,
              onChanged: (value) => Navigator.pop(context, value),
            ),
            RadioListTile<int>(
              title: const Text('60 秒'),
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
