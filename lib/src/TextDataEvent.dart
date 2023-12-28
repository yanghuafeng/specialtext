import 'package:specialtext/specialtext.dart';

/**
 * Created by YHF at 11:00 on 2023-08-16.
 */
 
class TextDataEvent{

  TextEventId eventId = TextEventId.none;
  TextGroup group = TextGroup();
  String? errortip;

  TextDataEvent();
  TextDataEvent.base(this.eventId);

  TextDataEvent.show(this.group){
    eventId = TextEventId.showGroup;
  }

  TextDataEvent.error(this.errortip){
    eventId=TextEventId.error;
  }

  @override
  String toString() {
    // TODO: implement toString
    return "eventId:"+eventId.name;
  }
}

enum TextEventId{
  showGroup,
  pause,
  resume,
  error,
  none
}