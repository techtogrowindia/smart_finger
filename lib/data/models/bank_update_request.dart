class BankUpdateRequest {
  final String bankName;
  final String accountName;
  final String accountNo;
  final String ifsc;
  final String branchName;
  final String upiId;
  final String gpayNumber;

  const BankUpdateRequest({
    required this.bankName,
    required this.accountName,
    required this.accountNo,
    required this.ifsc,
    required this.branchName,
    required this.upiId,
    required this.gpayNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      "bank_name": bankName,
      "account_name": accountName,
      "account_no": accountNo,
      "ifsc": ifsc,
      "branch_name": branchName,
      "upi_id": upiId,
      "gpay_number": gpayNumber,
    };
  }
}
