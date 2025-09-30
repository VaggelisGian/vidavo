import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/form_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static const String _submissionsKey = 'form_submissions';

  Future<void> insertFormSubmission(FormSubmission submission) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final submissions = await getAllFormSubmissions();

      submissions.add(submission);

      final String submissionsJson = jsonEncode(
        submissions.map((submission) => submission.toJson()).toList(),
      );

      await prefs.setString(_submissionsKey, submissionsJson);
    } catch (e) {
      throw Exception('Failed to save form submission: $e');
    }
  }

  Future<List<FormSubmission>> getAllFormSubmissions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? submissionsJson = prefs.getString(_submissionsKey);

      if (submissionsJson == null) {
        return [];
      }

      final List<dynamic> submissionsList = jsonDecode(submissionsJson);
      return submissionsList.map((json) => FormSubmission.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> deleteFormSubmission(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final submissions = await getAllFormSubmissions();

      submissions.removeWhere((submission) => submission.id == id);

      final String submissionsJson = jsonEncode(
        submissions.map((submission) => submission.toJson()).toList(),
      );

      await prefs.setString(_submissionsKey, submissionsJson);
    } catch (e) {
      throw Exception('Failed to delete form submission: $e');
    }
  }

  Future<void> clearAllSubmissions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_submissionsKey);
    } catch (e) {
      throw Exception('Failed to clear form submissions: $e');
    }
  }
}
