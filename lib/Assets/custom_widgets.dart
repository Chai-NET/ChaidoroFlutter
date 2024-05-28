import 'package:flutter/material.dart';

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
