
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:specialtext/specialtext.dart';
import 'package:specialtext/src/TextAniInverted.dart';
import 'package:specialtext/src/TextAniMulti.dart';
import 'package:specialtext/src/TextAniTypewriter.dart';
import 'package:specialtext/src/TextAniWave.dart';

import 'TextAniBase.dart';
import 'TextAniRain.dart';
import 'TextAniSingle.dart';
import 'TextAniTransform.dart';

/**
 * Created by YHF at 17:05 on 2023-08-04.
 */
class TextGroupManager{
  static TextGroupManager _instance = new TextGroupManager();
  static TextGroupManager getInstance(){
    return _instance;
  }

  TextGroupManager();
  ///所有分组
  final Random _random =  Random();

  sendDataEvent(TextDataEvent event){
    print("TextGroupManager sendDataEvent $event");

    lyricUpdate.add(event);
  }

  TextGroup generalAGroup(List<GroupPartData> partList,Duration groupDuration){
    print("TextGroupManager generalAGroup text:$partList" +
        "groupDuration:"+groupDuration.inMilliseconds.toString());
    TextGroup group = TextGroup();
    int partnum = partList.length;

    double rotate = _random.nextDouble() * 0.4 - 0.2; //旋转角度不要太大

    List<Alignment> alignList = [Alignment.center];

    if(partnum==2){
      alignList = twoPartAlignmentList[_random.nextInt(twoPartAlignmentList.length)];//两行的时候位置需要特殊处理
    }


    late TextAniType aniType;

    if(partnum==1){
      if(groupDuration.inMilliseconds>2600 && _random.nextBool()){
        aniType = TextAniType.rain;
      }else if(groupDuration.inMilliseconds>2100 && (partList[0].text.length<9 || ( partList[0].text.length<12 && _random.nextBool()))) {
        aniType = TextAniType.inverted;
      }else{
        aniType = TextAniType.single;
      }
    }else if(partnum == 2) {
      double randAniType = _random.nextDouble();
      if(randAniType>0.8 && groupDuration.inSeconds>2){
        aniType = TextAniType.wavy;
      }else if(randAniType>0.4 && groupDuration.inSeconds>3){
        aniType = TextAniType.typewriter;
      }else{
        aniType = TextAniType.transform;
      }

      if(checkEn(partList)){//英文歌曲强制
        aniType = TextAniType.transform;
      }
    }else{
      aniType = TextAniType.multi;
    }

    print("TextGroupManager generalAGroup aniType:"+aniType.name);
    for (int i = 0; i < partnum; i++) {
      late TextAniBase textPart;
      switch (aniType) {
        case TextAniType.transform:
          textPart = TextAniTransform(
              position: alignList[i],
              rotate: rotate,
              slidedirction: i.isOdd ? const Alignment(-8, 0) : const Alignment(8, 0),
          );
          break;
        case TextAniType.typewriter:
          textPart = TextAniTypewriter(
              position: alignList[i],
              rotate: rotate,
              duration: Duration(milliseconds: partList[i].text.length * 100),
              startTimeMs: i==0?0:partList[i-1].text.length * 100,
          );
          break;
        case TextAniType.single:
          textPart = TextAniSingle(
              position: alignList[i],
              rotate: rotate,
          );
          break;
        case TextAniType.multi:
          textPart = TextAniMulti(
            position: const Alignment(0,0.9),
            rotate: 0,
            startTimeMs: i==0?0:1000*i,
            totalNum: partList.length
          );
          break;
        case TextAniType.wavy:
          textPart = TextAniWave(
            position: alignList[i],
            rotate: rotate,
            duration: Duration(milliseconds: partList[i].text.length * 50+30*25),
            startTimeMs: i==0?0:partList[i-1].text.length * 50+30*25,
          );
          break;
        case TextAniType.inverted:
          textPart = TextAniInverted(
            position: const Alignment(-0.2,0),
            rotate: 0,
            textStyle: const TextStyle(fontSize: 60),
            duration: const Duration(milliseconds: 1600),
          );
          break;
        case TextAniType.rain:
          textPart = TextAniRain(
            position: alignList[i],
            rotate: 0,
            duration: const Duration(milliseconds: 1600),
          );
          break;
      }

      //统一的属性
      textPart.text =  partList[i].text;
      textPart.linenum =  partList[i].lineNum;
      textPart.partDurationMs =  partList[i].durationMs;


      //有些动画参数需要与第一个保持一致
      TextAniBase? sameToFirst;
      if(i>0 && textPart is TextAniTransform){
        sameToFirst = group.part[0];
      }

      textPart.initParameter(first: sameToFirst);

      group.part.add(textPart);
    }

    group.showDuration = groupDuration;

    return group;
  }


  List<List<Alignment>> twoPartAlignmentList=[
    [const Alignment(0.4, -0.4),const Alignment(-0.4, 0.4)],
    [const Alignment(0, -0.4),const Alignment(0, 0.4)],
    [const Alignment(-0.4, -0.4),const Alignment(0.4, 0.4)],
  ];

  List<List<Alignment>> threePartAlignmentList=[
    [const Alignment(0.5, -0.5),const Alignment(0, 0),const Alignment(-0.5, 0.5),],
    [const Alignment(0, -0.5),const Alignment(0, 0),const Alignment(0, 0.5),],
    [const Alignment(-0.5, -0.5),const Alignment(0, 0),const Alignment(0.5, 0.5),],
  ];


  bool checkEn(List<GroupPartData> partList){
    for (var element in partList) {
      if(element.text.contains(String.fromCharCode(0x2006))){
        return true;
      }
    }
    return false;
  }
}

