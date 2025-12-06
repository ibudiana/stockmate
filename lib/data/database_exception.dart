import 'package:inventory/data/app_execption.dart';

class DatabaseExceptionApp extends AppException {
  DatabaseExceptionApp([String? msg]) : super(msg, 'Database error!');
}

class DatabaseOpenException extends AppException {
  DatabaseOpenException([String? msg]) : super(msg, 'Failed to open database!');
}

class DatabaseQueryException extends AppException {
  DatabaseQueryException([String? msg]) : super(msg, 'Query execution failed!');
}

class DatabaseNotFoundException extends AppException {
  DatabaseNotFoundException([String? msg])
    : super(msg, 'Table or data not found!');
}

class DatabaseInsertException extends AppException {
  DatabaseInsertException([String? msg]) : super(msg, 'Failed to insert data!');
}

class DatabaseUpdateException extends AppException {
  DatabaseUpdateException([String? msg]) : super(msg, 'Failed to update data!');
}

class DatabaseDeleteException extends AppException {
  DatabaseDeleteException([String? msg]) : super(msg, 'Failed to delete data!');
}

class DatabaseCloseException extends AppException {
  DatabaseCloseException([String? msg])
    : super(msg, 'Failed to close database!');
}
