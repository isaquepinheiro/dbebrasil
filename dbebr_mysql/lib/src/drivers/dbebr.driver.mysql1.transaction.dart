import 'package:dbebr_core/dbebr_core.dart';
import 'package:mysql1/mysql1.dart';

import 'dbebr.factory.mysql1.dart';

class DriverMysql1Transaction extends DriverTransaction {
  DriverMysql1Transaction({
    required this.factoryConnection,
  });
  late final FactoryMysql1 factoryConnection;
  late final TransactionContext _transaction;
  bool _inTransaction = false;

  TransactionContext get transaction => _transaction;

  @override
  void commitTransaction() {
    if (!_inTransaction) {
      // _transaction.cancelTransaction();
      _inTransaction = false;
    }
  }

  @override
  bool isInTransaction() => _inTransaction;

  @override
  void rollbackTransaction() {
    if (!_inTransaction) {
      // _transaction.cancelTransaction();
      _inTransaction = false;
    }
  }

  @override
  void startTransaction() {
    factoryConnection.connection.transaction((final transaction) async {
      _transaction = transaction;
    });
    _inTransaction = true;
  }
}
