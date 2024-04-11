import 'package:flutter/material.dart';

String numericDateTimeFormatter( DateTime date){
  return "${(date.day<10)? "0${date.day}": date.day}/${(date.month<10)? "0${date.month}" : date.month}/${date.year%100}";
}
String dateTimeFormatter (DateTime date){
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

class CustomListTile extends StatelessWidget{
  final Widget title;
  final EdgeInsets? padding;
  final Text? subtitle;
  final Text? subSubtitle;
  final Widget? trailing;
  final Widget? leading;
  const CustomListTile({
    super.key,
    this.padding,
    required this.title,
    this.subtitle,
    this.trailing,
    this.leading,
    this.subSubtitle
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          leading ?? Container(),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                title,
                (subtitle==null) ? Container() : Padding(
                  padding: const EdgeInsets.only(left: 5,top: 3),
                  child: subtitle,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          trailing ?? Container(),
          const SizedBox(width: 10,)

        ],
      ),
    );
  }
}
