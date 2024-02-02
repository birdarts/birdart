import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart' as j;

import '../db/drift_db.dart';
import 'user.drift.dart';

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

@j.JsonSerializable()
class User extends Table {
  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text().withLength(max: 36, min: 36)();
  TextColumn get name => text()();
  TextColumn get password => text()();
  TextColumn get salt => text()();
  TextColumn get phone => text().unique()();
  TextColumn get email => text().unique()();
  TextColumn get biography => text()();

  IntColumn get status => integer().map(EnumIndexConverter(UserStatus.values))();
  IntColumn get role => integer().map(EnumIndexConverter(UserRole.values))();

  DateTimeColumn get registerTime => dateTime()();
  DateTimeColumn get lastLoginTime => dateTime()();

  static Future<UserData> add({
    required String name,
    required String password,
    required String phone,
    required String email,
    required String biography,
    UserStatus? status,
    UserRole? role,
  }) async {
    final id = Uuid().v1();
    final salt = base64.encode(await SecretKeyData.random(length: 32).extractBytes());
    final result = await _hash(password, salt);

    return UserData(
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

  static Future<UserData> fromRegisterData(Map<String, dynamic> data) async => await add(
    name: data['name'] ?? '',
    password: data['password'],
    phone: data['phone'] ?? '',
    email: data['email'] ?? '',
    biography: data['biography'] ?? '',
  );
}

extension UserExt on UserData {
  Future<bool> checkPassword(String password) async =>
      (await _hash(password, salt)) == this.password;
  
  Future<void> resetPassword(String password) async {
    salt = base64.encode(await SecretKeyData.random(length: 32).extractBytes());
    this.password = await _hash(password, salt);
  }
}

Future<String> _hash(String password, String salt) async {
  return base64.encode(await (await _algorithm.deriveKeyFromPassword(
    password: password,
    nonce: base64.decode(salt),
  ))
      .extractBytes());
}

final _algorithm = Argon2id(
  memory: 10 * 1000, // 10 MB
  parallelism: 2, // Use maximum two CPU cores.
  iterations: 1, // For more security, you should usually raise memory parameter, not iterations.
  hashLength: 32, // Number of bytes in the returned hash
);

@DriftAccessor(tables: [User])
class UserDao extends DatabaseAccessor<BirdartDB> with $UserDaoMixin {
  // 构造方法是必需的，这样主数据库可以创建这个对象的实例。
  UserDao(super.db);

  Future<int> insertOne(UserData user) => into(db.user).insertOnConflictUpdate(user);

  Future<void> insertList(List<UserData> users) =>
      batch((batch) {
        batch.insertAllOnConflictUpdate(db.user, users);
      });

  Future<int> deleteOne(UserData user) => (delete(db.user)..whereSamePrimaryKey(user)).go();

  Future<void> deleteList(List<UserData> users) =>
      (delete(db.user)..where((tbl) => tbl.id.isIn(users.map((e) => e.id)))).go();

  Future<int> deleteById(String userId) =>
      (delete(db.user)..where((tbl) => tbl.id.equals(userId))).go();

  Future<int> updateOne(UserData user) => (update(db.user)..whereSamePrimaryKey(user)).write(user);

  Future<void> updateList(List<UserData> users) =>
      batch((batch) {
        users.map((e) => batch.update(db.user, e));
      });

  Future<List<UserData>> getAll() => (select(db.user)).get();

  Future<UserData?> getById(String userId) =>
      (select(db.user)..where((tbl) => tbl.id.equals(userId))).getSingleOrNull();

  Future<UserData?> getByPhone(String phone) =>
      (select(db.user)..where((tbl) => tbl.phone.equals(phone))).getSingleOrNull();

  Future<UserData?> getByEmail(String email) =>
      (select(db.user)..where((tbl) => tbl.email.equals(email))).getSingleOrNull();
}
