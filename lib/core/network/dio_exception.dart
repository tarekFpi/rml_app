import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class DioException implements Exception {
  late String errorMessage;

  DioException.fromDioError(DioError dioError) {
    switch (dioError.type) {
      case DioErrorType.cancel:
        errorMessage = 'Request to the server was cancelled.';
        break;
      case DioErrorType.connectTimeout:
        errorMessage = 'Connection timed out.';
        break;
      case DioErrorType.receiveTimeout:
        errorMessage = 'Receiving timeout occurred.';
        break;
      case DioErrorType.sendTimeout:
        errorMessage = 'Request send timeout.';
        break;
      case DioErrorType.response:
        errorMessage = _handleStatusCode(
            dioError.response?.statusCode, dioError.response?.data);
        break;
      case DioErrorType.other:
        if (dioError.message.contains('SocketException')) {
          errorMessage = 'No Internet.';
          break;
        }
        errorMessage = 'Unexpected error occurred.';
        break;
      default:
        errorMessage = 'Something went wrong';
        break;
    }
  }

  String _handleStatusCode(int? statusCode, dynamic) {
    debugPrint("Status code : $statusCode");
    switch (statusCode) {
      case 302:
        try {
          return dynamic['Error']["Description"];
        } catch (e) {
          return 'Redirect';
        }
      case 400:
        try {
          return dynamic['Error']["Description"];
        } catch (e) {
          return 'Bad request.';
        }
      case 401:
        try {
          return dynamic['Error']["Description"];
        } catch (e) {
          return 'Authentication failed.';
        }
      case 403:
        try {
          return dynamic['Error']["Description"];
        } catch (e) {
          return 'The authenticated user is not allowed to access the specified API endpoint.';
        }
      case 404:
        try {
          return dynamic['Error']["Description"];
        } catch (e) {
          return 'The requested resource does not exist.';
        }
        ;
      case 405:
        try {
          return dynamic['Error']["Description"];
        } catch (e) {
          return 'Method not allowed. Please check the Allow header for the allowed HTTP methods.';
        }
      case 415:
        try {
          return dynamic['Error']["Description"];
        } catch (e) {
          return 'Unsupported media type. The requested content type or version number is invalid.';
        }
      case 422:
        try {
          return dynamic['Error']["Description"];
        } catch (e) {
          return 'Data validation failed.';
        }
      case 429:
        try {
          return dynamic['Error']["Description"];
        } catch (e) {
          return 'Too many requests.';
        }
      case 500:
        try {
          return dynamic['Error']["Description"];
        } catch (e) {
          return 'Internal server error.';
        }
      default:
        return 'Oops something went wrong!';
    }
  }

  @override
  String toString() => errorMessage;
}
