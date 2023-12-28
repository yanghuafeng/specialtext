/**
 * Created by YHF at 9:25 on 2023-08-04.
 */

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:specialtext/src/TextStandardAni.dart';
import 'package:specialtext/src/TextAniBase.dart';
import 'package:specialtext/src/TextShowAni.dart';

class TextAniTransform extends TextAniBase with TextShowAni,TextStandardAni{
  final Random _random = Random();
  final Duration duration;
  final Alignment slidedirction;
  late Curve curve;
  late bool showScale;
  late bool showSlide;
  late bool showFade;
  ShowAniType showAniType = ShowAniType.shake;
  TextAniTransform({
    required Alignment position,
    required double rotate,
    TextStyle? textStyle,
    int? startTimeMs,
    this.duration = const Duration(milliseconds: 500),
    this.slidedirction = Alignment.centerLeft,
  }) : super(position,rotate,startTimeMs,textStyle,);

  late Animation<double> _fadeIn, _fadeOut;
  late Animation<double> _scaleIn, _scaleOut;
  late Animation<Alignment> _slideIn, _slideOut;

  @override
  void initParameter({TextAniBase? first}) {
    TextAniTransform? s;
    if(first is TextAniTransform){
      s = first;
    }
    showScale = s?.showScale??_random.nextDouble() > 0.55; //调整概率
    showSlide = s?.showSlide??_random.nextDouble() > 0.8;
    showFade = s?.showFade??_random.nextDouble() > 0.6;
    if(!showSlide && !showScale && !showFade){
      showSlide = true;//不能一个动画都没有
    }
    curve = s?.curve??(_random.nextBool() ? Curves.easeOutBack : Curves.linear);
    if(curve == Curves.linear){//easeoutback接3D效果不好看
      showAniType = ShowAniType.showAni3D;
    }else{
      showAniType = ShowAniType.shake;
      rotate = rotate +  _random.nextDouble() * 0.3 - 0.15;
    }
  }

  @override
  void setAnimation(AnimationController controller, Duration groupDuration) {
    if(startTimeMs!+duration.inMilliseconds>groupDuration.inMilliseconds){
      startTimeMs = groupDuration.inMilliseconds - duration.inMilliseconds;
    }
    final direction = TextDirection.ltr;
    generalInterval(duration,groupDuration);//计算一个group进入动画和退出动画的开始结束interval值（0~1）

    initShowAni(controller);//初始化文字展示动画

    InAndOutAniType inAndOutAniType = InAndOutAniType.none;
    if(!showSlide){
      inAndOutAniType = InAndOutAniType.rotate;
    }
    if(!showSlide&&!showScale){
      inAndOutAniType = InAndOutAniType.explosion;
    }

    initTextStandardAni(controller, inAndOutAniType,
        startIntervalBegin,startIntervalEnd,endIntervalBegin, text,style!);//初始化通用的额外的动画

    _slideIn = AlignmentTween(
      begin: showSlide?slidedirction.add(position).resolve(direction):position,
      end: position,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(startIntervalBegin, startIntervalEnd, curve: curve),
      ),
    );

    _fadeIn = Tween<double>(begin: showFade?0.0:1.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(startIntervalBegin, startIntervalEnd, curve: curve),
      ),
    );

    _scaleIn = Tween<double>(begin: showScale?3.0:1.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(startIntervalBegin, startIntervalEnd, curve: curve),
      ),
    );

    _slideOut = AlignmentTween(
      begin: position,
      end: showSlide?slidedirction.add(position).resolve(direction):position,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(endIntervalBegin, 1.0, curve: Curves.linear),
      ),
    );

    _fadeOut = Tween<double>(begin: 1.0, end: showFade?0.0:1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(endIntervalBegin, 1.0, curve: Curves.linear),
      ),
    );

    _scaleOut = Tween<double>(begin: 1.0, end: showScale?0.0:1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(endIntervalBegin, 1.0, curve: Curves.linear),
      ),
    );

  }


  @override
  Widget getPartWidgetBuilder(BuildContext context, Widget? child) {
    return ScaleTransition(
      scale: _scaleIn.value != 1.0 ? _scaleIn : _scaleOut,
      child: AlignTransition(
        alignment: _slideIn.value.x != position.x ? _slideIn : _slideOut,
        child: FadeTransition(
          opacity: _fadeIn.value != 1.0 ? _fadeIn : _fadeOut,
          child: getStandardAni(showAni(child,aniType: showAniType)),
        ),
      ),
    );
  }

  @override
  Widget getChild(){
    List<int>? list = targetTest(text);
    return list==null? Text(text,style: style) :Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(text.characters.getRange(0,list[0]).toString(),style: style),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(text.characters.getRange(list[0],list[1]).toString(),
              style: style!.merge(const TextStyle(fontSize: 90))),
        ),
        Text(text.characters.getRange(list[1]).toString(),style: style),
      ],
    );
  }
}
