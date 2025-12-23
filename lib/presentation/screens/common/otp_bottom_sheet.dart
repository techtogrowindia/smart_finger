// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_finger/core/colors.dart';
import 'package:smart_finger/presentation/cubit/otp/otp_cubit.dart';
import 'package:smart_finger/presentation/cubit/otp/otp_state.dart';
import 'package:smart_finger/presentation/screens/common/no_internet_screen.dart';

class OtpBottomSheet extends StatefulWidget {
  final VoidCallback onVerified;

  const OtpBottomSheet({super.key, required this.onVerified});

  @override
  State<OtpBottomSheet> createState() => _OtpBottomSheetState();
}

class _OtpBottomSheetState extends State<OtpBottomSheet> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: BlocConsumer<OtpCubit, OtpState>(
        listener: (context, state) async {
          if (state is OtpVerified) {
            Navigator.pop(context);
            context.read<OtpCubit>().reset();
            widget.onVerified();
          }

          if (state is OtpError) {
            Navigator.pop(context);

            if (state.message == "NO_INTERNET") {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NoInternetScreen(),
                ),
              );
              context.read<OtpCubit>().reset();
            }
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "OTP Verification",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    autofocus: true,
                    autovalidateMode:
                        AutovalidateMode.onUserInteraction,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: const InputDecoration(
                      labelText: "Enter OTP",
                      border: OutlineInputBorder(),
                      counterText: "",
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "OTP is required";
                      }
                      if (value.trim().length != 6) {
                        return "OTP must be 6 digits";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  state is VerifyOtpLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () {
                              if (!_formKey.currentState!.validate()) return;

                              context
                                  .read<OtpCubit>()
                                  .verifyOtp(
                                    _otpController.text.trim(),
                                  );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              "Verify OTP",
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
    );
  }
}
