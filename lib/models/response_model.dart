class ResponseModel {
  final String text;
  final DateTime timestamp;

  ResponseModel({
    required this.text,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      text: json['response'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}