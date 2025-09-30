class FormFieldModel {
  final String key;
  final String type;
  final List<String>? options;
  String? value;

  FormFieldModel({
    required this.key,
    required this.type,
    this.options,
    this.value,
  });

  factory FormFieldModel.fromJson(String key, Map<String, dynamic> json) {
    return FormFieldModel(
      key: key,
      type: json['type'] as String,
      options: json['options']?.cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'type': type,
      'options': options,
      'value': value,
    };
  }
}

class FormSubmission {
  final String id;
  final Map<String, String> values;
  final DateTime submittedAt;

  FormSubmission({
    required this.id,
    required this.values,
    required this.submittedAt,
  });

  factory FormSubmission.fromJson(Map<String, dynamic> json) {
    return FormSubmission(
      id: json['id'] as String,
      values: Map<String, String>.from(json['values']),
      submittedAt: DateTime.parse(json['submittedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'values': values,
      'submittedAt': submittedAt.toIso8601String(),
    };
  }
}
