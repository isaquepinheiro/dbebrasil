import 'package:dbebr_core/dbebr_core.dart';
import 'package:sqflite/sqflite.dart';

import 'dbebr.driver.sqflite.dart';
import 'dbebr.driver.sqflite.transaction.dart';

class FactorySqflite extends FactoryConnection {
  FactorySqflite({
    required this.connection,
    required super.driver,
    super.onListener,
  }) {
    driverConnection = DriverSqflite(factoryConnection: this);
    driverTransaction = DriverSqfliteTransaction(factoryConnection: this);
  }
  final Database connection;

  @override
  Future<IDBResultSet> createResultSet(final String command) async {
    final IDBResultSet resultSet = DataSet();
    connectInternal(isConnected());
    try {
      startTransactionInternal(isInTransaction());
      resultSet.dataSet = await driverConnection.createResultSet(command);
      commitTransactionInternal(isInTransaction());

      return resultSet;
    } catch (e) {
      rollbackTransactionInternal(isInTransaction());
      throw DBEBrException('[ $runtimeType.createResultSet() ]', e.toString());
    } finally {
      disconnectInternal(isConnected());
    }
  }

  @override
  void executeScript(final String command) async {
    connectInternal(isConnected());
    try {
      startTransactionInternal(isInTransaction());
      driverConnection.executeScript(command);
      commitTransactionInternal(isInTransaction());
    } catch (e) {
      rollbackTransactionInternal(isInTransaction());
      throw DBEBrException('[ $runtimeType.executeScript() ]', e.toString());
    } finally {
      disconnectInternal(isConnected());
    }
  }

  @override
  void executeDirect(final String command, [final Params? params]) async {
    connectInternal(isConnected());
    try {
      startTransactionInternal(isInTransaction());
      driverConnection.executeDirect(command);
      commitTransactionInternal(isInTransaction());
    } catch (e) {
      rollbackTransactionInternal(isInTransaction());
      throw DBEBrException('[ $runtimeType.executeDirect() ]', e.toString());
    } finally {
      disconnectInternal(isConnected());
    }
  }
}
