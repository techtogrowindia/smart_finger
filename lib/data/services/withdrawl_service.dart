import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_finger/core/shared_prefs_helper.dart';
import 'package:smart_finger/data/models/withdrawl_response.dart';

class WithdrawalService {
  final String apiUrl =
      "https://sfadmin.in/app/technician/auth/wallet-withdrawal.php";

  Future<WithdrawalResponse> submitWithdrawal(int amount) async {
    final token = await SharedPrefsHelper.getToken();
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({'amount': amount}),
    );

    if (response.statusCode == 200) {
      return WithdrawalResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to submit withdrawal");
    }
  }
}
