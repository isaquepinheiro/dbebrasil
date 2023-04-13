import 'dbebr.factory.interfaces.dart';

abstract class DriverConnection {
  DriverConnection();

  DriverDatabase get driverDatabase;
  void connect();
  void disconnect();
  void executeDirect(final String command, [final Params? params]);
  void executeScript(final String command);
  bool isConnected();
  Future<IResultSet> createResultSet(final String command);
}

abstract class DriverTransaction {
  DriverTransaction();

  void startTransaction();
  void commitTransaction();
  void rollbackTransaction();
  bool isInTransaction();
}
