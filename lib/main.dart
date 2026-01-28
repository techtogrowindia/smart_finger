import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:smart_finger/core/firebase/app_navigator.dart';

import 'package:smart_finger/core/firebase/firebase_options.dart';
import 'package:smart_finger/core/service_locator.dart' as di;
import 'package:smart_finger/presentation/cubit/complaints/complaint_cubit.dart';
import 'package:smart_finger/presentation/cubit/forgot_password/forgot_password_cubit.dart';
import 'package:smart_finger/presentation/cubit/invoice/invoice_cubit.dart';
import 'package:smart_finger/presentation/cubit/login/login_cubit.dart';
import 'package:smart_finger/presentation/cubit/notifications/notification_cubit.dart';
import 'package:smart_finger/presentation/cubit/otp/otp_cubit.dart';
import 'package:smart_finger/presentation/cubit/products/product_cubit.dart';
import 'package:smart_finger/presentation/cubit/profile/bank_cubit.dart';
import 'package:smart_finger/presentation/cubit/profile/profile_cubit.dart';
import 'package:smart_finger/presentation/cubit/tracking/tracking_cubit.dart';
import 'package:smart_finger/presentation/cubit/withdrawl/withdrawl_cubit.dart';
import 'package:smart_finger/presentation/screens/common/location_background_scree.dart';
import 'package:smart_finger/presentation/screens/common/splash_sccreen.dart';
import 'package:smart_finger/core/firebase/firebase_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase init
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Register background handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Dependency injection
  await di.init();

  // Initialize notifications 🔥
  await FirebaseNotificationService.init();

  // Background service
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: false,
    ),
    iosConfiguration: IosConfiguration(autoStart: false, onForeground: onStart),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<LoginCubit>()),
        BlocProvider(create: (_) => di.sl<ProfileCubit>()),
        BlocProvider(create: (_) => di.sl<ComplaintsCubit>()),
        BlocProvider(create: (_) => di.sl<OtpCubit>()),
        BlocProvider(create: (_) => di.sl<TrackingCubit>()),
        BlocProvider(create: (_) => di.sl<BankCubit>()),
        BlocProvider(create: (_) => di.sl<WithdrawalCubit>()),
        BlocProvider(create: (_) => di.sl<NotificationCubit>()),
        BlocProvider(create: (_) => di.sl<ProductCubit>()),
        BlocProvider(create: (_) => di.sl<ForgotPasswordCubit>()),
        BlocProvider(create: (_) => di.sl<InvoiceCubit>()),
        

      ],
      child:  MaterialApp(
        navigatorKey: AppNavigator.navigatorKey,
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
