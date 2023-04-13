import 'dbebr.factory.interfaces.dart';

class DBField implements IField {
  DBField(this.resultSet) {
    _fieldNameInternal = '';
  }
  final IDBResultSet resultSet;
  late String _fieldNameInternal;

  @override
  IField fieldByName(final String fieldName) {
    _fieldNameInternal = fieldName;
    return this;
  }

  // AsString
  @override
  String get asString => resultSet.fieldValue(_fieldNameInternal).toString();
  @override
  String asStringDef(final String def) => _fieldNameInternal.isEmpty
      ? def
      : resultSet.fieldValue(_fieldNameInternal).toString();

  // AsInteger
  @override
  int get asInteger {
    final String value = resultSet.fieldValue(_fieldNameInternal).toString();
    return int.parse(value.split('.')[0]);
  }

  @override
  int asIntegerDef(final int def) {
    if (_fieldNameInternal.isEmpty) {
      return def;
    }
    final String value = resultSet.fieldValue(_fieldNameInternal).toString();
    return int.parse(value.split('.')[0]);
  }

  // AsDouble
  @override
  double get asDouble =>
      double.parse(resultSet.fieldValue(_fieldNameInternal).toString());
  @override
  double asDoubleDef(final double def) => _fieldNameInternal.isEmpty
      ? def
      : double.parse(resultSet.fieldValue(_fieldNameInternal).toString());

  // AsBoolean
  @override
  bool get asBoolean =>
      bool.hasEnvironment(resultSet.fieldValue(_fieldNameInternal).toString());
  @override
  bool asBooleanDef(final bool def) =>
      bool.fromEnvironment(resultSet.fieldValue(_fieldNameInternal).toString(),
          defaultValue: def);

  // AsDateTime
  @override
  DateTime get asDateTime =>
      DateTime.parse(resultSet.fieldValue(_fieldNameInternal).toString());
  @override
  DateTime asDateTimeDef(final DateTime def) => _fieldNameInternal.isEmpty
      ? def
      : DateTime.parse(resultSet.fieldValue(_fieldNameInternal).toString());
}
