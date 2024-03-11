import 'package:shared/model/user.dart';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../entity/server.dart';
import '../entity/user_profile.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  // Mock user data
  String avatarUrl = '${Server.url}user/avatar?id=${UserProfile.id}';

  // A flag to control the expansion tile
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(BdL10n.current.profileTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Avatar row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: ExtendedNetworkImageProvider(avatarUrl, cache: true),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Show a dialog to change avatar
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(BdL10n.current.profileChangeAvatar),
                        content: Text(BdL10n.current.profileChooseAvatar),
                        actions: [
                          TextButton(
                            child: Text(BdL10n.current.cancel),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: Text(BdL10n.current.ok),
                            onPressed: () {
                              // TODO: Implement the logic to change avatar
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Name row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                UserProfile.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Show a dialog to change name
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            title: Text(BdL10n.current.profileEditUserName),
                            content: TextField(
                                decoration:
                                    InputDecoration(hintText: BdL10n.current.profileEnterUserName)),
                            actions: [
                              TextButton(
                                  child: Text(BdL10n.current.cancel),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                              TextButton(
                                  child: Text(BdL10n.current.ok),
                                  onPressed: () {
                                    // TODO : Implement the logic to change name
                                    Navigator.pop(context);
                                  }),
                            ]);
                      });
                },
              )
            ],
          ),
          const SizedBox(height: 16),
          // User ID row
          ListTile(
            leading: const Icon(Icons.face_rounded),
            title: Text(BdL10n.current.profileUserID),
            subtitle: Text(UserProfile.id),
          ),
          const Divider(),
          // Email row
          ListTile(
            leading: const Icon(Icons.email),
            title: Text(BdL10n.current.profileEmail),
            subtitle: Text(UserProfile.email),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings_cell),
            title: Text(BdL10n.current.profilePhone),
            subtitle: Text(UserProfile.phone),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.supervised_user_circle),
            title: Text(BdL10n.current.profileRole),
            subtitle: Text(UserRole.values[UserProfile.role].name),
          ),
          // Status row
          const Divider(),
          ListTile(
            leading: const Icon(Icons.check_circle),
            title: Text(BdL10n.current.profileStatus),
            subtitle: Text(UserStatus.values[UserProfile.status].name),
          ),
          // Status row
          const Divider(),
          ListTile(
            leading: const Icon(Icons.power_settings_new_rounded),
            title: Text(BdL10n.current.profileLogout),
            onTap: () {
              UserProfile.clear();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
