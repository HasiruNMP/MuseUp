import 'package:adminweb/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Reports {

  static Stream<QuerySnapshot<Map<String, dynamic>>> reportsStream() {
    return DatabaseService.db.collection('reports').orderBy('time',descending: true).snapshots();
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> getReportDetailsFuture(String reportID) {
    return DatabaseService.db.collection('reports').doc(reportID).get();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getFeedbacksStream() {
    return DatabaseService.db.collection('feedback').orderBy('time',descending: true).snapshots();
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> getFeedBackDetailsFuture(String docID) {
    return DatabaseService.db.collection('feedback').doc(docID).get();
  }

}