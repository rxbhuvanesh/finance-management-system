class Payment {
  final int id;
  final int loanId;
  final double amount;
  final String paidOn;

  Payment({required this.id, required this.loanId, required this.amount, required this.paidOn});

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json['id'],
        loanId: json['loan_id'],
        amount: (json['amount'] as num).toDouble(),
        paidOn: json['paid_on'],
      );
}
