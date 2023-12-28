
import 'package:flutter/material.dart';
import 'package:specialtext/src/TextBgManager.dart';

class TextBgView extends StatefulWidget {
  const TextBgView({Key? key}) : super(key: key);

  @override
  State<TextBgView> createState() => _TextBgViewState();
}

class _TextBgViewState extends State<TextBgView> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    TextBgManager.getInstance().addRefreshListener((){
      if(mounted){setState(() {});}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: TextBgManager.getInstance().getBgWidget(),
    );
  }

  @override
  void dispose() {
    TextBgManager.getInstance().dispose();
    super.dispose();
  }
}
