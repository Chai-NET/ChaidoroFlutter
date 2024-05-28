import 'dart:math';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../Assets/svgs.dart';
import '../Providers/db_provider.dart';
class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();


  static int numberOfDaysInAMonth(DateTime date){
    switch ( date.month ){
      case 1 : {
        return 31;
      }
      case 2 : {
        if(date.year==2024||(date.year-2024)%4==0){
          return 29;
        }else{
          return 28;
        }
      }
      case 3 : {
        return 31;
      }
      case 4 : {
        return 30;
      }
      case 5 : {
        return 31;
      }
      case 6 : {
        return 30;
      }
      case 7 : {
        return 31;
      }
      case 8 : {
        return 31;
      }
      case 9 : {
        return 30 ;
      }
      case 10 : {
        return 31;
      }
      case 11 : {
        return 30;
      }
      case 12 : {
        return 31;
      }
      default: return 31;
    }
  }
  static String secondsFormatter( int seconds ){
    String finalString = "00:00";
    if(seconds>36000){
      if(seconds%3600~/60>9){
        if(seconds%60>9){
          finalString = "${seconds ~/ 3600}:${seconds%3600~/60}:${seconds%60}";
        }else{
          finalString = "${seconds ~/ 3600}:${seconds%3600~/60}:0${seconds%60}";
        }
      }else{
        if(seconds%60>9){
          finalString = "${seconds ~/ 3600}:0${seconds%3600~/60}:${seconds%60}";
        }else{
          finalString = "${seconds ~/ 3600}:0${seconds%3600~/60}:0${seconds%60}";
        }
      }
    }else if(seconds<3600){
      if(seconds~/60>9){
        if(seconds%60>9){
          finalString = "${seconds%3600~/60}:${seconds%60}";
        }else{
          finalString = "${seconds%3600~/60}:0${seconds%60}";
        }
      }else{
        if(seconds%60>9){
          finalString = "0${seconds%3600~/60}:${seconds%60}";
        }else{
          finalString = "0${seconds%3600~/60}:0${seconds%60}";
        }
      }
    }else{
      if(seconds%3600~/60>9){
        if(seconds%60>9){
          finalString = "0${seconds ~/ 3600}:${seconds%3600~/60}:${seconds%60}";
        }else{
          finalString = "0${seconds ~/ 3600}:${seconds%3600~/60}:0${seconds%60}";
        }
      }else{
        if(seconds%60>9){
          finalString = "0${seconds ~/ 3600}:0${seconds%3600~/60}:${seconds%60}";
        }else{
          finalString = "0${seconds ~/ 3600}:0${seconds%3600~/60}:0${seconds%60}";
        }
      }
    }
    return finalString;
  }
  static String numericDateTimeFormatter( DateTime date){
    return "${(date.day<10)? "0${date.day}": date.day}/${(date.month<10)? "0${date.month}" : date.month}/${date.year%100}";
  }
  static String dateTimeFormatter (DateTime date){
    String month = "";
    String weekday = "";
    switch(date.month) {
      case DateTime.january :
        {
          month = "January";
        }
        break;
      case DateTime.february :
        {
          month = "Febuary";
        }
        break;
      case DateTime.march :
        {
          month = "March";
        }
        break;
      case DateTime.april :
        {
          month = "April";
        }
        break;
      case DateTime.may :
        {
          month = "May";
        }
        break;
      case DateTime.june :
        {
          month = "June";
        }
        break;
      case DateTime.july :
        {
          month = "July";
        }
        break;
      case DateTime.august :
        {
          month = "August";
        }
        break;case DateTime.september :
      {
        month = "September";
      }
      break;case DateTime.october:
      {
        month = "October";
      }
      break;
      case DateTime.november :
        {
          month = "November";
        }
        break;
      case DateTime.december:
        {
          month = "December";
        }
        break;
    }
    switch(date.weekday) {

      case DateTime.monday :
        {
          weekday = "Monday";
        }
        break;
      case DateTime.tuesday :
        {
          weekday = "Tuesday";
        }
        break;
      case DateTime.wednesday :
        {
          weekday= "Wednesday";
        }
        break;
      case DateTime.thursday :
        {
          weekday = "Thursday";
        }
        break;
      case DateTime.friday :
        {
          weekday = "Friday";
        }
        break;
      case DateTime.saturday :
        {
          weekday = "Saturday";
        }
        break;
      case DateTime.sunday :
        {
          weekday = "Sunday";
        }
        break;
    }
    return "$month ${date.day}, $weekday";
  }
}

