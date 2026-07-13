class Payment {
  final String id;
  final String workspaceId;
  final String personId;
  final double amount;
  final DateTime dueDate;
  final String status;

  Payment({
    required this.id,
    required this.workspaceId,
    required this.personId,
    required this.amount,
    required this.dueDate,
    required this.status,
  });
}
