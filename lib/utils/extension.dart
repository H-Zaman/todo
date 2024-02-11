import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime{
  String get timeFull => DateFormat('hh:mm aa · MMM dd').format(this);

  String get time => DateFormat('HH:mm · MMM dd').format(this);

  /// today, this_week, this_month, [12 - month names]
  String get notificationGroupString {
    if(DateTime.now().difference(this).inDays < 1){
      return 'Today';
    }else if(DateTime.now().difference(this).inDays < 7){
      return 'This week';
    }else if(DateTime.now().difference(this).inDays < 31){
      return 'This Month';
    }else{
      return DateFormat('MMMM').format(this);
    }
  }
}
