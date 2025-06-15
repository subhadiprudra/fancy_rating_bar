enum ResponseType {
  rated,
  openedStoreToRate,
  skippedStoreRating,
  closedDialog,
  unknown
}

class Response {
  int rating;
  ResponseType type;
  String? message;

  Response({
    required this.rating,
    this.message,
    required this.type,
  });

  String toJson() {
    return '{"Rating": $rating, "type": "${type.toString().split('.').last}", "message": "$message"}';
  }
}
