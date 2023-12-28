/**
 * Created by YHF at 9:25 on 2023-08-04.
 */


import 'package:flutter/material.dart';
import 'package:specialtext/specialtext.dart';
import 'package:specialtext/src/TextAniBase.dart';

class TextAniThree extends TextAniBase{
  final Duration duration;
  final List<GroupPartData> partList;
  final Duration groupDuration;
  final int partIndex;
  TextAniThree({
    required Alignment position,
    required double rotate,
    required this.partList,
    required this.partIndex,
    required this.groupDuration,
    TextStyle? textStyle,
    int? startTimeMs,
    this.duration = const Duration(milliseconds: 500),
  }) : super(position,rotate,startTimeMs,textStyle,);

  List<double> startList = [];
  List<double> endList = [];

  List<Animation<double>> _aniList = [];
  List<Animation<double>> _aniOut = [];

  @override
  void initParameter({TextAniBase? first}) {
    double firstStart = 0;
    double firstEnd = 500/groupDuration.inMilliseconds;
    startList.add(firstStart);
    endList.add(firstEnd);
    for (int i=0;i<partList.length;i++) {
      double intervalStart = partList[i].durationMs/groupDuration.inMilliseconds;
      if(i==partList.length-1){
        intervalStart = (partList[i].durationMs-800)/groupDuration.inMilliseconds;
      }
      startList.add(intervalStart.clamp(0, 1));



      double intervalEnd = (partList[i].durationMs+1000)/groupDuration.inMilliseconds;
      if(i==partList.length-1){
        intervalEnd = (partList[i].durationMs-400)/groupDuration.inMilliseconds;
      }
      endList.add(intervalEnd);
    }
  }

  @override
  void setAnimation(AnimationController controller, Duration groupDuration) {
    for(int i=0;i<startList.length;i++){
      _aniList.add(Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Interval(startList[i], endList[i], curve: Curves.easeInOutQuad),
        ),
      ));
    }


    for(int i=0;i<partList.length;i++){
      double outDuration = msToInterval(groupDuration.inMilliseconds-(partList.length-i)*100-500, groupDuration);
      double outDurationend = msToInterval(groupDuration.inMilliseconds-(partList.length-i)*100, groupDuration);
      _aniOut.add(Tween<double>(begin: 0, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Interval(outDuration, outDurationend, curve: Curves.easeInQuad),
        ),
      ));
    }




  }


  @override
  Widget getPartWidgetBuilder(BuildContext context, Widget? child) {
    return Transform.translate(
      offset: Offset(_aniOut[partIndex].value*-1000,_aniOut[partIndex].value*-1000),
      child: Transform.translate(
        offset: Offset(1000*(1-_aniList[partIndex].value),getIncrement()*-80),
        child: Transform.scale(
            scale: 1-getIncrement()*0.3,
            child: child),
      ),
    );
  }

  double getIncrement(){
    if(partIndex==0){
      return _aniList[1].value+_aniList[2].value+_aniList[3].value;
    }
    if(partIndex==1){
      return _aniList[2].value+_aniList[3].value;
    }
    if(partIndex==2){
      return _aniList[3].value;
    }
    return 0;
  }

  @override
  Widget getChild(){
    return Text(text,style: style);
  }
}
