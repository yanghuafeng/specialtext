/**
 * Created by YHF at 9:25 on 2023-08-04.
 */

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:specialtext/src/TextStandardAni.dart';
import 'package:specialtext/src/TextAniBase.dart';

class TextAniMulti extends TextAniBase with TextStandardAni{
  final Duration duration;
  final int totalNum;
  TextAniMulti({
    required Alignment position,
    required double rotate,
    required this.totalNum,
    TextStyle? textStyle,
    int? startTimeMs,
    this.duration = const Duration(milliseconds: 800),
  }) : super(position,rotate,startTimeMs,textStyle,);

  late Animation<double> _fadeIn, _fadeOut;
  late Animation<Alignment> _slide;

  @override
  void initParameter({TextAniBase? first}) {
    // TextAniMulti? s;
    // if(first is TextAniMulti){
    //   s = first;
    // }

  }

  @override
  void setAnimation(AnimationController controller, Duration groupDuration) {
    if(startTimeMs!+duration.inMilliseconds>groupDuration.inMilliseconds){
      startTimeMs = groupDuration.inMilliseconds - duration.inMilliseconds;
    }
    generalInterval(duration,groupDuration);//计算一个group进入动画和退出动画的开始结束interval值（0~1）


    int aniduration = groupDuration.inMilliseconds-1000*(totalNum-1);

    if(aniduration<duration.inMilliseconds){
      throw(RangeError("TextAniMulti set groupDuration too short"));
    }

    //endIntervalBegin 计算的是整个组的结束时间，单独part的结束时间要重新计算
    double endAniBegin = msToInterval(startTimeMs!+aniduration-duration.inMilliseconds, groupDuration);
    double endAniEnd = msToInterval(startTimeMs!+aniduration, groupDuration);

    InAndOutAniType inAndOutAniType =  InAndOutAniType.explosion;
    initTextStandardAni(controller, inAndOutAniType,
        startIntervalBegin,startIntervalEnd,endAniBegin, text,style!,ee: endAniEnd);//初始化通用的额外的动画

    _slide = AlignmentTween(
      begin: position,
      end: const Alignment(0,-0.9),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(startIntervalBegin, endAniEnd, curve: Curves.linear),
      ),
    );

    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(startIntervalBegin, startIntervalEnd, curve: Curves.linear),
      ),
    );


    _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(endAniBegin, endAniEnd, curve: Curves.linear),
      ),
    );


  }


  @override
  Widget getPartWidgetBuilder(BuildContext context, Widget? child) {
    return AlignTransition(
      alignment: _slide,
      child: FadeTransition(
        opacity: _fadeIn.value != 1.0 ? _fadeIn : _fadeOut,
        child: getStandardAni(child),
      ),
    );
  }

  @override
  Widget getChild(){
    return Text(text,style: style);
  }
}
