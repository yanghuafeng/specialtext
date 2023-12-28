/**
 * Created by YHF at 9:25 on 2023-08-04.
 */

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:specialtext/src/TextAniBase.dart';
import 'package:specialtext/src/TextShowAni.dart';

class TextAniTypewriter extends TextAniBase with TextShowAni{

  final Random _random = Random();
  final Duration duration;

  late Curve curve;
  ///结束时缩放的倍数
  late double endscale;
  ///计算占用宽度
  late double width;

  TextAniTypewriter({
    required Alignment position,
    required double rotate,
    TextStyle? textStyle,
    int? startTimeMs,
    this.duration = const Duration(milliseconds: 500),

  }) : super(position,rotate,startTimeMs,textStyle,);

  late Animation<double> textTween;
  late Animation<double> hideScale,hideFade;


  @override
  void initParameter({TextAniBase? first}) {
    rotate = rotate + (_random.nextDouble() * 0.3);
    endscale = _random.nextInt(3) * 3;
    curve = Curves.linear;
    TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(text: text ,style: style), maxLines: 1)..layout();
    width = textPainter.width;
  }

  @override
  void setAnimation(AnimationController controller, Duration groupDuration) {
    if(startTimeMs!+duration.inMilliseconds>groupDuration.inMilliseconds){
      startTimeMs = groupDuration.inMilliseconds - duration.inMilliseconds;
    }
    generalInterval(duration,groupDuration);

    initShowAni(controller);

    textTween = CurveTween(
      curve: Interval(startIntervalBegin, startIntervalEnd, curve: curve),
    ).animate(controller);

    hideScale = Tween<double>(begin: 1, end: endscale).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(endIntervalBegin, 1.0, curve: curve),
      ),
    );
    hideFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(endIntervalBegin, 1.0, curve: curve),
      ),
    );
  }


  @override
  Widget getPartWidgetBuilder(BuildContext context, Widget? child) {
    final count = (textTween.value * text.length).floor();

    assert(count <= text.length);
    double divider = textTween.value - (1/text.length)*count;//单个文字缩放占用的duration,总的为1

    return FadeTransition(
      opacity: hideFade,
      child: Transform.scale(
        scale: hideScale.value,
        child: showAni(SizedBox(
            width: width,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(text.characters.take(count).toString(),style: style),
                Transform.scale(
                    scale: (1-divider*text.length)*3+1,//divider*text.leng=(0~1)
                    child: Text(count==0||count>=text.length?"":text[count],style: style)
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getChild(){
    return Text(text,style: style);
  }
}
