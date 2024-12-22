class TodoModel {
  final String? id;
  final String image;
  final String title;
  final String desc;
  final String priority;
  final String status;
  final String dueDate;

  TodoModel({
    this.id,
    required this.image,
    required this.title,
    required this.desc,
    required this.priority,
    required this.status,
    required this.dueDate,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['_id'],
      image: json['image'] ?? 'default_image.png',
      title: json['title'] ?? 'No Title',
      desc: json['desc'] ?? 'No Description',
      priority: json['priority'] ?? 'low',
      status: json['status'] ?? 'waiting',
      dueDate: json['createdAt'] ?? '2024-01-01',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'title': title,
      'desc': desc,
      'priority': priority,
      'status': status,
      'createdAt': dueDate,
    };
  }

  TodoModel copyWith({
    String? id,
    String? image,
    String? title,
    String? desc,
    String? priority,
    String? status,
    String? dueDate,
  }) {
    return TodoModel(
      id: id ?? this.id,
      image: image ?? this.image,
      title: title ?? this.title,
      desc: desc ?? this.desc,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}
