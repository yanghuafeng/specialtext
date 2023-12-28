import 'dart:math';

import 'package:flutter/material.dart';
enum InAndOutAniType{
  rotate,
  explosion,
  none,
}
///通用的额外的动画,包括散开效果和3d旋转效果
abstract class TextStandardAni{
  late Animation<double> _animation;
  late AnimationController _controller;
  late String _text;
  late TextStyle _style;
  final Random _random = Random();
  late double _startIntervalBegin;
  late double _startIntervalEnd;
  late double _endIntervalBegin;
  late double _endIntervalEnd;
  InAndOutAniType _inAnOutAniType = InAndOutAniType.none;
  initTextStandardAni(AnimationController ani,InAndOutAniType type,
      double sb, double se, double eb, String text,TextStyle textStyle,{double ee = 1}){
    _controller = ani;
    _inAnOutAniType = type;
    _startIntervalBegin = sb;
    _startIntervalEnd = se;
    _endIntervalBegin = eb;
    _endIntervalEnd = ee;
    _text = text;
    _style = textStyle;
    switch(_inAnOutAniType){
      case InAndOutAniType.explosion:
        _initExplode();
        break;
      case InAndOutAniType.rotate:
        _initRotate();
        break;
      default:
    }
  }

  _initRotate(){
    _animation = Tween<double>(begin: 0, end: 1.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(_endIntervalBegin, _endIntervalEnd, curve: Curves.linear),
      ),
    );
  }


  List<Particle>? _particles;
  late Size _size;
  _initExplode(){
    TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(text: _text ,style: _style), maxLines: 1)..layout();
    _size = textPainter.size;
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(_endIntervalBegin, _endIntervalEnd, curve: Curves.linear),
      ),
    );

    _particles = List<Particle>.generate(200, (i){
      return Particle(
          left: _random.nextInt(_size.width.toInt()-10).toDouble(),
          top:_random.nextInt(_size.height.toInt()-10).toDouble(),
          color: Colors.white,
          sizeFactor: _random.nextInt(1000).toDouble()/1000,
      );
    });
  }


  Widget? getStandardAni(Widget? child) {
    switch(_inAnOutAniType){
      case InAndOutAniType.explosion:
        return _getExplosion(child);
      case InAndOutAniType.rotate:
        return _getRotate(child);
      default:
        return child;
    }
  }

  _getExplosion(Widget? child){
    return _animation.value==0?child:CustomPaint(
      foregroundPainter: ParticlesPainter(_animation.value,_particles!),
      child: SizedBox(
        width: _size.width,
        height: _size.height,
      ),
    );
  }

  _getRotate(Widget? child) {
    return Transform(
      origin: const Offset(400, 0),
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(_animation.value),
      child: child,
    );
  }
}

class ParticlesPainter extends CustomPainter{
  final double span;
  final List<Particle> particles;
  ParticlesPainter(this.span,this.particles);
  @override
  void paint(Canvas canvas, Size size) {
    particles.forEach((particle){
      particle.advance(span,span>0.4,size.height);
      Paint paint = Paint()
        ..color = particle.color!.withOpacity(min(max((0.4*(1-span)+1-span),0),1))
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
          Offset(particle.left!, particle.top!),
          particle.sizeFactor!*10*span,
          paint);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

class Particle{
  double? left;
  double? top;
  double? initialLeft;
  double? initialTop;
  double? sizeFactor;
  Color? color;
  int? direction;
  double? topMax;
  double? leftMax;
  double? bottomMax;
  double? x;
  Particle({this.left,this.top,this.color,this.sizeFactor}){
    direction = new Random().nextBool() ? 1: -1;
    initialLeft = left;
    initialTop = top;
    x = new Random().nextInt(1000)/1000.0;
    leftMax = direction ==1?(left! + 150*x!):left!-200*x!;
    topMax = top!-150;
    bottomMax = initialTop!+150;
  }
  advance(double span,bool stage,double height){
    if(true) {
      left = initialLeft! * (1 - span) + leftMax! * span;
      top = initialTop! + 50 * span +
          100 * sin(pi / 2 + 2 * span * pi);
    } else {
      top = initialTop!*(1-span) + height*span;
    }
  }
}
