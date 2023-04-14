import 'dart:async';
import 'package:dbebr_core/dbebr_core.dart';

import 'dbebr.driver.sqflite.transaction.dart';
import 'dbebr.factory.sqflite.dart';

// var connection = PostgreSQLConnection("localhost", 5432, "dart_test", username: "dart", password: "dart");
// await connection.open();

typedef SQFliteResult = List<Map<String, Object?>>;

class DriverSqflite extends DriverConnection {
  DriverSqflite({
    required this.factoryConnection,
  });
  late final FactorySqflite factoryConnection;

  @override
  DriverDatabase get driverDatabase => DriverDatabase.dnSQLite;

  @override
  void connect() async {
    if (factoryConnection.connection.isOpen) {
      try {
        // await factoryConnection.connection.open();
      } catch (e) {
        throw DBEBrException('[ $runtimeType.connect() ]', e.toString());
      }
    }
  }

  @override
  void disconnect() async {
    if (factoryConnection.connection.isOpen) {
      factoryConnection.connection.close();
    }
  }

  @override
  bool isConnected() => !factoryConnection.connection.isOpen;

  @override
  Future<IResultSet> createResultSet(final String command) async {
    final Future<IResultSet> result =
        _createResultSet(command).then((final value) => value.toList());

    return result;
  }

  Future<SQFliteResult> _createResultSet(final String command) async {
    final SQFliteResult query =
        await factoryConnection.connection.query(command);

    return query;
  }

  @override
  void executeScript(final String command) {
    executeDirect(command);
  }

  @override
  void executeDirect(final String command, [final Params? params]) {
    final DriverSqfliteTransaction driverTransaction =
        (factoryConnection.driverTransaction as DriverSqfliteTransaction);

    (driverTransaction.transaction == null)
        ? factoryConnection.connection.execute(command)
        : driverTransaction.execute(command);
  }
}
