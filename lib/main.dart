import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:smart_finger/presentation/cubit/complaints/complaint_cubit.dart';
import 'package:smart_finger/presentation/cubit/login/login_cubit.dart';
import 'package:smart_finger/presentation/cubit/otp/otp_cubit.dart';
import 'package:smart_finger/presentation/cubit/profile/profile_cubit.dart';
import 'package:smart_finger/presentation/cubit/tracking/tracking_cubit.dart';
import 'package:smart_finger/presentation/screens/common/splash_sccreen.dart';

import 'package:smart_finger/core/service_locator.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(create: (_) => di.sl<LoginCubit>()),
        BlocProvider<ProfileCubit>(create: (_) => di.sl<ProfileCubit>()),
        BlocProvider<ComplaintsCubit>(create: (_) => di.sl<ComplaintsCubit>()),
        BlocProvider<OtpCubit>(create: (_) => di.sl<OtpCubit>()),
        BlocProvider<TrackingCubit>(create: (_) => di.sl<TrackingCubit>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
