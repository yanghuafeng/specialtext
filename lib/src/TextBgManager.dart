
import 'dart:io';
import 'dart:math';

import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

import '../specialtext.dart';

/**
 * Created by YHF at 17:05 on 2023-08-04.
 */
typedef BgListener = Function();

class TextBgManager {
  static TextBgManager _instance = new TextBgManager();

  static TextBgManager getInstance() {
    return _instance;
  }
  TextBgManager();

  bool _useVideoBg = false;

  void setUseVideoBg(bool b){
    _useVideoBg = b;
  }

  getUseVideoBg(){
    return _useVideoBg;
  }

  BgListener? _refreshListener;
  void addRefreshListener(BgListener listener){
    _refreshListener = listener;
  }


  CachedVideoPlayerController? _videoController;
  List<String> localVideoList=["ludeng1.mp4","ludeng2.mp4","yuanshang.mp4",
    "humian.mp4","haipinmian.mp4","shamo.mp4",];
  List<String> localImagesList=[
    "1.png","2.png","3.png","4.png","5.png","6.png",
    "7.png","8.png","9.png","10.png","11.png","12.png",/*"13.png",*/"14.png",
    "15.png",/*"16.png",*/"17.png","18.png","19.png","20.png",
    "21.gif","26.gif", "ludeng1.gif"];

  String? _name;
  bool _isFile = false;

  String getname(){
    return _name.toString();
  }

  bool isInit(){
    return _name!=null;
  }

  void randomABg(){
    late String name;
    if(_useVideoBg){
      int index = Random().nextInt(localVideoList.length);
      name = localVideoList[index];
    }else{
      int index = Random().nextInt(localImagesList.length);
      name = localImagesList[index];

    }

    init(name);
  }

  Future init(String name, {bool isFile = false})async {
    _name = name;
    _isFile = isFile;
    print("TextBgManager init textbg ${_name}, isfile:"+_isFile.toString());
    if(_videoController!=null){
      _videoController!.dispose();
      _videoController==null;
    }
    if(_useVideoBg) {
      if (isFile) {
        _videoController = CachedVideoPlayerController.file(File(_name!));
      } else {
        _videoController = CachedVideoPlayerController.asset(
            "assets/videos/$_name", package: TextConstant.packageName);
      }
      await _videoController!.initialize();
      await _videoController!.setLooping(true);
      await _videoController!.play();
    }
    _refreshListener?.call();
  }

  Widget getBgWidget(){

    if(!isInit()){
      return Container();
    }

    if(_useVideoBg && _videoController==null){
      return Container();
    }

    if(_useVideoBg){
      return CachedVideoPlayer(_videoController!);
    }

    if(_isFile){
      return Image.file(File(_name!),fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity);
    }else{
      return RepaintBoundary(
        child: AnimatedSwitcher(
          duration: const Duration(seconds: 2),
          child: Image.asset("assets/images/$_name",package: TextConstant.packageName,fit: BoxFit.cover,
              key: ValueKey(_name),
              width: double.infinity,
              height: double.infinity
          ),
        ),
      );
    }

  }


  dispose(){
    if(_videoController!=null){
      _videoController!.dispose();
      _videoController==null;
    }

    _refreshListener = null;
  }
}
