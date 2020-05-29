class HttpExpcetion implements Exception {
  String message;
  
  HttpExpcetion(this.message);

  @override
  String toString() {
    return message;
  }
}
