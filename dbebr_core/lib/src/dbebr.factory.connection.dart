import 'package:meta/meta.dart';
import 'dbebr.dataset.dart';
import 'dbebr.driver.connection.dart';
import 'dbebr.factory.interfaces.dart';

abstract class FactoryConnection implements IConnection {
  FactoryConnection({
    required this.driver,
    this.onListener,
  }) {
    _autoTransaction = false;
  }
  final DriverDatabase driver;
  final ListenerEvent? onListener;
  late final DriverTransaction driverTransaction;
  late final DriverConnection driverConnection;
  late bool _autoTransaction;

  @override
  void connect() {
    if (!isConnected()) {
      driverConnection.connect();
    }
  }

  @override
  void disconnect() {
    if (isConnected()) {
      driverConnection.disconnect();
    }
  }

  @override
  void executeDirect(final String command, [final Params? params]) =>
      driverConnection.executeDirect(command);

  @override
  void executeScript(final String command) =>
      driverConnection.executeDirect(command);

  @override
  Future<IDBResultSet> createResultSet(final String command) async {
    final IDBResultSet result = DataSet();
    result.dataSet = await driverConnection.createResultSet(command);

    return result;
  }

  @override
  bool isConnected() => driverConnection.isConnected();

  @override
  void startTransaction() {
    !isConnected() ? _autoTransaction = true : _autoTransaction = false;
    connectInternal(isConnected());
    driverTransaction.startTransaction();
  }

  @override
  void commitTransaction() {
    driverTransaction.commitTransaction();
    if (_autoTransaction) {
      disconnect();
    }
  }

  @override
  void rollbackTransaction() {
    driverTransaction.rollbackTransaction();
    if (_autoTransaction) {
      disconnect();
    }
  }

  @override
  bool isInTransaction() => driverTransaction.isInTransaction();

  @protected
  void connectInternal(final bool isConnected) {
    if (!isConnected) {
      connect();
    }
  }

  @protected
  void startTransactionInternal(final bool inTransaction) {
    if (!inTransaction) {
      startTransaction();
    }
  }

  @protected
  void commitTransactionInternal(final bool inTransaction) {
    if (inTransaction) {
      commitTransaction();
    }
  }

  @protected
  void rollbackTransactionInternal(final bool inTransaction) {
    if (inTransaction) {
      rollbackTransaction();
    }
  }

  @protected
  void disconnectInternal(final bool isConnected) {
    if (!isConnected) {
      disconnect();
    }
  }
}
