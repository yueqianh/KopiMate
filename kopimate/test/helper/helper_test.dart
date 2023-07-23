import 'package:flutter_test/flutter_test.dart';
import 'package:kopimate/helper/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  group('Testing formatDate function', () {
    test('Converting timestamp from DateTime to formatted DD/M/YYYY', () {
      var dt = DateTime(2023, 7, 24, 0, 0, 0);
      Timestamp testTimeStamp1 = Timestamp.fromDate(dt);
      expect(formatDate(testTimeStamp1) == "24/7/2023", true);
    });

    test('Converting fixed timestamp to formatted DD/M/YYYY', () {
      Timestamp testTimeStamp2 =
          Timestamp.fromMillisecondsSinceEpoch(1690156800000);
      expect(formatDate(testTimeStamp2) == "24/7/2023", true);
    });
  });
}
