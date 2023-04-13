import 'package:dbebr_core/dbebr_core.dart';
import 'package:postgres/postgres.dart';

import 'dbebr.factory.postgres.dart';

class DriverPostgresTransaction extends DriverTransaction {
  DriverPostgresTransaction({
    required this.factoryConnection,
  });
  late final FactoryPostgres factoryConnection;
  late final PostgreSQLExecutionContext _transaction;
  bool _inTransaction = false;

  PostgreSQLExecutionContext get transaction => _transaction;

  @override
  void commitTransaction() {
    if (!_inTransaction) {
      _transaction.cancelTransaction();
      _inTransaction = false;
    }
  }

  @override
  bool isInTransaction() => _inTransaction;

  @override
  void rollbackTransaction() {
    if (!_inTransaction) {
      _transaction.cancelTransaction();
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
