import 'package:dbebr_core/dbebr_core.dart';
import 'package:postgres/postgres.dart';

import 'dbebr.driver.postgres.dart';
import 'dbebr.driver.postgres.transaction.dart';

class FactoryPostgres extends FactoryConnection {
  FactoryPostgres({
    required this.connection,
    required super.driver,
    super.onListener,
  }) {
    driverConnection = DriverPostgres(factoryConnection: this);
    driverTransaction = DriverPostgresTransaction(factoryConnection: this);
  }
  final PostgreSQLConnection connection;

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
