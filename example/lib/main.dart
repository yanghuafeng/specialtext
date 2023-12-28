import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:specialtext/specialtext.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  /// This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated Text Kit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  String text = "还记得你说家是唯一的城堡\n"
      "随着稻香河流继续奔跑\n"
      "微微笑 小时候的梦我知道\n"
      "不要哭让萤火虫带着你逃跑\n"
      "乡间的歌谣永远的依靠\n"
      "回家吧 回到最初的美好\n"
      "对这个世界如果你有太多的抱怨\n"
      "跌倒了就不敢继续往前走\n"
      "为什么人要这么的脆弱堕落\n"
      "请你打开电视看看\n"
      "多少人为生命在努力勇敢的走下去\n"
      "我们是不是该知足\n"
      "珍惜一切就算没有拥有\n"
      "还记得你说家是唯一的城堡\n"
      "随着稻香河流继续奔跑\n"
      "微微笑 小时候的梦我知道\n"
      "不要哭让萤火虫带着你逃跑\n"
      "乡间的歌谣永远的依靠\n"
      "回家吧 回到最初的美好\n"
      "不要这么容易就想放弃\n"
      "就像我说的\n"
      "追不到的梦想换个梦不就得了\n"
      "为自己的人生鲜艳上色\n"
      "先把爱涂上喜欢的颜色\n"
      "笑一个吧\n"
      "功成名就不是目的\n"
      "让自己快乐快乐这才叫做意义\n"
      "童年的纸飞机\n"
      "现在终于飞回我手里\n"
      "所谓的那快乐\n"
      "赤脚在田里追蜻蜓追到累了\n"
      "偷摘水果被蜜蜂给叮到怕了\n"
      "谁在偷笑呢\n"
      "我靠着稻草人\n"
      "唱着歌 唱着歌\n"
      "我 睡着了 喔喔\n"
      "我 睡着了 喔喔\n"
      "我睡着了\n"
      "珍惜一切 就算没有拥有\n"
      "还记得你说家是唯一的城堡\n"
      "随着稻香河流继续奔跑\n"
      "微微笑 小时候的梦我知道\n"
      "不要哭让萤火虫带着你逃跑\n"
      "乡间的歌谣永远的依靠\n"
      "回家吧 回到最初的美好\n"
      "不要哭让萤火虫带着你逃跑\n"
      "乡间的歌谣永远的依靠\n"
      "回家吧 回到最初的美好\n";
  int i =0;
  @override
  void initState() {
    super.initState();
    List<String> list = text.split("\n");
    TextBgManager.getInstance().randomABg();
    Timer timer = Timer.periodic(Duration(milliseconds: 6100), (timer) {
      if(i>list.length-4){
        i=0;
      }
      List<GroupPartData> partList = [];
      partList.add(GroupPartData(list[i],i,2000));

     // bool singleLine = list[i].length>9?Random().nextBool():false;
      bool singleLine = true;
      if(singleLine) {
        partList.add(GroupPartData(list[i+1],i+1,4000));
        i++;
        partList.add(GroupPartData(list[i+1],i+1,6000));
        i++;

      }
      i++;
      TextDataEvent dataEvent =  TextDataEvent();
      dataEvent.eventId = TextEventId.showGroup;
      TextGroup group = TextGroupManager.getInstance().generalAGroup(partList, Duration(seconds: 6));
      TextGroupManager.getInstance().sendDataEvent(TextDataEvent.show(group));

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: (){
          TextBgManager.getInstance().randomABg();
        },
        child: Stack(
          children: [
            const Center(child: TextBgView(),),
            Container(
              key: UniqueKey(),
              child: const TextArea(),
            ),
          ],
        ),
      ),

    );
  }
}