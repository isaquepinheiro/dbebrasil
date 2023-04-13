import 'package:meta/meta.dart';

import 'dbebr.factory.interfaces.dart';
import 'dbebr.field.dart';

class DataSet implements IDBResultSet {
  DataSet() {
    fieldDefs = DBField(this);
    currentRecord = 0;
  }
  @protected
  late final IResultSet dataList;
  @protected
  late final DBField fieldDefs;
  @protected
  late int currentRecord;

  @override
  IResultSet get dataSet => dataList;
  @override
  set dataSet(final IResultSet dataset) => dataList = dataset;

  @override
  void close() => dataList.clear();

  @override
  IField fieldByName(final String fieldName) =>
      fieldDefs.fieldByName(fieldName);

  @override
  String? fieldType(final String fieldName) {
    if (dataList[currentRecord].isNotEmpty) {
      if (dataList[currentRecord].containsKey(fieldName)) {
        return dataList[currentRecord][fieldName].runtimeType.toString();
      }
    }
    return null;
  }

  @override
  dynamic fieldValue(final String fieldName) {
    if (dataList[currentRecord].isNotEmpty) {
      if (dataList[currentRecord].containsKey(fieldName)) {
        return dataList[currentRecord][fieldName];
      }
    }
    return null;
  }

  @override
  bool notEof() => (currentRecord == dataList.length - 1);

  @override
  int recordCount() => dataList.length;

  @override
  void first() => currentRecord = 0;

  @override
  void last() => currentRecord = dataList.length - 1;

  @override
  void next() => currentRecord++;

  @override
  void prior() => currentRecord--;
}
