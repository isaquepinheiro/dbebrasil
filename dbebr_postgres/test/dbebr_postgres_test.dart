import 'package:cqlbr_postgres/dbebr_postgres.dart';
import 'package:dbebr_core/dbebr_core.dart';
import 'package:postgres/postgres.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final PostgreSQLConnection connectionPostgre = PostgreSQLConnection(
        '127.0.0.1', 5432, 'postgres',
        username: 'postgres', password: 'postgrespw');

    final IConnection connection = FactoryPostgres(
      connection: connectionPostgre,
      driver: DriverDatabase.dnPostgreSQL,
    );
    connection.connect();

    setUp(() async {});

    tearDown(() async {});

    test('Teste de conexão aberta', () {
      expect(connection.isConnected(), true);
    });

    test('Teste de conexão fechada', () {
      expect(!connection.isConnected(), false);
    });

    test('Teste de seleção de dois registros', () async {
      final IDBResultSet results =
          await connection.createResultSet('SELECT * FROM PUBLIC."user"');
      final List<Map<String, dynamic>> list = [
        {
          'id': 1,
          'name': 'Isaque',
          'date': '1971-06-02 00:00:00.000Z',
          'salary': '1000.00',
        },
        {
          'id': 2,
          'name': 'Pinheiro',
          'date': '2022-08-02 00:00:00.000Z',
          'salary': '5000.00',
        },
      ];
      // expect(results, list);
      expect(results.dataSet[0]['name'], list[0]['name']);
      expect(results.dataSet[1]['name'], list[1]['name']);
    });

    test('Teste de DataSet', () async {
      final IDBResultSet results =
          await connection.createResultSet('SELECT * FROM PUBLIC."user"');
      final List<Map<String, dynamic>> list = [
        {
          'id': 1,
          'name': 'Isaque',
          'date': '1971-06-02 00:00:00.000Z',
          'salary': '1000.00',
        },
        {
          'id': 2,
          'name': 'Pinheiro',
          'date': '2022-08-02 00:00:00.000Z',
          'salary': '5000.00',
        },
      ];
      expect(results.dataSet.toString(), list.toString());
    });

    test('Teste de DataSet - RecordCount()', () async {
      final IDBResultSet results =
          await connection.createResultSet('SELECT * FROM PUBLIC."user"');
      expect(results.recordCount(), 2);
    });

    test('Teste de DataSet - Next()', () async {
      final IDBResultSet results =
          await connection.createResultSet('SELECT * FROM PUBLIC."user"');
      final List<Map<String, dynamic>> list = [
        {
          'id': 1,
          'name': 'Isaque',
          'date': '1971-06-02 00:00:00.000Z',
          'salary': '1000.00',
        },
        {
          'id': 2,
          'name': 'Pinheiro',
          'date': '2022-08-02 00:00:00.000Z',
          'salary': '5000.00',
        },
      ];
      results.next();
      expect(results.fieldValue('name'), list[1]['name']);
    });

    test('Teste de DataSet - Prior()', () async {
      final IDBResultSet results =
          await connection.createResultSet('SELECT * FROM PUBLIC."user"');
      final List<Map<String, dynamic>> list = [
        {
          'id': 1,
          'name': 'Isaque',
          'date': '1971-06-02 00:00:00.000Z',
          'salary': '1000.00',
        },
        {
          'id': 2,
          'name': 'Pinheiro',
          'date': '2022-08-02 00:00:00.000Z',
          'salary': '5000.00',
        },
      ];
      results.next();
      expect(results.fieldValue('name'), list[1]['name']);
      results.prior();
      expect(results.fieldValue('name'), list[0]['name']);
    });

    test('Teste de DataSet - Last()', () async {
      final IDBResultSet results =
          await connection.createResultSet('SELECT * FROM PUBLIC."user"');
      final List<Map<String, dynamic>> list = [
        {
          'id': 1,
          'name': 'Isaque',
          'date': '1971-06-02 00:00:00.000Z',
          'salary': '1000.00',
        },
        {
          'id': 2,
          'name': 'Pinheiro',
          'date': '2022-08-02 00:00:00.000Z',
          'salary': '5000.00',
        },
      ];
      results.last();
      expect(results.fieldValue('name'), list[1]['name']);
    });

    test('Teste de DataSet - First()', () async {
      final IDBResultSet results =
          await connection.createResultSet('SELECT * FROM PUBLIC."user"');
      final List<Map<String, dynamic>> list = [
        {
          'id': 1,
          'name': 'Isaque',
          'date': '1971-06-02 00:00:00.000Z',
          'salary': '1000.00',
        },
        {
          'id': 2,
          'name': 'Pinheiro',
          'date': '2022-08-02 00:00:00.000Z',
          'salary': '5000.00',
        },
      ];
      results.last();
      expect(results.fieldValue('name'), list[1]['name']);
      results.first();
      expect(results.fieldValue('name'), list[0]['name']);
    });

    test('Teste de DataSet - FieldType()', () async {
      final IDBResultSet results =
          await connection.createResultSet('SELECT * FROM PUBLIC."user"');
      expect(results.fieldType('id'), 'int');
      expect(results.fieldType('name'), 'String');
      expect(results.fieldType('date'), 'DateTime');
    });

    test('Teste de DataSet - FieldByName().AsString', () async {
      final IDBResultSet results =
          await connection.createResultSet('SELECT * FROM PUBLIC."user"');
      expect(results.fieldByName('id').asString, '1');
    });

    test('Teste de DataSet - FieldByName().AsDouble', () async {
      final IDBResultSet results =
          await connection.createResultSet('SELECT * FROM PUBLIC."user"');
      expect(results.fieldByName('salary').asDouble, 1000.00);
    });

    test('Teste de DataSet - FieldByName().AsInteger', () async {
      final IDBResultSet results =
          await connection.createResultSet('SELECT * FROM PUBLIC."user"');
      expect(results.fieldByName('salary').asInteger, 1000);
    });
  });
}
