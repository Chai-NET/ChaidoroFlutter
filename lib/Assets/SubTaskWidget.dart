import 'package:flutter/material.dart';
import 'package:chaidoro20/db/db_provider.dart';

import '../editing.dart';
class SubTaskWidget extends StatelessWidget {
  final int subtaskId;
  final int taskId;
  final String subtitle;
  final int toggleOn;
  const SubTaskWidget({
    super.key,
    required this.taskId,
    required this.subtaskId,
    required this.subtitle,
    required this.toggleOn,
  });

  @override
  Widget build(BuildContext context) {

    return Dismissible(
        key: UniqueKey(),
        onDismissed: (_) async {
          await DbProvider.instance.deleteSubTask(subtaskId);
        },
        background: Container(
          color: Colors.red,
        ),
        child: CustomListTile(
          leading: GestureDetector(
            onTap:  () {
              DbProvider.instance.updateSubtask(subtaskId, (toggleOn - 1)*(toggleOn - 1), "");
              },
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                  color: ((toggleOn==1) ? Colors.black : null),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all( color: Colors.black, width: 1.5 )
              ),
            ),
          ),
          title:  GestureDetector(
              onTap: (){
                EditController.instance.editController.add(MapEntry(taskId, subtaskId));
              },
              child: Text(subtitle,style: const TextStyle( fontSize: 23,fontWeight: FontWeight.w400,color: Colors.black,height: 1.0),)),
        )

    );

  }
}


class CustomListTile extends StatelessWidget{
  final Widget title;
  final EdgeInsets? padding;
  final Text? subSubtitle;
  final Widget? trailing;
  final Widget? leading;
  const CustomListTile({
    super.key,
    this.padding,
    required this.title,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          leading ?? Container(),
          const SizedBox(width: 15),
          Expanded(
            child: title,
          ),
          const SizedBox(width: 10),
          trailing ?? Container(),
          const SizedBox(width: 10,)

        ],
      ),
    );
  }
}