class _CalendarState extends State<Calendar> with SingleTickerProviderStateMixin{
  late AnimationController _controller ;
  late Animation<double> _spin ;
  late Animation<double> _cardSpinAnimationAngleP1;
  late Animation<double> _cardSpinAnimationAngleP2;
  late PageController _pageController;
  DateTime selectedDay = DateTime.now();
  int selectedDaySeconds = 0;
  int selectedDayTasks = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this
    );
    _cardSpinAnimationAngleP1 = Tween<double>(begin: 0,end: pi/2).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.0,0.5,curve: Curves.ease)));
    _cardSpinAnimationAngleP2 = Tween<double>(begin: pi/2,end: 0).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.5,1.0,curve: Curves.ease)));
    _controller.addListener(() {
      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: GestureDetector(
              onTap: (){
                _pageController.previousPage(duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
              },
              child: Container(
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(127,95,83,1),
                    borderRadius: BorderRadius.only(topLeft:  Radius.circular(15),bottomLeft: Radius.circular(15))
                ),
                height: 120,
                width: 50,
                padding: EdgeInsets.all(15),
                child: ArrowLeftWhite(),
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: (){
              if(_controller.isCompleted){
                _controller.reverse();
              }else{
                _controller.forward();
              }
            },
            child: Container(
              width: 250,
              height: 200,
              child: Stack(
                children: [
                  const SizedBox(
                    width: 250,
                    height: 200,
                  ),
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationX(_cardSpinAnimationAngleP1.value),
                    child: Container(
                      width: 250,
                      height: 200,
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(199, 160, 143, 1),
                          borderRadius:  BorderRadius.all(Radius.circular(17),
                          )
                      ),
                      padding: EdgeInsets.all(12),
                      child: TableCalendar(
                        headerVisible: false,
                        shouldFillViewport: true ,
                        firstDay: DateTime.utc(2010, 10, 16),
                        lastDay: DateTime.utc(2030, 3, 14),
                        focusedDay: DateTime.now(),
                        availableGestures: AvailableGestures.horizontalSwipe,
                        onCalendarCreated: (pageController){
                          _pageController=pageController;
                        },
                        calendarFormat: CalendarFormat.month,
                        onDayLongPressed: (day,dateTime) async {
                          selectedDay=day;
                          selectedDaySeconds = await DbProvider.instance.dailyTotalSeconds(day);
                          selectedDayTasks = await DbProvider.instance.dailyTotalTasks(day);
                          _controller.forward();
                        },
                        calendarStyle: const CalendarStyle(
                            cellMargin: EdgeInsets.all(2),
                            cellPadding: EdgeInsets.all(4),
                            todayTextStyle:  TextStyle(color:  Color.fromRGBO(247, 218, 210, 1), fontSize: 16.0),
                            todayDecoration:  BoxDecoration(color:   Color.fromRGBO(127,95,83,1), shape: BoxShape.circle)
                        ),
                        calendarBuilders: CalendarBuilders(

                            todayBuilder: (context,day,focusedDay) {
                              Future<int> seconds = DbProvider.instance.dailyTotalSeconds(day);
                              return FutureBuilder(
                                  future: seconds,
                                  builder: (BuildContext context, AsyncSnapshot<int> snapshot){
                                    if(!snapshot.hasData||snapshot.data==0){
                                      return Container(
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                          color:   Color.fromRGBO(247, 218, 210, 1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text("${day.day}",style: TextStyle(color:  const Color.fromRGBO(127,95,83,1),fontWeight: FontWeight.w700),),
                                      );
                                    }
                                    if(snapshot.data!>0){
                                      return Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color:  const Color.fromRGBO(247, 218, 210, 1),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color:  const Color.fromRGBO(127,95,83,1),
                                                width: 4,
                                                strokeAlign: BorderSide.strokeAlignInside
                                            )
                                        ),
                                        child: Text("${day.day}",style: TextStyle( color: const Color.fromRGBO(127,95,83,1),fontWeight: FontWeight.w800),),
                                      );
                                    }else{
                                      return Container(
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                          color:   Color.fromRGBO(247, 218, 210, 1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text("${day.day}",style: TextStyle(color:  const Color.fromRGBO(127,95,83,1),fontWeight: FontWeight.w700),),
                                      );
                                    }
                                  });
                            } ,
                            defaultBuilder: (context,day,focusedDay){
                              Future<int> seconds = DbProvider.instance.dailyTotalSeconds(day);
                              return FutureBuilder(
                                future: seconds,
                                builder: (BuildContext context, AsyncSnapshot<int> snapshot){
                                  if(!snapshot.hasData||snapshot.data==0){
                                    return Container(
                                      alignment: Alignment.center,
                                      child: Text("${day.day}",style: TextStyle(color:  const Color.fromRGBO(127,95,83,1),fontWeight: FontWeight.w700,)),
                                    );
                                  }
                                  if(snapshot.data!>0){
                                    return Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color:  const Color.fromRGBO(127,95,83,1),
                                              width: 4,
                                              strokeAlign: BorderSide.strokeAlignInside
                                          )
                                      ),
                                      child: Text("${day.day}",style: TextStyle(color: const Color.fromRGBO(247, 218, 210, 1),fontWeight: FontWeight.w700,),),
                                    );
                                  }else{
                                    return Container(
                                      alignment: Alignment.center,
                                      child: Text("${day.day}",style: TextStyle(color:  const Color.fromRGBO(127,95,83,1),fontWeight: FontWeight.w700,)),
                                    );
                                  }
                                },
                              );
                            },
                            outsideBuilder: (context,day,focusedDay){
                              return Container(
                                alignment: Alignment.center,
                                child: Text("${day.day}",style: TextStyle(color: const Color.fromRGBO(247, 218, 210, 1),fontWeight: FontWeight.w700,)),
                              );
                            }
                        ),
                      ),
                      //functional calendar with stats from backend
                      // child: Calendar(),
                    ),
                  ),
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationX(_cardSpinAnimationAngleP2.value),
                    child: Container(
                      width: 250,
                      height: 200,
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(199, 160, 143, 1),
                          borderRadius:  BorderRadius.all(Radius.circular(17),
                          )
                      ),
                      padding: const EdgeInsets.only(top: 12,left: 12,right: 12),
                      //information about that day from the backend
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(Calendar.dateTimeFormatter(selectedDay),style: TextStyle(color:  const Color.fromRGBO(247, 218, 210, 1),fontWeight: FontWeight.w700,fontSize: 17)),
                          const SizedBox(height: 5,),
                          Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color:  const Color.fromRGBO(247, 218, 210, 1),
                                  borderRadius: BorderRadius.circular(7)
                              ),
                              child: Text("Stats:",style: TextStyle(color: Color.fromRGBO(199, 160, 143, 1),fontWeight: FontWeight.w700,fontSize: 13))),
                          const SizedBox(height: 5,),
                          Wrap(
                            spacing: 5,
                            children: [
                              infoBox("Time spent",Calendar.secondsFormatter(selectedDaySeconds)),
                              infoBox("Tasks", "$selectedDayTasks"),
                              infoBox("Progress", (selectedDaySeconds>=1500)? "100%" : "${-(selectedDaySeconds/1500)*100/~100}" ),
                            ],
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.bottomCenter,
                              padding: const EdgeInsets.only(bottom: 5),
                              clipBehavior: Clip.none,
                              child: Container(
                                width: 60,
                                height: 6,
                                decoration: BoxDecoration(
                                    color:  const Color.fromRGBO(127,95,83,1),
                                    borderRadius: BorderRadius.circular( 5 )
                                ),
                              ),
                            ),
                          ),
                          //Progress that day ProgressBar()

                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: GestureDetector(
              onTap: (){
                _pageController.nextPage(duration:const Duration(milliseconds: 250), curve: Curves.easeIn);
              },
              child: Container(
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(127,95,83,1),
                    borderRadius: BorderRadius.only(topRight: Radius.circular(15),bottomRight: Radius.circular(15))
                ),
                height: 120,
                width: 50,
                padding:const EdgeInsets.all(15),
                child: ArrowRightWhite(),
              ),
            ),
          )
        ],
      ),
    );
  }
  Widget infoBox(String infoName,String info){
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 6),
        decoration: BoxDecoration(
            color:  const Color.fromRGBO(247, 218, 210, 1),
            borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(infoName, style: const TextStyle(color: Color.fromRGBO(199, 160, 143, 1),fontWeight: FontWeight.w700,fontSize: 15),),
            const SizedBox(height: 3,),
            Text(info, style: const TextStyle(color: Color.fromRGBO(199, 160, 143, 1),fontWeight: FontWeight.w700,fontSize: 11),),
          ],
        ),
      ),
    );
  }


}

