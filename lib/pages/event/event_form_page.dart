import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../domain/entities/event_entity.dart';
import '../../domain/repositories/event_repository.dart';
import '../../shared/widgets/decorative_background.dart';

class EventFormPage extends StatefulWidget {
  final String? eventId; // null ise yeni etkinlik, değilse düzenleme
  final EventRepository? eventRepository; // Repository inject edilebilir

  const EventFormPage({
    super.key,
    this.eventId,
    this.eventRepository,
  });

  @override
  State<EventFormPage> createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  DateTime? _selectedStartDate;
  TimeOfDay? _selectedStartTime;
  DateTime? _selectedEndDate;
  TimeOfDay? _selectedEndTime;
  bool _isAllDay = false;
  bool _isLoading = false;
  EventEntity? _existingEvent;

  // Dosya ve fotoğraf listeleri
  final List<File> _selectedImages = [];
  final List<File> _selectedFiles = [];

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.eventId != null) {
      _loadEvent();
    }
  }

  Future<void> _loadEvent() async {
    if (widget.eventRepository == null || widget.eventId == null) return;

    setState(() => _isLoading = true);
    try {
      final event = await widget.eventRepository!.getEventById(widget.eventId!);
      if (event != null && mounted) {
        // Mevcut attachment'ları yükle (setState dışında)
        final List<File> existingImages = [];
        final List<File> existingFiles = [];

        if (event.attachmentPaths != null) {
          for (var attachmentPath in event.attachmentPaths!) {
            final file = File(attachmentPath);
            final fileExists = await file.exists();
            if (fileExists) {
              if (_isImageFile(attachmentPath)) {
                existingImages.add(file);
              } else {
                existingFiles.add(file);
              }
            }
          }
        }

        setState(() {
          _existingEvent = event;
          _titleController.text = event.title;
          _descriptionController.text = event.description ?? '';
          _locationController.text = event.location ?? '';
          _selectedStartDate = event.startDate;
          _selectedEndDate = event.endDate;
          _isAllDay = event.isAllDay;

          _selectedStartTime = TimeOfDay.fromDateTime(event.startDate);
          _selectedEndTime = TimeOfDay.fromDateTime(event.endDate);

          _selectedImages.addAll(existingImages);
          _selectedFiles.addAll(existingFiles);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  bool _isImageFile(String filePath) {
    final ext = path.extension(filePath).toLowerCase();
    return ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp'].contains(ext);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedStartDate = picked;
      });
    }
  }

  Future<void> _selectStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedStartTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedStartTime = picked;
      });
    }
  }

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedEndDate ?? _selectedStartDate ?? DateTime.now(),
      firstDate: _selectedStartDate ?? DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedEndDate = picked;
      });
    }
  }

  Future<void> _selectEndTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedEndTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedEndTime = picked;
      });
    }
  }

  /// Fotoğraf seç (gallery veya camera)
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        // Dosyayı app dizinine kopyala
        final File imageFile = File(image.path);
        final Directory appDir = await getApplicationDocumentsDirectory();
        final String fileName = path.basename(image.path);
        final String savedPath =
            path.join(appDir.path, 'event_attachments', fileName);

        // Dizin yoksa oluştur
        await Directory(path.dirname(savedPath)).create(recursive: true);

        // Dosyayı kopyala
        final File savedFile = await imageFile.copy(savedPath);

        setState(() {
          _selectedImages.add(savedFile);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fotoğraf seçilirken hata: $e')),
        );
      }
    }
  }

  /// Dosya seç
  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final Directory appDir = await getApplicationDocumentsDirectory();

        for (var pickedFile in result.files) {
          if (pickedFile.path != null) {
            final File sourceFile = File(pickedFile.path!);
            final String fileName = pickedFile.name;
            final String savedPath =
                path.join(appDir.path, 'event_attachments', fileName);

            // Dizin yoksa oluştur
            await Directory(path.dirname(savedPath)).create(recursive: true);

            // Dosyayı kopyala
            final File savedFile = await sourceFile.copy(savedPath);

            setState(() {
              if (_isImageFile(savedPath)) {
                _selectedImages.add(savedFile);
              } else {
                _selectedFiles.add(savedFile);
              }
            });
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dosya seçilirken hata: $e')),
        );
      }
    }
  }

  /// Fotoğraf veya dosya sil
  void _removeAttachment(int index, bool isImage) {
    setState(() {
      if (isImage) {
        _selectedImages.removeAt(index);
      } else {
        _selectedFiles.removeAt(index);
      }
    });
  }

  Future<void> _saveEvent() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedStartDate == null || _selectedEndDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Lütfen başlangıç ve bitiş tarihlerini seçin')),
      );
      return;
    }

    setState(() => _isLoading = true);

    DateTime startDate;
    DateTime endDate;

    if (_isAllDay) {
      startDate = DateTime(_selectedStartDate!.year, _selectedStartDate!.month,
          _selectedStartDate!.day);
      endDate = DateTime(_selectedEndDate!.year, _selectedEndDate!.month,
          _selectedEndDate!.day);
    } else {
      startDate = DateTime(
        _selectedStartDate!.year,
        _selectedStartDate!.month,
        _selectedStartDate!.day,
        _selectedStartTime?.hour ?? 0,
        _selectedStartTime?.minute ?? 0,
      );
      endDate = DateTime(
        _selectedEndDate!.year,
        _selectedEndDate!.month,
        _selectedEndDate!.day,
        _selectedEndTime?.hour ?? 23,
        _selectedEndTime?.minute ?? 59,
      );
    }

    // Tüm attachment path'lerini birleştir
    final List<String> attachmentPaths = [
      ..._selectedImages.map((file) => file.path),
      ..._selectedFiles.map((file) => file.path),
    ];

    final now = DateTime.now();
    final event = EventEntity(
      id: widget.eventId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      startDate: startDate,
      endDate: endDate,
      isAllDay: _isAllDay,
      location: _locationController.text.trim().isEmpty
          ? null
          : _locationController.text.trim(),
      attendees: const [],
      createdAt: _existingEvent?.createdAt ?? now,
      updatedAt: now,
      attachmentPaths: attachmentPaths.isEmpty ? null : attachmentPaths,
    );

    try {
      if (widget.eventRepository != null) {
        if (widget.eventId != null) {
          await widget.eventRepository!.updateEvent(event);
        } else {
          await widget.eventRepository!.createEvent(event);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.eventId != null
                  ? 'Etkinlik güncellendi'
                  : 'Etkinlik oluşturuldu'),
            ),
          );
          Navigator.pop(context, event);
        }
      } else {
        if (mounted) {
          Navigator.pop(context, event);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeriden Seç'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Kamera ile Çek'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.eventId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Etkinliği Düzenle' : 'Yeni Etkinlik'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: false,
      body: DecorativeBackground(
        style: BackgroundStyle.calm,
        child: _isLoading && _existingEvent == null
            ? const Center(child: CircularProgressIndicator())
            : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Başlık *',
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
                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: 'Konum',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Tüm Gün'),
                    subtitle: const Text('Etkinlik tüm gün sürer'),
                    value: _isAllDay,
                    onChanged: (value) {
                      setState(() {
                        _isAllDay = value;
                      });
                    },
                  ),
                  const Divider(),
                  // Başlangıç Tarihi
                  ListTile(
                    title: const Text('Başlangıç Tarihi'),
                    subtitle: Text(
                      _selectedStartDate == null
                          ? 'Tarih seçilmedi'
                          : '${_selectedStartDate!.day}/${_selectedStartDate!.month}/${_selectedStartDate!.year}',
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: _selectStartDate,
                  ),
                  if (!_isAllDay)
                    ListTile(
                      title: const Text('Başlangıç Saati'),
                      subtitle: Text(
                        _selectedStartTime == null
                            ? 'Saat seçilmedi'
                            : _selectedStartTime!.format(context),
                      ),
                      trailing: const Icon(Icons.access_time),
                      onTap: _selectStartTime,
                    ),
                  // Bitiş Tarihi
                  ListTile(
                    title: const Text('Bitiş Tarihi'),
                    subtitle: Text(
                      _selectedEndDate == null
                          ? 'Tarih seçilmedi'
                          : '${_selectedEndDate!.day}/${_selectedEndDate!.month}/${_selectedEndDate!.year}',
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: _selectEndDate,
                  ),
                  if (!_isAllDay)
                    ListTile(
                      title: const Text('Bitiş Saati'),
                      subtitle: Text(
                        _selectedEndTime == null
                            ? 'Saat seçilmedi'
                            : _selectedEndTime!.format(context),
                      ),
                      trailing: const Icon(Icons.access_time),
                      onTap: _selectEndTime,
                    ),
                  const SizedBox(height: 24),
                  const Divider(),
                  // Dosya/Fotoğraf Ekleme Bölümü
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.attach_file),
                        const SizedBox(width: 8),
                        const Text(
                          'Ekler',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.photo),
                          label: const Text('Fotoğraf'),
                          onPressed: _showImageSourceDialog,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.insert_drive_file),
                          label: const Text('Dosya'),
                          onPressed: _pickFile,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Seçilen Fotoğraflar
                  if (_selectedImages.isNotEmpty) ...[
                    const Text(
                      'Seçilen Fotoğraflar',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _selectedImages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    _selectedImages[index],
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: CircleAvatar(
                                    radius: 14,
                                    backgroundColor: Colors.red,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(Icons.close,
                                          size: 16, color: Colors.white),
                                      onPressed: () =>
                                          _removeAttachment(index, true),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  // Seçilen Dosyalar
                  if (_selectedFiles.isNotEmpty) ...[
                    const Text(
                      'Seçilen Dosyalar',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ..._selectedFiles.asMap().entries.map((entry) {
                      final index = entry.key;
                      final file = entry.value;
                      final fileName = path.basename(file.path);
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: const Icon(Icons.insert_drive_file),
                          title: Text(fileName),
                          subtitle: Text(
                              '${(file.lengthSync() / 1024).toStringAsFixed(2)} KB'),
                          trailing: IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () => _removeAttachment(index, false),
                          ),
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 16),
                  ],
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveEvent,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(isEditing ? 'Güncelle' : 'Kaydet'),
                  ),
                ],
              ),
            ),
        ),
    );
  }
}
