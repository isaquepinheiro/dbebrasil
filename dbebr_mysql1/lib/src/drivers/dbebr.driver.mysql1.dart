import 'dart:async';
import 'package:dbebr_core/dbebr_core.dart';
import 'package:mysql1/mysql1.dart';

import 'dbebr.driver.mysql1.transaction.dart';
import 'dbebr.factory.mysql1.dart';

// var connection = PostgreSQLConnection("localhost", 5432, "dart_test", username: "dart", password: "dart");
// await connection.open();

class DriverMysql1 extends DriverConnection {
  DriverMysql1({
    required this.factoryConnection,
  });
  late final FactoryMysql1 factoryConnection;

  @override
  DriverDatabase get driverDatabase => DriverDatabase.dnPostgreSQL;

  @override
  void connect() async {
    // if (factoryConnection.connection.isClosed) {
    //   try {
    //     await factoryConnection.connection.open();
    //   } catch (e) {
    //     throw DBEBrException('[ $runtimeType.connect() ]', e.toString());
    //   }
    // }
  }

  @override
  void disconnect() async {}

  @override
  bool isConnected() => true; //!factoryConnection.connection.isClosed;

  @override
  Future<IResultSet> createResultSet(final String command) async {
    final Future<IResultSet> result = _createResultSet(command)
        .then((final value) => value.map((final row) => row.fields).toList());

    return result;
  }

  Future<Results> _createResultSet(final String command) async {
    final Results query = await factoryConnection.connection.query(command);

    return query;
  }

  @override
  void executeScript(final String command) {
    executeDirect(command);
  }

  @override
  void executeDirect(final String command, [final Params? params]) {
    final DriverMysql1Transaction driverTransaction =
        (factoryConnection.driverTransaction as DriverMysql1Transaction);

    (driverTransaction.transaction == null)
        ? factoryConnection.connection.query(command)
        : driverTransaction.execute(command);
  }
}
