// ignore_for_file: file_names

class UnsuccessfulRequestException implements Exception {
  String cause = "Unsuccessful request";
  UnsuccessfulRequestException();
}
