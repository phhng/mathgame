class Classroom {
  Classroom({
    required this.className,
    required this.hostUsername,
  });

  final String? className;
  final String? hostUsername;

  factory Classroom.fromJson(Map<String, dynamic> json){
    return Classroom(
      className: json["className"],
      hostUsername: json["hostUsername"],
    );
  }

  Map<String, dynamic> toJson() => {
    "className": className,
    "hostUsername": hostUsername,
  };
}

class Quiz {
  Quiz({
    required this.question,
    required this.answer,
  });

  final String? question;
  final String? answer;

  factory Quiz.fromJson(Map<String, dynamic> json){
    return Quiz(
      question: json["question"],
      answer: json["answer"],
    );
  }

  Map<String, dynamic> toJson() => {
    "question": question,
    "answer": answer,
  };

}
class Assignment {
  Assignment({
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.attachment,
  });

  final String? title;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? attachment;

  factory Assignment.fromJson(Map<String, dynamic> json){
    return Assignment(
      title: json["title"],
      description: json["description"],
      startDate: DateTime.tryParse(json["startDate"] ?? ""),
      endDate: DateTime.tryParse(json["endDate"] ?? ""),
      attachment: json["attachment"],
    );
  }

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "startDate": startDate?.toIso8601String(),
    "endDate": endDate?.toIso8601String(),
    "attachment": attachment,
  };

}
