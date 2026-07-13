class Notification {
  final String id;
  final String workspaceId;
  final String title;
  final String content;
  final bool read;
  final DateTime createdAt;

  Notification({
    required this.id,
    required this.workspaceId,
    required this.title,
    required this.content,
    required this.read,
    required this.createdAt,
  });
}
