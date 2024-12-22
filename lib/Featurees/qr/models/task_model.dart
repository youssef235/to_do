class TaskModel {
  final String id;

  final String image;

  final String title;
  final String desc;
  final String priority;
  final String status;
  final String dueDate;

  TaskModel({
    required this.id,
    required this.image,
    required this.title,
    required this.desc,
    required this.priority,
    required this.status,
    required this.dueDate,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['_id'],
      image: json['image'],
      title: json['title'],
      desc: json['desc'],
      priority: json['priority'],
      status: json['status'],
      dueDate: json['updatedAt'],
    );
  }
}
