import 'package:dbebr_core/dbebr_core.dart';
import 'package:mysql1/mysql1.dart';

import 'dbebr.factory.mysql1.dart';

class DriverMysql1Transaction extends DriverTransaction {
  DriverMysql1Transaction({
    required this.factoryConnection,
  });
  late final FactoryMysql1 factoryConnection;
  late TransactionContext? _transaction;

  TransactionContext? get transaction => _transaction;

  @override
  void commitTransaction() {
    _transaction = null;
  }

  @override
  bool isInTransaction() => _transaction != null;

  @override
  void rollbackTransaction() {
    _transaction?.rollback();
    _transaction = null;
  }

  @override
  void startTransaction() {
    factoryConnection.connection.transaction((final transaction) async {
      _transaction = transaction;
    });
  }

  Future<void> execute(final String command) async {
    await _transaction?.query(command);
  }
}
