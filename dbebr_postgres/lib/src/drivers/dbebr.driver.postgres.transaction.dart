import 'package:dbebr_core/dbebr_core.dart';
import 'package:postgres/postgres.dart';

import 'dbebr.factory.postgres.dart';

class DriverPostgresTransaction extends DriverTransaction {
  DriverPostgresTransaction({
    required this.factoryConnection,
  });
  late final FactoryPostgres factoryConnection;
  late PostgreSQLExecutionContext? _transaction;

  PostgreSQLExecutionContext? get transaction => _transaction;

  @override
  void commitTransaction() {
    _transaction = null;
  }

  @override
  bool isInTransaction() => _transaction != null;

  @override
  void rollbackTransaction() {
    _transaction = null;
  }

  @override
  void startTransaction() {
    factoryConnection.connection.transaction((final transaction) async {
      _transaction = transaction;
    });
  }

  Future<void> execute(final String command) async {
    await _transaction?.execute(command);
  }
}
