import 'dart:async';
import 'package:dbebr_core/dbebr_core.dart';
import 'package:postgres/postgres.dart';

import 'dbebr.driver.postgres.transaction.dart';
import 'dbebr.factory.postgres.dart';

// var connection = PostgreSQLConnection("localhost", 5432, "dart_test", username: "dart", password: "dart");
// await connection.open();

class DriverPostgres extends DriverConnection {
  DriverPostgres({
    required this.factoryConnection,
  });
  late final FactoryPostgres factoryConnection;

  @override
  DriverDatabase get driverDatabase => DriverDatabase.dnPostgreSQL;

  @override
  void connect() async {
    if (factoryConnection.connection.isClosed) {
      try {
        await factoryConnection.connection.open();
      } catch (e) {
        throw DBEBrException('[ $runtimeType.connect() ]', e.toString());
      }
    }
  }

  @override
  void disconnect() async {}

  @override
  bool isConnected() => !factoryConnection.connection.isClosed;

  @override
  Future<IResultSet> createResultSet(final String command) async {
    final Future<IResultSet> result = _createResultSet(command).then(
        (final value) => value.map((final row) => row.toColumnMap()).toList());

    return result;
  }

  Future<PostgreSQLResult> _createResultSet(final String command) async {
    final PostgreSQLResult query =
        await factoryConnection.connection.query(command);

    return query;
  }

  @override
  void executeScript(final String command) async {
    await (factoryConnection.driverTransaction as DriverPostgresTransaction)
        .transaction
        .execute(command);
  }

  @override
  void executeDirect(final String command, [final Params? params]) async {
    await (factoryConnection.driverTransaction as DriverPostgresTransaction)
        .transaction
        .execute(command);
  }
}
