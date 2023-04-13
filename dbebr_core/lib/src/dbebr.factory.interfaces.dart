import 'dart:collection';

import 'dbebr.param.dart';

typedef Params = Queue<Param>;
typedef ListenerEvent = void Function(String value, Params params);
typedef IResultSet = List<Map<String, dynamic>>;

enum DriverDatabase {
  dnSQLServer(name: 'SQLServer'),
  dnMySql(name: 'MySQL'),
  dnFirebird(name: 'Firebird'),
  dnSQLite(name: 'SQLite'),
  dnInterbase(name: 'Interbase'),
  dnDB2(name: 'DB2'),
  dnOracle(name: 'Oracle'),
  dnPostgreSQL(name: 'PostgreSQL'),
  dnMongodb(name: 'Mongodb'),
  dnFirebase(name: 'Firebase');

  const DriverDatabase({
    required this.name,
  });
  final String name;
}

abstract class ITransaction {
  void startTransaction();
  void commitTransaction();
  void rollbackTransaction();
  bool isInTransaction();
}

abstract class IConnection implements ITransaction {
  void connect();
  void disconnect();
  void executeDirect(final String command, [final Params? params]);
  void executeScript(final String command);
  bool isConnected();
  Future<IDBResultSet> createResultSet(final String command);
  @override
  void startTransaction();
  @override
  void commitTransaction();
  @override
  void rollbackTransaction();
  @override
  bool isInTransaction();
}

abstract class IDBResultSet {
  void close();
  void next();
  void prior();
  void first();
  void last();
  bool notEof();
  int recordCount();
  dynamic fieldValue(final String fieldName);
  String? fieldType(final String fieldName);
  IField fieldByName(final String fieldName);
  IResultSet get dataSet;
  set dataSet(final IResultSet dataset);
}

abstract class IField {
  IField fieldByName(final String fieldName);
  String get asString;
  String asStringDef(final String def);
  int get asInteger;
  int asIntegerDef(final int def);
  double get asDouble;
  double asDoubleDef(final double def);
  bool get asBoolean;
  bool asBooleanDef(final bool def);
  DateTime get asDateTime;
  DateTime asDateTimeDef(final DateTime def);
}
