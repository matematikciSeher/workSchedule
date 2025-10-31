import 'package:flutter/material.dart';

class TaskFormPage extends StatefulWidget {
  final String? taskId; // null ise yeni görev, değilse düzenleme

  const TaskFormPage({
    super.key,
    this.taskId,
  });

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      // Görev kaydetme işlemi
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.taskId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Görevi Düzenle' : 'Yeni Görev'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Başlık',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lütfen başlık girin';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Açıklama',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Tarih'),
              subtitle: Text(
                _selectedDate == null
                    ? 'Tarih seçilmedi'
                    : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _selectDate,
            ),
            ListTile(
              title: const Text('Saat'),
              subtitle: Text(
                _selectedTime == null
                    ? 'Saat seçilmedi'
                    : _selectedTime!.format(context),
              ),
              trailing: const Icon(Icons.access_time),
              onTap: _selectTime,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveTask,
              child: Text(isEditing ? 'Güncelle' : 'Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}

