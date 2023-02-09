import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../entity/user_profile.dart';
import '../widget/app_bars.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({Key? key}) : super(key: key);

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  // Mock user data
  String avatarUrl = 'http://www.whylky.org/images/img_y1.jpg';

  // A flag to control the expansion tile
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: anAppBar(
        title: const Text('个人信息'),
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
                backgroundImage: CachedNetworkImageProvider(avatarUrl),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Show a dialog to change avatar
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('修改头像'),
                        content: const Text('请从手机上选择新头像'),
                        actions: [
                          TextButton(
                            child: const Text('取消'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: const Text('确认'),
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
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Show a dialog to change name
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            title: const Text('修改用户名'),
                            content: const TextField(
                                decoration: InputDecoration(hintText: '输入用户名')),
                            actions: [
                              TextButton(
                                  child: const Text('取消'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                              TextButton(
                                  child: const Text('修改'),
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
              title: const Text('用户ID'),
              subtitle: Text(UserProfile.number.toString().padLeft(6, '0'))),
          const Divider(),
          // Phone row
          ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('手机号码'),
              subtitle: Text(UserProfile.phone)),
          const Divider(),
          // Email row
          ListTile(
              leading: const Icon(Icons.email),
              title: const Text('电子邮箱'),
              subtitle: Text(UserProfile.email)),
          const Divider(),
          // Role row
          ListTile(
              leading: const Icon(Icons.supervised_user_circle),
              title: const Text('权限'),
              subtitle: Text(UserProfile.role)),
          const Divider(),
          // Status row
          ListTile(
            leading: const Icon(Icons.check_circle),
            title: const Text('用户状态'),
            subtitle: Text(UserProfile.status == 1 ? '正常' : '账户状态异常，请联系管理员'),
          ),
          const Divider(),
          // Expansion tile row
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('敏感信息'),
            subtitle: Text(isExpanded ? '点击关闭' : '点击查看'),
            onTap: () {
              // Show a dialog to confirm before expanding
              if (!isExpanded) {
                setState(() {
                  isExpanded = false;
                });
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('警告'),
                      content: const Text('您将查看敏感信息，这些信息是后台的技术信息，'
                          '当您使用app时遇到问题并向后台技术人员求助时，'
                          '可能会被要求提供这些信息。'
                          '除此之外请不要将这些信息提供给任何人，'
                          '否则可能导致您的账号被盗取，或发生其它不可预知的后果。'),
                      actions: [
                        TextButton(
                          child: const Text('取消'),
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {
                              isExpanded = false;
                            });
                          },
                        ),
                        TextButton(
                          child: const Text('确认'),
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {
                              isExpanded = true;
                            });
                          },
                        ),
                      ],
                    );
                  },
                );
              } else {
                setState(() {
                  isExpanded = !isExpanded;
                });
              }
            },
          ),
          if (isExpanded)
            ListTile(
              title: const Text('数据库ID'),
              subtitle: Text(UserProfile.id),
            ),
          if (isExpanded)
            ListTile(
              title: const Text('Cookie'),
              subtitle: Text(UserProfile.session),
            ),

          const Divider(),
          // Status row
          ListTile(
            leading: const Icon(Icons.power_settings_new_rounded),
            title: const Text('退出账号'),
            subtitle: const Text('您将退出本地账号'),
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
