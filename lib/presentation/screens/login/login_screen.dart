// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_finger/core/colors.dart';
import 'package:smart_finger/core/shared_prefs_helper.dart';
import 'package:smart_finger/presentation/cubit/login/login_cubit.dart';
import 'package:smart_finger/presentation/cubit/login/login_state.dart';
import 'package:smart_finger/presentation/screens/common/exit_dialog.dart';
import 'package:smart_finger/presentation/screens/common/no_internet_screen.dart';
import 'package:smart_finger/presentation/screens/home/home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  bool passwordVisible = false;
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final creds = await SharedPrefsHelper.getCredentials();
    phoneCtrl.text = creds["phone"];
    passCtrl.text = creds["password"];
    setState(() {
      rememberMe = creds["remember"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await ExitConfirmation.show(
          context,
          message: 'Do you want to exit the app?',
          title: 'Exit App',
          closeApp: true,
        );
        return false;
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff2d0463), Color(0xff6705c1), Color(0xffb180ff)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: BlocConsumer<LoginCubit, LoginState>(
                  listener: (context, state) async {
                    if (state is LoginSuccess) {
                      await SharedPrefsHelper.saveCredentials(
                        phoneCtrl.text.trim(),
                        passCtrl.text.trim(),
                        rememberMe,
                      );

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomePage()),
                      );
                    } else if (state is LoginFailure) {
                      if (state.message == "NO_INTERNET") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NoInternetScreen(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    }
                  },
                  builder: (context, state) {
                    final cubit = context.read<LoginCubit>();

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 25),
                          const Text(
                            "SmartFingers",
                            style: TextStyle(
                              fontSize: 36,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "The wet-grinder that just works. For you.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 30),
                          const Text(
                            "Log in with the credentials you provided during registration",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 25),

                          ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(25),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.white.withOpacity(0.1),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                ),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: phoneCtrl,
                                        keyboardType: TextInputType.phone,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                        decoration: _inputDecoration(
                                          "Mobile Number",
                                          Icons.phone_android,
                                        ),
                                        validator: (v) {
                                          if (v == null || v.trim().isEmpty) {
                                            return "Enter mobile number";
                                          }
                                          if (!RegExp(
                                            r'^[0-9]{10}$',
                                          ).hasMatch(v)) {
                                            return "Enter valid 10-digit number";
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 20),

                                      TextFormField(
                                        controller: passCtrl,
                                        obscureText: !passwordVisible,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                        decoration: _inputDecoration(
                                          "Password",
                                          Icons.lock,
                                          suffix: IconButton(
                                            icon: Icon(
                                              passwordVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Colors.white70,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                passwordVisible =
                                                    !passwordVisible;
                                              });
                                            },
                                          ),
                                        ),
                                        validator: (v) {
                                          if (v == null || v.isEmpty) {
                                            return "Enter password";
                                          }
                                          if (v.length < 6) {
                                            return "Minimum 6 characters required";
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 15),

                                      // Remember Me
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: rememberMe,
                                            activeColor: Colors.white,
                                            checkColor: Colors.black,
                                            onChanged: (v) {
                                              setState(() => rememberMe = v!);
                                            },
                                          ),
                                          const Text(
                                            "Remember Me",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 25),

                                      SizedBox(
                                        width: double.infinity,
                                        height: 55,
                                        child: ElevatedButton(
                                          onPressed: state is LoginLoading
                                              ? null
                                              : () async {
                                                  if (!_formKey.currentState!
                                                      .validate()) {
                                                    return;
                                                  }

                                                  cubit.login(
                                                    phoneCtrl.text.trim(),
                                                    passCtrl.text.trim(),
                                                  );
                                                },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: Colors.black87,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                          ),
                                          child: state is LoginLoading
                                              ? const CircularProgressIndicator(
                                                  color: AppColors.primary,
                                                )
                                              : const Text(
                                                  "Login",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
    String label,
    IconData icon, {
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white70),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.white30),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.white, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }
}
