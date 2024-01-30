import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:drift/drift.dart';
import 'package:shared/model/uuid_gen.dart';

enum UserStatus {
  active(0),
  blocked(1),
  deleted(2),
  autoBlocked(3);

  const UserStatus(this.value);

  final int value;
}

enum UserRole {
  birder(0),
  reviewer(1),
  admin(2),
  sysAdmin(3);

  const UserRole(this.value);

  final int value;
}

class UserTable extends Table {
  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text().withLength(max: 36, min: 36)();
  TextColumn get name => text()();
  TextColumn get password => text()();
  TextColumn get salt => text()();
  TextColumn get phone => text()();
  TextColumn get email => text()();
  TextColumn get biography => text()();

  IntColumn get status => integer().map(EnumIndexConverter(UserStatus.values))();
  IntColumn get role => integer().map(EnumIndexConverter(UserRole.values))();

  DateTimeColumn get registerTime => dateTime()();
  DateTimeColumn get lastLoginTime => dateTime()();
}

class User {
  User({
    required this.id,
    required this.name,
    required this.password,
    required this.salt,
    required this.phone,
    required this.email,
    required this.status,
    required this.biography,
    required this.role,
    required this.registerTime,
    required this.lastLoginTime,
  });

  String id;
  String name;
  String password; // in hash
  String salt; // in clear text
  String phone;
  String email;
  String biography;
  UserStatus status;
  UserRole role;
  DateTime registerTime;
  DateTime lastLoginTime;

  static Future<User> add({
    required String name,
    required String password,
    required String phone,
    required String email,
    required String biography,
    UserStatus? status,
    UserRole? role,
  }) async {
    final id = uuid.v1();
    final salt = base64.encode(await SecretKeyData.random(length: 32).extractBytes());
    final result = await hash(password, salt);

    return User(
      id: id,
      name: name,
      phone: phone,
      email: email,
      biography: biography,
      status: status ?? UserStatus.active,
      role: role ?? UserRole.birder,
      password: result,
      salt: salt,
      registerTime: DateTime.now(),
      lastLoginTime: DateTime.now(),
    );
  }

  static Future<String> hash(String password, String salt) async {
    return base64.encode(await (await _algorithm.deriveKeyFromPassword(
      password: password,
      nonce: base64.decode(salt),
    )).extractBytes());
  }
  
  Future<bool> checkPassword(String password) async =>
      (await hash(password, salt)) == this.password;

  Map toJson() => {
    'id': id,
    'name': name,
    'password': password,
    'salt': salt,
    'phone': phone,
    'email': email,
    'status': status.value,
    'biography': biography,
    'role': role.value,
    'registerTime': registerTime.microsecondsSinceEpoch,
    'lastLoginTime': lastLoginTime.microsecondsSinceEpoch,
  };

  factory User.fromJson(Map<String, dynamic> data) =>
      User(
        id: data['id'],
        name: data['name'],
        password: data['password'],
        salt: data['salt'],
        phone: data['phone'],
        email: data['email'],
        status: UserStatus.values[data['status']],
        biography: data['biography'],
        role: UserRole.values[data['role']],
        registerTime: DateTime.fromMicrosecondsSinceEpoch(data['registerTime']),
        lastLoginTime: DateTime.fromMicrosecondsSinceEpoch(data['lastLoginTime']),
      );

  static Future<User> fromRegisterData(Map<String, dynamic> data) async =>
      await User.add(
        name: data['name'],
        password: data['password'],
        phone: data['phone'],
        email: data['email'],
        biography: data['biography'],
      );
}

final _algorithm = Argon2id(
  memory: 10 * 1000, // 10 MB
  parallelism: 2, // Use maximum two CPU cores.
  iterations: 1, // For more security, you should usually raise memory parameter, not iterations.
  hashLength: 32, // Number of bytes in the returned hash
);
