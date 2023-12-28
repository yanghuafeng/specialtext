import 'package:flutter/material.dart';
import 'package:specialtext/src/TextConstant.dart';

/**
 * Created by YHF at 17:31 on 2023-08-02.
 */

abstract class TextAniBase{
  String text = "";
  int linenum = -1;//行数索引
  int partDurationMs = 0;//该行时间
  TextStyle? style;
  int? startTimeMs;
  Alignment position;
  double rotate;

  TextAniBase(this.position, this.rotate, this.startTimeMs, this.style){
    startTimeMs ??= 0;
    style = const TextStyle(
      color: Color(0xE6FFFFFF),
      fontSize: 60,
      decoration: TextDecoration.none,
      fontFamily: "chuti",
      package: TextConstant.packageName,
    ).merge(style);
  }

  ///动画builder
  Widget getPartWidgetBuilder(BuildContext context,Widget? child);

  ///不变的child写这里可以提升性能
  Widget getChild();

  //初始化参数
  void initParameter({TextAniBase? first});


  ///初始化动画控制器
  void setAnimation(AnimationController controller,Duration duration);


  void dispose(){

  }

  //start:进入动画， end:退出动画,退出动画的end一般都是1所以不用处理
  late double startIntervalBegin;
  late double startIntervalEnd;
  late double endIntervalBegin;

  generalInterval(Duration partDuration,Duration groupDuration){
    startIntervalBegin = msToInterval(startTimeMs!, groupDuration);
    startIntervalEnd = msToInterval(startTimeMs!+partDuration.inMilliseconds, groupDuration);
    endIntervalBegin = msToInterval(groupDuration.inMilliseconds-partDuration.inMilliseconds, groupDuration);
  }

  double msToInterval(int startMs, Duration duration){
    return startMs/duration.inMilliseconds;

  }


  static const List<String> targetSingleKey = ["我","你","爱"];
  static const List<String> targetDoubleKey = ["我们","你们","爱情","爱好","可爱","爱人"];
  List<int>? targetTest(String text){
    for(int i=0;i<targetDoubleKey.length;i++){
      int index = text.indexOf(targetDoubleKey[i]);
      if(index>=0){
        return [index,index+2];
      }
    }

    for(int i=0;i<targetSingleKey.length;i++){
      int index = text.indexOf(targetSingleKey[i]);
      if(index>=0){
        return [index,index+1];
      }
    }

    return null;
  }


}

enum TextAniType{
  transform,
  typewriter,
  single,
  multi,
  wavy,
  inverted,
  rain,
}