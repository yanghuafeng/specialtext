import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';

/**
 * Created by YHF at 10:14 on 2023-08-09.
 */
///展示时的动画
abstract class TextShowAni{
  late Animation<double> _showAniValue;
  late int _dircetx;//1,-1
  late int _dircety;//1,-1
  late double _offsety;
  final Random _random = Random();
  final int _periodMs = 6000;
  final int _skewPeriodMs = 3000;
  late double _reversetime;
  late double _skewReversetime;

  initShowAni(AnimationController controller){
    _dircetx = _random.nextBool()?1:-1;
    _dircety = _random.nextBool()?1:-1;
    _offsety = _random.nextDouble()*500;
    _reversetime = controller.duration!.inMilliseconds/_periodMs;
    _skewReversetime = controller.duration!.inMilliseconds/_skewPeriodMs;
    _showAniValue = Tween<double>(begin:0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.linear,
      ),
    );
  }


  Widget? showAni(Widget? widget,{ShowAniType aniType = ShowAniType.showAni3D}){
    switch(aniType){
      case ShowAniType.showAni3D:
        double anivalue = sin(_showAniValue.value*_reversetime*pi);
        double rotatex = anivalue*0.1*_dircetx;
        double rotatey = anivalue*0.25*_dircety;
        double translatex = anivalue*40*_dircetx;
        double translatey = anivalue*40*_dircety;
        return Transform(
            origin: Offset(300+_offsety*_showAniValue.value,0),
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(rotatex)
              ..rotateY(rotatey)
              ..translate(translatex,translatey),
            child: widget);
      case ShowAniType.shake:
        return Transform(
            origin: const Offset(0,120),
            transform: Matrix4.skewX(sin(_showAniValue.value*_skewReversetime*pi)/5),
            child: widget);
    }

  }

}

enum ShowAniType{
  showAni3D,
  shake
}