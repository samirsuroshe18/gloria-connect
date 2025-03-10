import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/administration/bloc/administration_bloc.dart';
import 'package:gloria_connect/features/check_in/bloc/check_in_bloc.dart';
import 'package:gloria_connect/features/guard_entry/bloc/guard_entry_bloc.dart';
import 'package:gloria_connect/features/guard_exit/bloc/guard_exit_bloc.dart';
import 'package:gloria_connect/features/guard_profile/bloc/guard_profile_bloc.dart';
import 'package:gloria_connect/features/guard_waiting/bloc/guard_waiting_bloc.dart';
import 'package:gloria_connect/features/invite_visitors/bloc/invite_visitors_bloc.dart';
import 'package:gloria_connect/features/my_visitors/bloc/my_visitors_bloc.dart';
import 'package:gloria_connect/features/notice_board/bloc/notice_board_bloc.dart';
import 'package:gloria_connect/features/resident_profile/bloc/resident_profile_bloc.dart';
import 'package:gloria_connect/features/setting/bloc/setting_bloc.dart';
import 'package:gloria_connect/init_dependencies.dart';
import 'package:gloria_connect/utils/notification_service.dart';
import 'package:gloria_connect/utils/route_observer_with_stack.dart';

import 'config/routes/routes.dart';
import 'config/theme/app_themes.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'firebase_options.dart';

void main() async {

  ///ensureInitialized() is used in the main() to ensure that the Flutter framework is fully initialized before running any code that relies on it.
  WidgetsFlutterBinding.ensureInitialized();

  ///It is used to initialize Firebase in a Flutter app so that we can communicate with firebase.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  ///Initializing notification
  await NotificationController.initializeLocalNotifications();

  ///Dependency Injection.
  await initDependencies();

  runApp(
      MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => serviceLocator<AuthBloc>(),
            ),
            BlocProvider(
              create: (_) => serviceLocator<AdministrationBloc>(),
            ),
            BlocProvider(
              create: (_) => serviceLocator<CheckInBloc>(),
            ),
            BlocProvider(
              create: (_) => serviceLocator<GuardEntryBloc>(),
            ),
            BlocProvider(
              create: (_) => serviceLocator<GuardWaitingBloc>(),
            ),
            BlocProvider(
              create: (_) => serviceLocator<GuardExitBloc>(),
            ),
            BlocProvider(
              create: (_) => serviceLocator<InviteVisitorsBloc>(),
            ),
            BlocProvider(
              create: (_) => serviceLocator<MyVisitorsBloc>(),
            ),
            BlocProvider(
              create: (_) => serviceLocator<GuardProfileBloc>(),
            ),
            BlocProvider(
              create: (_) => serviceLocator<ResidentProfileBloc>(),
            ),
            BlocProvider(
              create: (_) => serviceLocator<SettingBloc>(),
            ),
            BlocProvider(
              create: (_) => serviceLocator<NoticeBoardBloc>(),
            ),
          ],
          child: const MyApp()
      )
  );
}

final RouteObserverWithStack routeObserver = RouteObserverWithStack();

class MyApp extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    NotificationController.isInForeground = true;
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
    );
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      NotificationController.isInForeground = true;
    }
    if(state == AppLifecycleState.paused){
      NotificationController.isInForeground = true;
    }
    if(state == AppLifecycleState.detached){
      NotificationController.isInForeground = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      navigatorKey: MyApp.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Gloria Connect',
      theme: theme(),
      onGenerateRoute: AppRoutes.onGenerateRoutes,
      initialRoute: '/',
    );
  }
}


