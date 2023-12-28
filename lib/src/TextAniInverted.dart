/**
 * Created by YHF at 9:25 on 2023-08-04.
 */
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:specialtext/specialtext.dart';
import 'package:specialtext/src/TextAniBase.dart';

class TextAniInverted extends TextAniBase{
  final Duration duration;
  Curve curve = Curves.bounceOut;
  TextAniInverted({
    required Alignment position,
    required double rotate,
    TextStyle? textStyle,
    int? startTimeMs,
    this.duration = const Duration(milliseconds: 500),
  }) : super(position,rotate,startTimeMs,textStyle,);

  late Animation<Alignment> _slideIn, _invertedSlideIn;
  late Animation<double> _slideOut;


  @override
  void initParameter({TextAniBase? first}) {

  }

  @override
  void setAnimation(AnimationController controller, Duration groupDuration) {
    if(startTimeMs!+duration.inMilliseconds>groupDuration.inMilliseconds){
      startTimeMs = groupDuration.inMilliseconds - duration.inMilliseconds;
    }
    final direction = TextDirection.ltr;
    generalInterval(duration,groupDuration);//计算一个group进入动画和退出动画的开始结束interval值（0~1）

    _slideIn = AlignmentTween(
      begin: Alignment.topCenter.add(position).resolve(direction),
      end: position,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(startIntervalBegin, startIntervalEnd, curve: curve),
      ),
    );

    _invertedSlideIn = AlignmentTween(
      begin: Alignment.bottomCenter.add(position.add(Alignment(0,0))).resolve(direction),
      end: position.add(Alignment(0,0)).resolve(direction),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(startIntervalBegin, startIntervalEnd, curve: curve),
      ),
    );


    double outDuration = msToInterval(groupDuration.inMilliseconds-500, groupDuration);
    _slideOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(outDuration, 1.0, curve: Curves.linear),
      ),
    );

  }


  @override
  Widget getPartWidgetBuilder(BuildContext context, Widget? child) {
    return  Stack(
        children: [
          AlignTransition(
            alignment: _slideIn ,
            child: Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(1),
                origin: const Offset(200,0),
                child: Container(
                    height: 60,
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                        height: 60*_slideOut.value,
                        child: child
                    )
                )
            ),
          ),
          AlignTransition(
            alignment: _invertedSlideIn ,
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(1),
              origin: const Offset(200,0),
              child: getInvertedChild(),
            )
          ),
        ],
      );
  }

  @override
  Widget getChild(){
    return Text(text,style: style);
  }

  getInvertedChild(){
    return Transform(
        transform: Matrix4.identity()
          ..rotateX(pi),
        origin: const Offset(0,64),
        child: Container(
            height: 60,
            alignment: Alignment.bottomCenter,
            child: SizedBox(
                height: 60*_slideOut.value,
                child: Text(text, style: style!.merge(TextStyle(color: style?.color?.withOpacity(0.3)))
                )
            )
        )
    );
  }
}

class RainDrop extends CustomPainter {
  double raintime;
  RainDrop(this.rainList,this.raintime);

  List<RainDropDrawer> rainList = [];
  final Paint _paint =  Paint()..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    rainList.forEach((item) {
      item.drawRainDrop(canvas, _paint,raintime);
    });
    rainList.removeWhere((item) {
      return item.isInValid();
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class RainDropDrawer {
  double posX;
  double posY;
  double radius;
  double drawRadius = 0;

  final double MAX_RADIUS = TextConstant.rainMaxRadius;

  RainDropDrawer(this.posX, this.posY,this.radius);

  drawRainDrop(Canvas canvas, Paint paint,double raintime) {
    drawRadius = radius + MAX_RADIUS*raintime;

    if(drawRadius<0||drawRadius>MAX_RADIUS){
      return;
    }
    double opt = ((MAX_RADIUS - drawRadius) / MAX_RADIUS).clamp(0, 0.6);
    paint.color = Color.fromRGBO(255, 255, 255, opt);
    canvas.drawCircle(Offset(posX, posY), drawRadius, paint);
  }

  bool isInValid() {
    return drawRadius > MAX_RADIUS;
  }
}