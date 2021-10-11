import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guardian_teacher/Providers/announcement_provider.dart';
import 'package:guardian_teacher/Providers/assignment_provider.dart';
import 'package:guardian_teacher/Providers/todyclass_provider.dart';
import 'package:provider/provider.dart';


import 'Helpers/auth_service.dart';
import 'Meeting/meeting_main.dart';
import 'Providers/global_provider.dart';
import 'Providers/teacher_provider.dart';
import 'Providers/time_table_provider.dart';
import 'Screens/LoginScreen/Components/login_screen.dart';
import 'Screens/NavScreen/Component/nav_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  AuthService appAuth = new AuthService();

  Widget _defaultHome = new LoginScreen();

  bool _result = await appAuth.login();
  if (_result) {
    _defaultHome = new NavScreen();
  }
  runApp(MyApp(home: NavScreen(),));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Widget home;

  const MyApp({Key key, this.home}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GlobalProvider()),
        ChangeNotifierProvider(create: (context) => TeacherProvider()),
        ChangeNotifierProvider(create: (context) => TodayClassProvider()),
        ChangeNotifierProvider(create: (context) => AssignmentProvider()),
        ChangeNotifierProvider(create: (context) => AnnouncementProvider()),
        ChangeNotifierProvider(create: (context) => TimeTableProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.brown,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
          .apply(bodyColor: Colors.black87,),
        ),
        home: home,
      ),
    );
  }
}

