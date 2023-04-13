import 'package:dbebr_core/dbebr_core.dart';
import 'package:mysql1/mysql1.dart';

import 'dbebr.driver.mysql1.dart';
import 'dbebr.driver.mysql1.transaction.dart';

class FactoryMysql1 extends FactoryConnection {
  FactoryMysql1({
    required this.connection,
    required super.driver,
    super.onListener,
  }) {
    driverConnection = DriverMysql1(factoryConnection: this);
    driverTransaction = DriverMysql1Transaction(factoryConnection: this);
  }
  final MySqlConnection connection;

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
