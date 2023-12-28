/**
 * Created by YHF at 9:25 on 2023-08-04.
 */

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:specialtext/src/TextAniBase.dart';
import 'package:specialtext/src/TextShowAni.dart';
import 'package:specialtext/src/TextStandardAni.dart';

class TextAniWave extends TextAniBase with TextStandardAni{

  final Random _random = Random();
  final Duration duration;

  late Animation<double> _fadeOut;
  late Animation<double> _scaleIn, _fadeIn;
  late Animation<double> textTween;
  List<Widget> _childsList = [];
  TextAniWave({
    required Alignment position,
    required double rotate,
    TextStyle? textStyle,
    int? startTimeMs,
    this.duration = const Duration(milliseconds: 1000),

  }) : super(position,rotate,startTimeMs,textStyle,);

  @override
  void initParameter({TextAniBase? first}) {
    rotate = rotate + (_random.nextDouble() * 0.3);

  }

  @override
  void setAnimation(AnimationController controller, Duration groupDuration) {
    if(startTimeMs!+duration.inMilliseconds>groupDuration.inMilliseconds){
      startTimeMs = groupDuration.inMilliseconds - duration.inMilliseconds;
    }
    generalInterval(duration,groupDuration);//计算一个group进入动画和退出动画的开始结束interval值（0~1）


    initTextStandardAni(controller, InAndOutAniType.explosion,
        startIntervalBegin,startIntervalEnd,endIntervalBegin, text,style!);

    _scaleIn = Tween<double>(begin: 0, end: text.length+15).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(startIntervalBegin, startIntervalEnd, curve: Curves.linear),
      ),
    );

    _fadeIn = Tween<double>(begin: 0, end: text.length+15).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(startIntervalBegin, startIntervalEnd, curve: Curves.linear),
      ),
    );


    double outDuration = msToInterval(groupDuration.inMilliseconds-500, groupDuration);

    _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(outDuration, 1.0, curve: Curves.linear),
      ),
    );

  }


  @override
  Widget getPartWidgetBuilder(BuildContext context, Widget? child) {

    initChildList();
    return FadeTransition(
      opacity: _fadeOut,
      child: getStandardAni(SizedBox(child: Row(
            mainAxisSize: MainAxisSize.min,
            children: _childsList,
      ),),),
    );
  }

  @override
  Widget getChild(){
    return Text(text,style: style);
  }

  initChildList(){
    _childsList.clear();
    for(int i=0;i<text.length;i++){
      Widget widget = Transform.scale(
          alignment: Alignment.bottomCenter,
          scale: ((sin((_scaleIn.value.clamp(i, i+15)-i)/15*2.5*pi+1.5*pi+pi/6))+3.5)/4,
          child: Text(text[i], style:style?.merge(TextStyle(
              color: style?.color?.withOpacity((_fadeIn.value.clamp(i, i+15)-i)/15)))
          )
      );
      _childsList.add(widget);
    }

  }

}
