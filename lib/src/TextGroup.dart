
import 'package:specialtext/src/TextAniBase.dart';

/**
 * Created by YHF at 17:31 on 2023-08-02.
 */
 
class TextGroup{
  List<TextAniBase> part = [];
  Duration showDuration = Duration.zero;

  void dispose(){
    for(TextAniBase part in part){
      part.dispose();
    }
  }
}

class GroupPartData{
  int lineNum;
  String text;
  int durationMs;

  GroupPartData(this.text, this.lineNum,this.durationMs);

  @override
  String toString() {
    return lineNum.toString()+": "+text+" duration: "+durationMs.toString()+" ";
  }
}