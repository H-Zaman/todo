import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

extension TimeStampExtension on Timestamp{
  String get time => DateFormat('dd MMM hh:mm:ss aa').format(toDate());
}