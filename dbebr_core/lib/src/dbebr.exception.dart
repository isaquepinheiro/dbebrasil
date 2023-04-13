abstract class DBEBrException extends Exception {
  factory DBEBrException(
          [final String messageshort = '', final String message = '']) =>
      _DBEBrException(messageshort, message);

  String toStringShort();
}

class _DBEBrException implements DBEBrException {
  _DBEBrException(this.messageshort, this.message);
  final String messageshort;
  final String message;

  @override
  String toString() {
    final String message = this.message;
    if (message.isEmpty) return 'Exception';
    return 'HttpException: $message';
  }

  @override
  String toStringShort() {
    final String messageshort = this.messageshort;
    if (messageshort.isEmpty) return 'ExceptionShort';
    return 'HttpException: $messageshort';
  }
}
