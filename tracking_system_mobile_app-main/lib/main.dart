import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracking_system_mobile_app/app/modules/driver_module/repository/location_repository.dart';
import 'app/app.dart';
import 'firebase_options.dart';

final notificationService =
    NotificationService(FlutterLocalNotificationsPlugin());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return RepositoryProvider.value(
          value: notificationService,
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => DriverHomeCubit(
                  context,
                  LocationServiceRepository(),
                  
                ),
              ),
              BlocProvider(
                create: (context) => StudentHomeCubit(
                  context,
                  LocationServiceRepository(),
                ),
              ),
            ],
            child: MaterialApp(
              initialRoute: Routes.initial,
              onGenerateRoute: RouteGenerator.generateRoute,
              debugShowCheckedModeBanner: false,
              title: 'First Method',
              // You can use the library anywhere in the app even in theme
              theme: ThemeData(
                primarySwatch: Colors.blue,
                useMaterial3: true,
                textTheme:
                    Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
              ),
              home: child,
            ),
          ),
        );
      },
    );
  }
}
