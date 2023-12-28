/**
 * Created by YHF at 9:25 on 2023-08-04.
 */

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:specialtext/specialtext.dart';
import 'package:specialtext/src/TextStandardAni.dart';
import 'package:specialtext/src/TextAniBase.dart';
import 'package:specialtext/src/TextShowAni.dart';

class TextAniRain extends TextAniBase{
  final Duration duration;
  ShowAniType showAniType = ShowAniType.shake;
  TextAniRain({
    required Alignment position,
    required double rotate,
    TextStyle? textStyle,
    int? startTimeMs,
    this.duration = const Duration(milliseconds: 500),
  }) : super(position,rotate,startTimeMs,textStyle,);

  List<Widget> list = [];
  late List<Animation<double>> _slideInList;
  late Animation<double> _fadeOut;


  @override
  void initParameter({TextAniBase? first}) {
    initWordList();
  }

  @override
  void setAnimation(AnimationController controller, Duration groupDuration) {
    if(startTimeMs!+duration.inMilliseconds>groupDuration.inMilliseconds){
      startTimeMs = groupDuration.inMilliseconds - duration.inMilliseconds;
    }
    generalInterval(duration,groupDuration);//计算一个group进入动画和退出动画的开始结束interval值（0~1）

    Random _random = Random();
    _slideInList = [];
    for(int i=0;i<list.length;i++){
      int pointStartTime = _random.nextInt(1000);
      double startInterval = msToInterval(startTimeMs!+pointStartTime, groupDuration);
      double endInterval = msToInterval(startTimeMs!+pointStartTime+duration.inMilliseconds, groupDuration);
      Animation<double> slidein = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Interval(startInterval, endInterval, curve: Curves.bounceOut),
        ),
      );
      _slideInList.add(slidein);
    }


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

    List<Widget> widgetList = [];

    for(int i=0;i<list.length;i++){
      widgetList.add(Transform.translate(
        offset: Offset(0,-_slideInList[i].value*500),
        child: list[i],
      ));
    }

    return FadeTransition(
      opacity: _fadeOut,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: widgetList,
      ),
    );
  }

  @override
  Widget getChild(){
    return Text(text,style: style);
  }

  List<Widget> initWordList(){
    list.clear();
    text.characters.forEach((element) {
      list.add(Text(element,style: style));
    });

    return list;
  }
}