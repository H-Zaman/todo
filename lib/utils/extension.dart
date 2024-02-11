import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

extension TimeStampExtension on Timestamp{
  String get time => DateFormat('HH:mm · MMM dd').format(toDate());

  /// today, this_week, this_month, [12 - month names]
  String get notificationGroupString {
    if(DateTime.now().difference(toDate()).inDays < 1){
      return 'Today';
    }else if(DateTime.now().difference(toDate()).inDays < 7){
      return 'This week';
    }else if(DateTime.now().difference(toDate()).inDays < 31){
      return 'This Month';
    }else{
      return DateFormat('MMMM').format(toDate());
    }
  }
}

extension DateTimeExtension on DateTime{
  String get time => DateFormat('hh:mm aa · MMM dd').format(this);
}
