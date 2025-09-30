import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/form_model.dart';

class DynamicFormField extends StatefulWidget {
  final FormFieldModel field;
  final Function(String value) onChanged;

  const DynamicFormField({
    Key? key,
    required this.field,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<DynamicFormField> createState() => _DynamicFormFieldState();
}

class _DynamicFormFieldState extends State<DynamicFormField> {
  late TextEditingController _controller;
  String? _selectedRadioValue;
  List<String> _selectedCheckboxValues = [];
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.field.value ?? '');
    _selectedRadioValue = widget.field.value;
    if (widget.field.value != null && widget.field.type == 'checkbox') {
      _selectedCheckboxValues = widget.field.value!.split(',');
    }
    if (widget.field.value != null && widget.field.type == 'date') {
      try {
        _selectedDate = DateTime.parse(widget.field.value!);
      } catch (e) {
        _selectedDate = null;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.field.type) {
      case 'text':
        return _buildTextField();
      case 'date':
        return _buildDateField();
      case 'radio':
        return _buildRadioField();
      case 'checkbox':
        return _buildCheckboxField();
      default:
        return _buildTextField();
    }
  }

  Widget _buildTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.field.key.replaceAll('_', ' ').toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Enter ${widget.field.key.replaceAll('_', ' ')}',
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          onChanged: (value) {
            widget.field.value = value;
            widget.onChanged(value);
          },
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.field.key.replaceAll('_', ' ').toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              setState(() {
                _selectedDate = picked;
                widget.field.value = picked.toIso8601String().split('T')[0];
                widget.onChanged(widget.field.value!);
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : 'Select date',
                  style: TextStyle(
                    color: _selectedDate != null ? Colors.black : Colors.grey,
                  ),
                ),
                const Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRadioField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.field.key.replaceAll('_', ' ').toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        ...widget.field.options!.map((option) {
          return RadioListTile<String>(
            title: Text(option.toUpperCase()),
            value: option,
            groupValue: _selectedRadioValue,
            onChanged: (String? value) {
              setState(() {
                _selectedRadioValue = value;
                widget.field.value = value;
                widget.onChanged(value ?? '');
              });
            },
          );
        }).toList(),
      ],
    );
  }

  Widget _buildCheckboxField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.field.key.replaceAll('_', ' ').toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        ...widget.field.options!.map((option) {
          return CheckboxListTile(
            title: Text(option.toUpperCase()),
            value: _selectedCheckboxValues.contains(option),
            onChanged: (bool? value) {
              setState(() {
                if (value == true) {
                  _selectedCheckboxValues.add(option);
                } else {
                  _selectedCheckboxValues.remove(option);
                }
                widget.field.value = _selectedCheckboxValues.join(',');
                widget.onChanged(widget.field.value ?? '');
              });
            },
          );
        }).toList(),
      ],
    );
  }
}