class ProgressData {
  static final _progressForDate = <DateTime,int>{
    DateTime.utc(2023, 4, 1) : 500,
    DateTime.utc(2023,4,2) : 800,
    DateTime.utc(2023,4,3) : 300,
    DateTime.utc(2023,4,4) : 1100,
    DateTime.utc(2023,4,7) : 800,
    DateTime.utc(2023,4,8) : 800
  };
  static final _tasksForDate = <DateTime,Map<String,int>>{
    DateTime.utc(2023, 4, 1) : {
      'Playing Piano' : 1233,
      'Developing Software':733
    },
  };
  static void addDate (DateTime date, int secondsWorked) {
    _progressForDate[date] = secondsWorked;
  }
  static void addTaskForDate (DateTime date, String taskName,int seconds) {
    if(_tasksForDate.containsKey(date)){
      _tasksForDate[date]![taskName]=seconds;
    }else{
      _tasksForDate[date] = { taskName : seconds };
    }
  }
  static bool didWorkThatDay(DateTime date){
    return _progressForDate.containsKey(date)? true : false;
  }
  static bool hadTaskThatDay(DateTime date){
    return _tasksForDate.containsKey(date)? true : false;
  }
  static int totalTasksAtDate( DateTime date ){
    if( hadTaskThatDay(date) ) {
      return _tasksForDate[date]!.length;
    }else{
      return 0 ;
    }
  }
  static int totalSecondsAtDate( DateTime date ){
    if( didWorkThatDay(date) ) {
      return _progressForDate[date]!;
    }else{
      return 0 ;
    }
  }
  static int streakCount( DateTime date , int counter){
    DateTime previousDate;
    if(date.day<1){
      previousDate = DateTime.utc(date.year,date.month-1,numberOfDaysInAMonth(DateTime.utc(date.year,date.month-1)));
    }else{
      previousDate = DateTime.utc(date.year,date.month,date.day-1);
    }
    if(didWorkThatDay(date)){
      counter++;
      return streakCount(previousDate, counter);
    }else{
      return counter;
    }
  }

  static int numberOfDaysInAMonth(DateTime date){
    switch ( date.month ){
      case 1 : {
        return 31;
      }
      case 2 : {
        if(date.year==2024||(date.year-2024)%4==0){
          return 29;
        }else{
          return 28;
        }
      }
      case 3 : {
        return 31;
      }
      case 4 : {
        return 30;
      }
      case 5 : {
        return 31;
      }
      case 6 : {
        return 30;
      }
      case 7 : {
        return 31;
      }
      case 8 : {
        return 31;
      }
      case 9 : {
        return 30 ;
      }
      case 10 : {
        return 31;
      }
      case 11 : {
        return 30;
      }
      case 12 : {
        return 31;
      }
      default: return 31;
    }
  }

}