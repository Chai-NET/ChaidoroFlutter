import 'package:chaidoro20/stats_page.dart';
import 'package:chaidoro20/timer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'tasks_page.dart';
import 'Providers/db_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = DbProvider.instance.initializeDb();
  // await DbProvider.instance.insertTask(Task( title: "emptyTask", dateCreated: DateTime.now(), id: 0 ));
  // print ((await DbProvider.instance.tasks()).first);

  // `final db =  await openDatabase(
  //   join( await getDatabasesPath(), 'task_database.db'),
  //   onCreate: (Database db, int version) {return db.execute("CREATE TABLE tasks(id INTEGER PRIMARY KEY, name TEXT, seconds INTEGER, date TEXT");},
  //   version: 1,
  // );`
  runApp(const MyApp());
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if(!currentFocus.hasPrimaryFocus){
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        navigatorObservers: [routeObserver],
        onGenerateRoute: (settings){
          switch(settings.name){
            case "stats" : {
              return PageRouteBuilder(
                settings: settings,
                pageBuilder: (context,animation,secondaryAnimation) => const StatsPage(),
                transitionsBuilder: (context,animation,secondaryAnimation, child){
                  const begin = Offset(0,-1);
                  const end = Offset.zero;
                  const curve = Curves.ease;
                  var tween = Tween(begin:begin,end:end).chain(CurveTween(curve: curve));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                }
              );
            }
            case "tasks" : {
              return PageRouteBuilder(
                  settings: settings,
                  pageBuilder: (context,animation,secondaryAnimation) => const TaskPage(),
                  transitionsBuilder: (context,animation,secondaryAnimation, child){
                    const begin = Offset(1,0);
                    const end = Offset.zero;
                    const curve = Curves.ease;
                    var tween = Tween(begin:begin,end:end).chain(CurveTween(curve: curve));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  }
              );
            }
            case " " : {
      
            }
          }
        },
        title: 'Chaidoro',
        theme: ThemeData(
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;
    EdgeInsets padding = MediaQuery
        .of(context)
        .viewPadding;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 218, 210, 1),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints){
          if( width > 380 ){
            return _largeBuild(height , width , padding);
          } else {
            return _smallBuild( height , width , padding);
          }
        },
      )
    );
  }

  Widget _largeBuild(double height, double width, EdgeInsets padding) {
    double slide = 0;
    return Center(
      child: Container(
        padding: EdgeInsets.only(
            top: padding.top,bottom: padding.bottom
        ),
        child: const TimerPage(),
      )
    );
  }
  Widget _smallBuild(double height, double width, EdgeInsets padding) {
    return Center(
        child: Container(
          padding: EdgeInsets.only(top: padding.top,bottom: padding.bottom),
          child: const TimerPage(),
        )
    );
  }
}
