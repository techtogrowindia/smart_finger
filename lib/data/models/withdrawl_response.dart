class WithdrawalResponse {
  final int statusCode;
  final String status;
  final String message;
  final WithdrawalData data;

  WithdrawalResponse({
    required this.statusCode,
    required this.status,
    required this.message,
    required this.data,
  });

  factory WithdrawalResponse.fromJson(Map<String, dynamic> json) {
    return WithdrawalResponse(
      statusCode: json['status_code'] ?? 0,
      status: json['status'] ?? "",
      message: json['message'] ?? "",
      data: WithdrawalData.fromJson(json['data'] ?? {}),
    );
  }
}

class WithdrawalData {
  final int requestedAmount;
  final int remainingBalance;
  final String status;

  WithdrawalData({
    required this.requestedAmount,
    required this.remainingBalance,
    required this.status,
  });

  factory WithdrawalData.fromJson(Map<String, dynamic> json) {
    return WithdrawalData(
      requestedAmount: json['requested_amount'] ?? 0,
      remainingBalance: json['remaining_balance'] ?? 0,
      status: json['status'] ?? "pending",
    );
  }
}
