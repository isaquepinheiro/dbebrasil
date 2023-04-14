import 'package:dbebr_core/dbebr_core.dart';
import 'package:sqflite/sqflite.dart';
import 'dbebr.factory.sqflite.dart';

class DriverSqfliteTransaction extends DriverTransaction {
  DriverSqfliteTransaction({
    required this.factoryConnection,
  });
  late final FactorySqflite factoryConnection;
  late Batch? _transaction;

  Batch? get transaction => _transaction;

  @override
  void commitTransaction() async {
    await _transaction?.commit();
    _transaction = null;
  }

  @override
  bool isInTransaction() => _transaction != null;

  @override
  void rollbackTransaction() {
    // _transaction.rollback();
    _transaction = null;
  }

  @override
  void startTransaction() async {
    await factoryConnection.connection.transaction((final transaction) async {
      _transaction = transaction.batch();
    });
  }

  Future<void> execute(final String command) async {
    try {
      _transaction?.execute(command);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
