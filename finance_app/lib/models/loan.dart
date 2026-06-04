class Loan {
  final int id;
  final int customerId;
  final double principalAmount;
  final double interestPercentage;
  final int emiDurationMonths;
  final int dueDay;
  final String status;

  Loan({required this.id, required this.customerId, required this.principalAmount, required this.interestPercentage, required this.emiDurationMonths, required this.dueDay, required this.status});

  factory Loan.fromJson(Map<String, dynamic> json) => Loan(
        id: json['id'],
        customerId: json['customer_id'],
        principalAmount: (json['principal_amount'] as num).toDouble(),
        interestPercentage: (json['interest_percentage'] as num).toDouble(),
        emiDurationMonths: json['emi_duration_months'],
        dueDay: json['due_day'],
        status: json['status'],
      );
}
