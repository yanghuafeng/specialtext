
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:specialtext/specialtext.dart';
import 'package:specialtext/src/TextDataEvent.dart';
import 'package:specialtext/src/TextGroup.dart';

import 'TextAniBase.dart';

StreamController<TextDataEvent> lyricUpdate = StreamController.broadcast();

class TextArea extends StatefulWidget {

  const TextArea({Key? key,}):super(key: key);

  @override
  _TextAreaState createState() => _TextAreaState();
}

class _TextAreaState extends State<TextArea> with TickerProviderStateMixin {

  AnimationController? _controller;

  List<Widget> list=[];
  TextGroup? _curGroup;

  late StreamSubscription subscription;

  String? errorMsg;

  @override
  void initState() {
    super.initState();

    subscription = lyricUpdate.stream.listen((event) {
      switch(event.eventId){
        case TextEventId.showGroup:
          errorMsg = null;
          showGroup(event.group);
          break;
        case TextEventId.pause:
          _controller?.stop(canceled: false);
          break;
        case TextEventId.resume:
          _controller?.forward();
          break;
        case TextEventId.error:
          errorMsg = event.errortip;
          setState(() {
          });
          break;
        case TextEventId.none:
          // TODO: Handle this case.
          break;

      }
    });


  }



  showGroup(TextGroup group){
    releaseController();
    _curGroup = group;
    _controller = AnimationController(duration: group.showDuration,vsync: this);
    list = group.part.map((item){
      item.setAnimation(_controller!,group.showDuration);
      return generatePartWidget(item);
    }).toList();
    _controller!.forward();

    setState(() {

    });
  }

  @override
  void dispose() {
    releaseController();
    subscription.cancel();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return  RepaintBoundary(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent,
        child: errorMsg!=null?Center(
          child: Text(errorMsg.toString(),style: const TextStyle(
            color: Color(0xC9FFFFFF),
            fontSize: 30,
          ),),
        ):Stack(
          children: list
        ),
      ),
    );
  }

  Widget generatePartWidget(TextAniBase textPart){
    return Align(
        alignment: textPart.position,
        child: Transform.rotate(
            angle: textPart.rotate,
            child: AnimatedBuilder(
              animation:_controller!,
              builder: textPart.getPartWidgetBuilder,
              child: textPart.getChild(),
            )
        )
    );
  }


  releaseController(){
    _curGroup?.dispose();
    if(_controller!=null){
      _controller!.dispose();
      _controller==null;
    }
  }

}
