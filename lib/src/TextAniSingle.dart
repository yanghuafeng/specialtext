/**
 * Created by YHF at 9:25 on 2023-08-04.
 */

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:specialtext/src/TextStandardAni.dart';
import 'package:specialtext/src/TextAniBase.dart';
import 'package:specialtext/src/TextShowAni.dart';

class TextAniSingle extends TextAniBase with TextStandardAni{

  final Duration duration;
  final Curve curve;
  TextAniSingle({
    required Alignment position,
    required double rotate,
    TextStyle? textStyle,
    int? startTimeMs,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.linear,
  }) : super(position,rotate,startTimeMs,textStyle,);

  late Animation<double> _fadeOut;
  late Animation<double> _scaleIn;
  late Animation<double> _showAniValue;
  late int _dircetx;//1,-1
  late int _dircety;//1,-1
  final Random _random = Random();
  final int _periodMs = 6000;
  late double _reversetime;

  List<Text>? _textList;

  @override
  void initParameter({TextAniBase? first}) {
    _dircetx = _random.nextBool()?1:-1;
    _dircety = _random.nextBool()?1:-1;
    initTextList();
  }

  @override
  void setAnimation(AnimationController controller, Duration groupDuration) {
    if(startTimeMs!+duration.inMilliseconds>groupDuration.inMilliseconds){
      startTimeMs = groupDuration.inMilliseconds - duration.inMilliseconds;
    }
    generalInterval(duration,groupDuration);//计算一个group进入动画和退出动画的开始结束interval值（0~1）

    InAndOutAniType inAndOutAniType = Random().nextBool()? InAndOutAniType.rotate: InAndOutAniType.explosion;

    initTextStandardAni(controller, inAndOutAniType,
        startIntervalBegin,startIntervalEnd,endIntervalBegin, text,style!);//初始化通用的额外的动画

    _reversetime = controller.duration!.inMilliseconds/_periodMs;

    _showAniValue = Tween<double>(begin:0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.linear,
      ),
    );

    _scaleIn = Tween<double>(begin: 0, end: 3.6).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(startIntervalBegin, startIntervalEnd, curve: curve),
      ),
    );

    _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(endIntervalBegin, 1.0, curve: Curves.linear),
      ),
    );


  }


  @override
  Widget getPartWidgetBuilder(BuildContext context, Widget? child) {
    double anivalue = sin(_showAniValue.value*_reversetime*pi);
    double translatex = anivalue*40*_dircetx;
    double translatey = anivalue*40*_dircety;

    return FadeTransition(
      opacity: _fadeOut,
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..translate(translatex,translatey),
        child: _textList==null?getStandardAni(getChild()):SizedBox(
          height: 260,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [//缩放抖动效果
              Transform.scale(
                  scale: _scaleIn.value.clamp(0, 1.3)-_scaleIn.value.clamp(1.3, 1.6)+1.3,
                  child: _textList![0]),
              const SizedBox.square(dimension: 15),
              Transform.scale(
                  scale: _scaleIn.value.clamp(1, 2.3)-1-_scaleIn.value.clamp(2.3, 2.6)+2.3,
                  child: _textList![1]),
              const SizedBox.square(dimension: 15),
              Transform.scale(
                  scale: _scaleIn.value.clamp(2, 3.3)-2-_scaleIn.value.clamp(3.3, 3.6)+3.3,
                  child: _textList![2]),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget getChild(){
    return Text(text,style: style);
  }


  initTextList(){
    if(text.length>8){
      _textList = [];
      _textList!.add(
          Text(text.characters.getRange(0,3).toString(),
              style:style!.merge(const TextStyle(fontSize: 60))
          )
      );

      _textList!.add(
          Text(text.characters.getRange(3,5).toString(),
              style:style!.merge(const TextStyle(fontSize: 120))
          )
      );

      _textList!.add(
          Text(text.characters.getRange(5).toString(),
              style:style!.merge(const TextStyle(fontSize: 40))
          )
      );
    }
  }

  @override
  void dispose() {

  }
}
