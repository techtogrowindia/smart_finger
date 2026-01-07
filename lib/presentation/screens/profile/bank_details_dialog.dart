import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_finger/core/colors.dart';
import 'package:smart_finger/data/models/bank_update_request.dart';
import 'package:smart_finger/data/models/profile_response.dart';
import 'package:smart_finger/presentation/cubit/profile/bank_cubit.dart';
import 'package:smart_finger/presentation/cubit/profile/bank_state.dart';

class BankDetailsDialog extends StatefulWidget {
  final BankDetails? bank;

  const BankDetailsDialog({super.key, this.bank});

  @override
  State<BankDetailsDialog> createState() => _BankDetailsDialogState();
}

class _BankDetailsDialogState extends State<BankDetailsDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController bankNameCtrl;
  late TextEditingController accountNameCtrl;
  late TextEditingController accountNoCtrl;
  late TextEditingController ifscCtrl;
  late TextEditingController branchCtrl;
  late TextEditingController upiCtrl;
  late TextEditingController gpayCtrl;

  @override
  void initState() {
    super.initState();

    bankNameCtrl = TextEditingController(text: widget.bank?.bankName ?? "");
    accountNameCtrl = TextEditingController(
      text: widget.bank?.accountName ?? "",
    );
    accountNoCtrl = TextEditingController(text: widget.bank?.accountNo ?? "");
    ifscCtrl = TextEditingController(text: widget.bank?.ifsc ?? "");
    branchCtrl = TextEditingController(text: widget.bank?.branchName ?? "");
    upiCtrl = TextEditingController(text: widget.bank?.upiId ?? "");
    gpayCtrl = TextEditingController(text: widget.bank?.gpayNumber ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<BankCubit, BankState>(
          listener: (context, state) {
            if (state is BankSuccess) {
              Navigator.of(context, rootNavigator: true).pop(
                BankDetails(
                  bankName: bankNameCtrl.text,
                  accountName: accountNameCtrl.text,
                  accountNo: accountNoCtrl.text,
                  ifsc: ifscCtrl.text,
                  branchName: branchCtrl.text,
                  upiId: upiCtrl.text,
                  gpayNumber: gpayCtrl.text,
                ),
              );
            }
            if (state is BankError) {
              ScaffoldMessenger.of(
                Navigator.of(context, rootNavigator: true).context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },

          builder: (context, state) {
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Bank Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    _field("Bank Name", bankNameCtrl),
                    _field("Account Name", accountNameCtrl),
                    _field(
                      "Account Number",
                      accountNoCtrl,
                      keyboard: TextInputType.number,
                    ),
                    _field("IFSC Code", ifscCtrl),
                    _field("Branch Name", branchCtrl),
                    _field("UPI ID", upiCtrl),
                    _field(
                      "GPay Number",
                      gpayCtrl,
                      keyboard: TextInputType.phone,
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: state is BankLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<BankCubit>().updateBankDetails(
                                    BankUpdateRequest(
                                      bankName: bankNameCtrl.text,
                                      accountName: accountNameCtrl.text,
                                      accountNo: accountNoCtrl.text,
                                      ifsc: ifscCtrl.text,
                                      branchName: branchCtrl.text,
                                      upiId: upiCtrl.text,
                                      gpayNumber: gpayCtrl.text,
                                    ),
                                  );
                                }
                              },
                        child: state is BankLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Save",
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        validator: (v) => v == null || v.isEmpty ? "Required" : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
