import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/form_model.dart';
import '../services/database_service.dart';
import '../widgets/dynamic_form_field.dart';

class DynamicFormScreen extends StatefulWidget {
  const DynamicFormScreen({Key? key}) : super(key: key);

  @override
  State<DynamicFormScreen> createState() => _DynamicFormScreenState();
}

class _DynamicFormScreenState extends State<DynamicFormScreen> {
  final DatabaseService _databaseService = DatabaseService();
  List<FormFieldModel> _formFields = [];
  List<FormSubmission> _submissions = [];
  bool _isLoading = false;

  final String sampleJson = '''
  {
    "name": {
      "type": "text"
    },
    "lastname": {
      "type": "text"
    },
    "date_of_birth": {
      "type": "date"
    },
    "male_female": {
      "type": "radio",
      "options": [
        "male",
        "female"
      ]
    }
  }
  ''';

  @override
  void initState() {
    super.initState();
    _loadForm();
    _loadSubmissions();
  }

  void _loadForm() {
    try {
      final Map<String, dynamic> formConfig = jsonDecode(sampleJson);
      setState(() {
        _formFields = formConfig.entries.map((entry) => FormFieldModel.fromJson(entry.key, entry.value)).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading form: $e')),
      );
    }
  }

  void _loadSubmissions() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final submissions = await _databaseService.getAllFormSubmissions();
      setState(() {
        _submissions = submissions;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading submissions: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _submitForm() async {
    bool isValid = true;
    Map<String, String> values = {};

    for (var field in _formFields) {
      if (field.value == null || field.value!.isEmpty) {
        isValid = false;
        break;
      }
      values[field.key] = field.value!;
    }

    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    try {
      final submission = FormSubmission(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        values: values,
        submittedAt: DateTime.now(),
      );

      await _databaseService.insertFormSubmission(submission);

      setState(() {
        for (var field in _formFields) {
          field.value = null;
        }
      });

      _loadSubmissions();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form submitted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting form: $e')),
      );
    }
  }

  void _deleteSubmission(String id) async {
    try {
      await _databaseService.deleteFormSubmission(id);
      _loadSubmissions();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Submission deleted')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting submission: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Form (Question 1)'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dynamic Form Builder',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Fill the Form',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._formFields.map((field) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: DynamicFormField(
                          field: field,
                          onChanged: (value) {
                            // Value is automatically updated in the field
                          },
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Submit Form'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Submitted Data',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_submissions.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Text('No submissions yet'),
                  ),
                ),
              )
            else
              ..._submissions.map((submission) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text('Submission ${submission.id}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...submission.values.entries.map((entry) {
                          return Text('${entry.key}: ${entry.value}');
                        }).toList(),
                        Text(
                          'Submitted: ${submission.submittedAt.toString().split('.')[0]}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteSubmission(submission.id),
                    ),
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }
}
