import 'package:inventory/data/response/status.dart';

class DataResponse<T> {
  final Status status;
  final T? data;
  final String? message;

  DataResponse._({required this.status, this.data, this.message});

  factory DataResponse.loading() => DataResponse._(status: Status.loading);
  factory DataResponse.success(T data) =>
      DataResponse._(status: Status.success, data: data);
  factory DataResponse.error(String message) =>
      DataResponse._(status: Status.error, message: message);

  @override
  String toString() {
    return "Status: $status, Data: $data, Message: $message";
  }
}
