import 'package:get_it/get_it.dart';
import 'package:smart_finger/data/repositories/bank_repository.dart';
import 'package:smart_finger/data/repositories/complaint_repository.dart';
import 'package:smart_finger/data/repositories/forgot_password_repository.dart';
import 'package:smart_finger/data/repositories/invoice_repository.dart';
import 'package:smart_finger/data/repositories/login_repository.dart';
import 'package:smart_finger/data/repositories/notification_repository.dart';
import 'package:smart_finger/data/repositories/otp_repository.dart';
import 'package:smart_finger/data/repositories/product_repository.dart';
import 'package:smart_finger/data/repositories/profile_repository.dart';
import 'package:smart_finger/data/repositories/tracking_repository.dart';
import 'package:smart_finger/data/repositories/withdrawl_repository.dart';
import 'package:smart_finger/data/services/bank_service.dart';
import 'package:smart_finger/data/services/complaint_service.dart';
import 'package:smart_finger/data/services/forgot_password_service.dart';
import 'package:smart_finger/data/services/invoice_service.dart';
import 'package:smart_finger/data/services/login_service.dart';
import 'package:smart_finger/data/services/notification_service.dart';
import 'package:smart_finger/data/services/otp_service.dart';
import 'package:smart_finger/data/services/product_service.dart';
import 'package:smart_finger/data/services/profile_service.dart';
import 'package:smart_finger/data/services/tracking_service.dart';
import 'package:smart_finger/data/services/withdrawl_service.dart';
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

final sl = GetIt.instance;

Future<void> init() async {
  // Login
  sl.registerLazySingleton<LoginService>(() => LoginService());

  sl.registerLazySingleton<LoginRepository>(() => LoginRepository(sl()));

  sl.registerFactory<LoginCubit>(() => LoginCubit(sl<LoginRepository>()));

  //Profile

  sl.registerLazySingleton<ProfileService>(() => ProfileService());

  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepository(sl()));

  sl.registerFactory<ProfileCubit>(() => ProfileCubit(sl<ProfileRepository>()));

  //Complaints

  sl.registerLazySingleton<ComplaintsService>(() => ComplaintsService());

  sl.registerLazySingleton<ComplaintsRepository>(
    () => ComplaintsRepository(sl()),
  );

  sl.registerFactory<ComplaintsCubit>(
    () => ComplaintsCubit(sl<ComplaintsRepository>()),
  );

  //OTP

  sl.registerLazySingleton<OtpService>(() => OtpService());

  sl.registerLazySingleton<OtpRepository>(() => OtpRepository(sl()));

  sl.registerFactory<OtpCubit>(() => OtpCubit(sl<OtpRepository>()));

  //Tracking

  sl.registerLazySingleton<TrackingService>(() => TrackingService());

  sl.registerLazySingleton<TrackingRepository>(() => TrackingRepository(sl()));

  sl.registerFactory<TrackingCubit>(
    () => TrackingCubit(sl<TrackingRepository>()),
  );

  //Bank

  sl.registerLazySingleton<BankService>(() => BankService());

  sl.registerLazySingleton<BankRepository>(() => BankRepository(sl()));

  sl.registerFactory<BankCubit>(() => BankCubit(sl<BankRepository>()));

  //Withdrawl

  sl.registerLazySingleton<WithdrawalService>(() => WithdrawalService());

  sl.registerLazySingleton<WithdrawalRepository>(
    () => WithdrawalRepository(service: sl()),
  );

  sl.registerFactory<WithdrawalCubit>(
    () => WithdrawalCubit(repository: sl<WithdrawalRepository>()),
  );

  //Notifications

  sl.registerLazySingleton<NotificationService>(() => NotificationService());

  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepository(service: sl()),
  );

  sl.registerFactory<NotificationCubit>(
    () => NotificationCubit(repository: sl<NotificationRepository>()),
  );

  //Products
  sl.registerLazySingleton<ProductApiService>(() => ProductApiService());
  sl.registerLazySingleton<ProductRepository>(() => ProductRepository(sl()));
  sl.registerFactory<ProductCubit>(
    () => ProductCubit(repository: sl<ProductRepository>()),
  );

  //forgot password
  sl.registerLazySingleton<ForgotPasswordService>(
    () => ForgotPasswordService(),
  );
  sl.registerLazySingleton<ForgotPasswordRepository>(
    () => ForgotPasswordRepository(sl()),
  );
  sl.registerFactory<ForgotPasswordCubit>(
    () => ForgotPasswordCubit( sl<ForgotPasswordRepository>()),
  );

  // invoice

  sl.registerLazySingleton<InvoiceService>(() => InvoiceService());
  sl.registerLazySingleton<InvoiceRepository>(() => InvoiceRepository(sl()));
  sl.registerFactory<InvoiceCubit>(() => InvoiceCubit(sl<InvoiceRepository>()));

}
