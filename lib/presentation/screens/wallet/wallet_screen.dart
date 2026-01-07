import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_finger/core/colors.dart';
import 'package:smart_finger/presentation/cubit/withdrawl/withdrawl_cubit.dart';
import 'package:smart_finger/presentation/cubit/withdrawl/withdrawl_state.dart';

class WalletScreen extends StatefulWidget {
  final String initialBalance;

  const WalletScreen({super.key, required this.initialBalance});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountCtrl = TextEditingController();

  late double _availableBalance;

  int? _lastRequestedAmount;
  String? _lastStatus;

  @override
  void initState() {
    super.initState();
    _availableBalance = _parse(widget.initialBalance);
  }

  @override
  void didUpdateWidget(covariant WalletScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialBalance != widget.initialBalance) {
      _availableBalance = _parse(widget.initialBalance);
    }
  }

  double _parse(String value) {
    return double.tryParse(value.replaceAll(',', '')) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WithdrawalCubit, WithdrawalState>(
      listener: (context, state) {
        if (state is WithdrawalSuccess) {
          setState(() {
            _availableBalance = state.response.data.remainingBalance.toDouble();
            _lastRequestedAmount = state.response.data.requestedAmount;
            _lastStatus = state.response.data.status;
          });

          _amountCtrl.clear();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.response.message),
              backgroundColor: Colors.green,
            ),
          );
        }

        if (state is WithdrawalError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            title: const Text(
              "My Wallet",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: AppColors.primary,
            automaticallyImplyLeading: false,
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            child: Column(
              children: [
                _balanceCard(),

                const SizedBox(height: 10),

                if (_lastRequestedAmount != null) ...[
                  const SizedBox(height: 24),
                  _lastWithdrawalCard(),
                ],
                const SizedBox(height: 24),
                _withdrawForm(state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _balanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, Colors.purpleAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.account_balance_wallet,
            size: 50,
            color: Colors.white,
          ),
          const SizedBox(height: 12),
          const Text(
            "Available Balance",
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 6),
          Text(
            "₹${_availableBalance.toStringAsFixed(2)}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _withdrawForm(WithdrawalState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Withdraw Amount",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _amountCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter amount",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Amount is required";
                }
                final amount = double.tryParse(value);
                if (amount == null || amount <= 0) {
                  return "Enter valid amount";
                }
                if (amount > _availableBalance) {
                  return "Insufficient balance";
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: state is WithdrawalLoading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          context.read<WithdrawalCubit>().submitWithdrawal(
                            int.parse(_amountCtrl.text),
                          );
                        }
                      },
                child: state is WithdrawalLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Withdraw",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _lastWithdrawalCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Last Withdrawal",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text("Amount: ₹$_lastRequestedAmount"),
          SizedBox(height: 10),
          Text(
            "Status: ${_lastStatus!}",
            style: TextStyle(color: Colors.orangeAccent),
          ),
        ],
      ),
    );
  }
}
