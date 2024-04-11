import 'package:flutter/material.dart';


Widget ArrowRight() => Container(
  width: 14.5,
  height: 25,
  child: FittedBox(
    fit: BoxFit.fitHeight,
    child: CustomPaint(
      size: const Size(11, 19),
      painter: ArrowRightPainter(),
    ),
  ),
);
//Copy this CustomPainter code to the Bottom of the File
class ArrowRightPainter extends CustomPainter {
@override
void paint(Canvas canvas, Size size) {

Path path_0 = Path();
path_0.moveTo(10.5848,10.2034);
path_0.cubicTo(11.073,9.71522,11.073,8.92376,10.5848,8.43561);
path_0.lineTo(2.62986,0.480653);
path_0.cubicTo(2.14171,-0.00750275,1.35025,-0.00750289,0.862095,0.480652);
path_0.cubicTo(0.373939,0.968808,0.373939,1.76026,0.862094,2.24842);
path_0.lineTo(7.93316,9.31949);
path_0.lineTo(0.862092,16.3906);
path_0.cubicTo(0.373936,16.8787,0.373936,17.6702,0.862091,18.1583);
path_0.cubicTo(1.35025,18.6465,2.1417,18.6465,2.62986,18.1583);
path_0.lineTo(10.5848,10.2034);
path_0.close();
path_0.moveTo(8.70093,10.5695);
path_0.lineTo(9.70093,10.5695);
path_0.lineTo(9.70093,8.06949);
path_0.lineTo(8.70093,8.06949);
path_0.lineTo(8.70093,10.5695);
path_0.close();

Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
paint_0_fill.color = const Color(0xff7F5F53).withOpacity(1.0);
canvas.drawPath(path_0,paint_0_fill);

}

@override
bool shouldRepaint(covariant CustomPainter oldDelegate) {
return true;
}
}

class DragDownPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
    paint_0_fill.color = const Color(0xff7F5F53).withOpacity(1.0);
    canvas.drawCircle(Offset(size.width*0.5000000,size.height*0.3333333),size.width*0.5000000,paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(28,16);
    path_1.cubicTo(28,22.6274,16,48,16,48);
    path_1.cubicTo(16,48,4,22.6274,4,16);
    path_1.cubicTo(4,9.37258,9.37258,4,16,4);
    path_1.cubicTo(22.6274,4,28,9.37258,28,16);
    path_1.close();

    Paint paint_1_fill = Paint()..style=PaintingStyle.fill;
    paint_1_fill.color = const Color(0xff252525).withOpacity(1.0);
    canvas.drawPath(path_1,paint_1_fill);

    Paint paint_2_fill = Paint()..style=PaintingStyle.fill;
    paint_2_fill.color = const Color(0xffF7DAD2).withOpacity(1.0);
    canvas.drawCircle(Offset(size.width*0.5000000,size.height*0.3333333),size.width*0.4062500,paint_2_fill);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

Widget ArrowLeft() => Container(
  width: 14.5,
  height: 25,
  child: FittedBox(
    fit: BoxFit.fitHeight,
    child: CustomPaint(
      size: const Size(11, 19),
      painter: ArrowLeftPainter(),
    ),
  ),
);
//Copy this CustomPainter code to the Bottom of the File
class ArrowLeftPainter extends CustomPainter {
@override
void paint(Canvas canvas, Size size) {

Path path_0 = Path();
path_0.moveTo(0.817044,8.43561);
path_0.cubicTo(0.328889,8.92376,0.328889,9.71522,0.817044,10.2034);
path_0.lineTo(8.772,18.1583);
path_0.cubicTo(9.26015,18.6465,10.0516,18.6465,10.5398,18.1583);
path_0.cubicTo(11.0279,17.6702,11.0279,16.8787,10.5398,16.3906);
path_0.lineTo(3.46869,9.31949);
path_0.lineTo(10.5398,2.24842);
path_0.cubicTo(11.0279,1.76027,11.0279,0.968809,10.5398,0.480654);
path_0.cubicTo(10.0516,-0.0075016,9.26015,-0.0075016,8.772,0.480654);
path_0.lineTo(0.817044,8.43561);
path_0.close();
path_0.moveTo(2.70093,8.06949);
path_0.lineTo(1.70093,8.06949);
path_0.lineTo(1.70093,10.5695);
path_0.lineTo(2.70093,10.5695);
path_0.lineTo(2.70093,8.06949);
path_0.close();

Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
paint_0_fill.color = const Color(0xff7F5F53).withOpacity(1.0);
canvas.drawPath(path_0,paint_0_fill);

}

@override
bool shouldRepaint(covariant CustomPainter oldDelegate) {
return true;
}
}

ArrowLeftWhite() => Container(
  width: 14.5,
  height: 25,
  child: FittedBox(
    fit: BoxFit.fitWidth,
    child: CustomPaint(
      size: const Size(10, 18),
      painter: ArrowLeftWhitePainter(),
    ),
  ),
);
ArrowRightWhite() => Container(
  width: 14.5,
  height: 25,
  child: FittedBox(
    fit: BoxFit.fitWidth,
    child: Transform.flip(
      flipX: true,
      child: CustomPaint(
        size: const Size(10, 18),
        painter: ArrowLeftWhitePainter(),
      ),
    ),
  ),
);
class ArrowLeftWhitePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    Path path_0 = Path();
    path_0.moveTo(size.width*0.8181818,size.height*0.1111111);
    path_0.lineTo(size.width*0.1818182,size.height*0.5000000);
    path_0.lineTo(size.width*0.8181818,size.height*0.8888889);

    Paint paint0Stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.2136364;
    paint0Stroke.color=const Color(0xffFFCFC1).withOpacity(1.0);
    paint0Stroke.strokeCap = StrokeCap.round;
    paint0Stroke.strokeJoin = StrokeJoin.round;
    canvas.drawPath(path_0,paint0Stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//Add this CustomPaint widget to the Widget Tree

Widget plusIcon(){
  return SizedBox(
    width: 25,
    height: 25,
    child: FittedBox(
      fit: BoxFit.fitHeight,
      child: CustomPaint(
        size:const Size(17, 17),
        painter: PlusPainter(),
      ),
    ),
  );
}
//Copy this CustomPainter code to the Bottom of the File
class PlusPainter extends CustomPainter {
@override
void paint(Canvas canvas, Size size) {

Path path_0 = Path();
path_0.moveTo(16.425,9.23182);
path_0.lineTo(8.93699,9.23182);
path_0.lineTo(8.93699,16.7838);
path_0.lineTo(7.56099,16.7838);
path_0.lineTo(7.56099,9.23182);
path_0.lineTo(0.104988,9.23182);
path_0.lineTo(0.104988,8.01582);
path_0.lineTo(7.56099,8.01582);
path_0.lineTo(7.56099,0.463823);
path_0.lineTo(8.93699,0.463823);
path_0.lineTo(8.93699,8.01582);
path_0.lineTo(16.425,8.01582);
path_0.lineTo(16.425,9.23182);
path_0.close();

Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
paint_0_fill.color = Color(0xff252525).withOpacity(1.0);
canvas.drawPath(path_0,paint_0_fill);

}

@override
bool shouldRepaint(covariant CustomPainter oldDelegate) {
return true;
  }
}



Widget smallPlus(){
  return CustomPaint(
    size: Size(11, 11),
    painter: smallPlusPainter(),
  );
}
//Add this CustomPaint widget to the Widget Tree
//Copy this CustomPainter code to the Bottom of the File
class smallPlusPainter extends CustomPainter {
@override
void paint(Canvas canvas, Size size) {

Path path_0 = Path();
path_0.moveTo(10.3734,5.82384);
path_0.lineTo(5.91338,5.82384);
path_0.lineTo(5.91338,10.3238);
path_0.lineTo(4.61338,10.3238);
path_0.lineTo(4.61338,5.82384);
path_0.lineTo(0.173379,5.82384);
path_0.lineTo(0.173379,4.62384);
path_0.lineTo(4.61338,4.62384);
path_0.lineTo(4.61338,0.12384);
path_0.lineTo(5.91338,0.12384);
path_0.lineTo(5.91338,4.62384);
path_0.lineTo(10.3734,4.62384);
path_0.lineTo(10.3734,5.82384);
path_0.close();

Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
paint_0_fill.color = Color(0xff252525).withOpacity(1.0);
canvas.drawPath(path_0,paint_0_fill);

}

@override
bool shouldRepaint(covariant CustomPainter oldDelegate) {
return true;
}
}