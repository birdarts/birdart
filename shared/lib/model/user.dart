import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:floor_annotation/floor_annotation.dart';
import 'package:shared/model/uuid_gen.dart';

abstract class ExtendableEnum {
  const ExtendableEnum();
  static const List<ExtendableEnum> values = [];
  int get value;
}

class UserStatus extends ExtendableEnum {
  @override
  final int value;
  const UserStatus._(this.value);

  static const active = UserStatus._(0);
  static const blocked = UserStatus._(1);
  static const deleted = UserStatus._(2);
  static const autoBlocked = UserStatus._(3); // Automatically blocked by system

  static const List<UserStatus> values = [active, blocked, deleted, autoBlocked];
}

class UserRole extends ExtendableEnum {
  @override
  final int value;
  const UserRole._(this.value);

  static const birder = UserRole._(0);
  static const reviewer = UserRole._(1);
  static const admin = UserRole._(2);
  static const sysAdmin = UserRole._(3);

  static const List<UserRole> values = [birder, reviewer, admin, sysAdmin];
}

@entity
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

  @primaryKey
  String id;
  String name;
  String password; // in hash
  String salt; // in clear text
  String phone;
  String email;
  UserStatus status;
  String biography;
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

@dao
abstract class UserDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertOne(User user);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> insertList(List<User> users);

  @delete
  Future<int> deleteOne(User user);

  @delete
  Future<int> deleteList(List<User> users);

  @update
  Future<int> updateOne(User user);

  @update
  Future<int> updateList(List<User> users);

  @Query("DELETE FROM user WHERE id = :userId")
  Future<int?> deleteById(String userId);

  @Query("SELECT * FROM user ORDER BY datetime(startTime) desc")
  Future<List<User>> getAll();

  @Query("SELECT * FROM user WHERE id = :userId")
  Future<List<User>> getById(String userId);

  @Query("SELECT * FROM user WHERE sync <> 1")
  Future<List<User>> getUnsynced();

  @Query("SELECT * FROM user WHERE instr(startTime, :date) ORDER BY datetime(startTime) desc")
  Future<List<User>> getByDate(String date);
}