// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'Çalışma Takvimi';

  @override
  String get settings => 'Ayarlar';

  @override
  String get aiAssistant => 'AI Asistan';

  @override
  String get newTask => 'Yeni Görev';

  @override
  String get addNewTask => 'Yeni görev ekle';

  @override
  String get deleteTaskTitle => 'Görevi Sil';

  @override
  String deleteTaskConfirm(String taskTitle) {
    return '\"$taskTitle\" görevini silmek istediğinize emin misiniz?';
  }

  @override
  String get cancel => 'İptal';

  @override
  String get delete => 'Sil';

  @override
  String get ok => 'Tamam';

  @override
  String get save => 'Kaydet';

  @override
  String get update => 'Güncelle';

  @override
  String get edit => 'Düzenle';

  @override
  String get selectADay => 'Bir gün seçin';

  @override
  String get selectDayHint =>
      'Takvimden bir tarihe dokunarak görevlerinizi görüntüleyin';

  @override
  String get noTasksForDay => 'Bu güne ait görev yok';

  @override
  String get addTaskHint => 'Yeni görev eklemek için + butonuna dokunun';

  @override
  String get allTasksCompleted => 'Tüm görevler tamamlandı';

  @override
  String taskProgressSummary(int pending, int completed) {
    return '$pending bekleyen • $completed tamamlandı';
  }

  @override
  String get today => 'Bugün';

  @override
  String get tomorrow => 'Yarın';

  @override
  String get yesterday => 'Dün';

  @override
  String get editTask => 'Görevi Düzenle';

  @override
  String get notificationTime => 'Bildirim zamanı';

  @override
  String get notificationCannotBeScheduled => 'Bildirim planlanamıyor.';

  @override
  String get notificationVisibleOnLockScreen =>
      'Bildirim çubuğu ve kilit ekranında görünür.';

  @override
  String get taskUpdated => 'Görev güncellendi';

  @override
  String get taskAdded => 'Görev eklendi';

  @override
  String get myTasks => 'Görevlerim';

  @override
  String get noTasksYet => 'Henüz görev yok';

  @override
  String get addTaskTapPlus => 'Yeni görev eklemek için + butonuna tıklayın';

  @override
  String get taskDeleted => 'Görev silindi';

  @override
  String get priorityLow => 'Düşük';

  @override
  String get priorityMedium => 'Orta';

  @override
  String get priorityHigh => 'Yüksek';

  @override
  String get priorityUnspecified => 'Belirtilmemiş';

  @override
  String get snooze => 'Ertele';

  @override
  String get taskNotFound => 'Görev bulunamadı';

  @override
  String get taskLoadFailed => 'Görev yüklenemedi';

  @override
  String get pleaseSelectDateAndTime => 'Lütfen tarih ve saat seçin';

  @override
  String get snoozeMustBeFuture => 'Erteleme zamanı gelecekte olmalı';

  @override
  String snoozeFailed(String error) {
    return 'Erteleme başarısız: $error';
  }

  @override
  String currentDueDate(String datetime) {
    return 'Mevcut vade: $datetime';
  }

  @override
  String get quickOptions => 'Hızlı seçenekler';

  @override
  String get snooze15Min => '15 dk';

  @override
  String get snooze30Min => '30 dk';

  @override
  String get snooze1Hour => '1 saat';

  @override
  String get snooze3Hours => '3 saat';

  @override
  String get customDateAndTime => 'Özel tarih ve saat';

  @override
  String newReminderAt(String datetime) {
    return 'Yeni hatırlatma: $datetime';
  }

  @override
  String get editEvent => 'Etkinliği Düzenle';

  @override
  String get newEvent => 'Yeni Etkinlik';

  @override
  String get location => 'Konum';

  @override
  String get allDay => 'Tüm Gün';

  @override
  String get allDaySubtitle => 'Etkinlik tüm gün sürer';

  @override
  String get startDate => 'Başlangıç Tarihi';

  @override
  String get startTime => 'Başlangıç Saati';

  @override
  String get endDate => 'Bitiş Tarihi';

  @override
  String get endTime => 'Bitiş Saati';

  @override
  String get pleaseSelectStartEndDates =>
      'Lütfen başlangıç ve bitiş tarihlerini seçin';

  @override
  String get pleaseEnterTitle => 'Lütfen başlık girin';

  @override
  String get titleRequired => 'Başlık *';

  @override
  String get description => 'Açıklama';

  @override
  String get date => 'Tarih';

  @override
  String get time => 'Saat';

  @override
  String get dateNotSelected => 'Tarih seçilmedi';

  @override
  String get timeNotSelected => 'Saat seçilmedi';

  @override
  String get eventUpdated => 'Etkinlik güncellendi';

  @override
  String get eventCreated => 'Etkinlik oluşturuldu';

  @override
  String get eventDetails => 'Etkinlik Detayı';

  @override
  String get monthView => 'Ay Görünümü';

  @override
  String get weekView => 'Hafta Görünümü';

  @override
  String get dayView => 'Gün Görünümü';

  @override
  String yearTitle(int year) {
    return '$year Yılı';
  }

  @override
  String get previousYear => 'Önceki yıl';

  @override
  String get nextYear => 'Sonraki yıl';

  @override
  String get managePreferences => 'Tercihlerinizi Yönetin';

  @override
  String get settingsHeaderSubtitle =>
      'Senkronizasyon, bildirimler ve görünüm ayarlarını buradan düzenleyin.';

  @override
  String get sectionGeneral => 'Genel';

  @override
  String get syncSettings => 'Senkronizasyon Ayarları';

  @override
  String get syncSettingsSubtitle => 'Bulut senkronizasyon ve yedekleme';

  @override
  String get widgetPreview => 'Widget Önizleme';

  @override
  String get widgetPreviewSubtitle => 'Ana ekran widget\'ını önizle';

  @override
  String get sectionPersonalization => 'Kişiselleştirme';

  @override
  String get notifications => 'Bildirimler';

  @override
  String get notificationsSubtitle => 'Bildirim izinleri ve ayarları';

  @override
  String get themeAndFont => 'Tema ve Yazı Tipi';

  @override
  String get themeAndFontSubtitle => 'Açık/koyu tema, renkler ve yazı ayarları';

  @override
  String get sectionApp => 'Uygulama';

  @override
  String get privacyPolicy => 'Gizlilik Politikası';

  @override
  String get privacyPolicySubtitle => 'Veri kullanımı ve KVKK bilgileri';

  @override
  String get about => 'Hakkında';

  @override
  String get aboutSubtitle => 'Uygulama bilgileri ve sürüm';

  @override
  String versionLabel(String version) {
    return 'Sürüm $version';
  }

  @override
  String get aboutDescription =>
      'Görevlerinizi ve etkinliklerinizi tek bir yerden yönetmenizi sağlayan akıllı takvim uygulaması. Günlük planlamadan haftalık görünüme, hatırlatıcılardan bulut senkronizasyonuna kadar ihtiyacınız olan tüm araçlar elinizin altında.';

  @override
  String get features => 'Özellikler';

  @override
  String get featureTaskManagement => 'Görev Yönetimi';

  @override
  String get featureTaskManagementSubtitle =>
      'Görev oluşturun, düzenleyin ve takip edin';

  @override
  String get featureEventCalendar => 'Etkinlik Takvimi';

  @override
  String get featureEventCalendarSubtitle =>
      'Gün, hafta, ay ve yıl görünümleri';

  @override
  String get featureReminders => 'Hatırlatıcılar';

  @override
  String get featureRemindersSubtitle => 'Zamanında bildirimler alın';

  @override
  String get featureCloudSync => 'Bulut Senkronizasyonu';

  @override
  String get featureCloudSyncSubtitle =>
      'Verilerinizi güvenle yedekleyin ve senkronize edin';

  @override
  String get featureAiAssistantSubtitle => 'Programınız hakkında sorular sorun';

  @override
  String get featurePersonalization => 'Kişiselleştirme';

  @override
  String get featurePersonalizationSubtitle =>
      'Tema renkleri ve yazı tipi boyutu';

  @override
  String get developerNote => 'Geliştirici Notu';

  @override
  String get developerNoteBody =>
      'Bu uygulama Flutter ile geliştirilmiştir. Geri bildirimleriniz ve önerileriniz bizim için değerlidir.';

  @override
  String copyright(int year, String appName) {
    return '© $year $appName';
  }

  @override
  String get notificationSettings => 'Bildirim Ayarları';

  @override
  String get enableSync => 'Senkronizasyonu Etkinleştir';

  @override
  String get enableSyncSubtitle => 'Bulut senkronizasyonu aç/kapat';

  @override
  String get autoSync => 'Otomatik Senkronizasyon';

  @override
  String get autoSyncSubtitle => 'Değişiklikleri otomatik olarak senkronize et';

  @override
  String get wifiOnlySync => 'Sadece Wi-Fi\'da Senkronize Et';

  @override
  String get wifiOnlySyncSubtitle => 'Mobil veri kullanımını azalt';

  @override
  String get manualSync => 'Manuel Senkronizasyon';

  @override
  String get syncNow => 'Şimdi senkronize et';

  @override
  String get syncStarted => 'Senkronizasyon başlatıldı';

  @override
  String get lastSync => 'Son Senkronizasyon';

  @override
  String get notSyncedYet => 'Henüz senkronize edilmedi';

  @override
  String get appearance => 'Görünüm';

  @override
  String get themeColors => 'Tema Renkleri';

  @override
  String get fontAndSize => 'Yazı Tipi & Boyut';

  @override
  String get lightMode => 'Açık';

  @override
  String get darkMode => 'Koyu';

  @override
  String get error => 'Hata';

  @override
  String get taskIdRequired => 'Görev ID gerekli';

  @override
  String get eventIdRequired => 'Etkinlik ID gerekli';

  @override
  String get eventSharing => 'Etkinlik Paylaşımı';

  @override
  String eventIdLabel(String eventId) {
    return 'Etkinlik ID: $eventId';
  }

  @override
  String get eventInfoNotFound => 'Etkinlik bilgisi bulunamadı';

  @override
  String get calendarOperations => 'Takvim İşlemleri';

  @override
  String get featureComingSoon => 'Bu özellik yakında eklenecek';

  @override
  String get pageNotFound => 'Sayfa Bulunamadı';

  @override
  String pageNotFoundWithRoute(String routeName) {
    return 'Sayfa bulunamadı: $routeName';
  }

  @override
  String get unknown => 'Bilinmiyor';

  @override
  String timezoneLabel(String timezone) {
    return 'Zaman Dilimi: $timezone';
  }

  @override
  String get calendarSharing => 'Takvim Paylaşımı';

  @override
  String calendarNameLabel(String calendarName) {
    return 'Takvim: $calendarName';
  }

  @override
  String get calendarImport => 'Takvim İçe Aktarma';

  @override
  String get importingCalendar => 'Takvim içe aktarılıyor...';

  @override
  String sourceTimezoneLabel(String timezone) {
    return 'Kaynak Zaman Dilimi: $timezone';
  }

  @override
  String get invalidDeepLink => 'Geçersiz deep link';

  @override
  String get tryAgain => 'Tekrar Dene';

  @override
  String errorWithMessage(String message) {
    return 'Hata: $message';
  }

  @override
  String get shareEvent => 'Etkinliği Paylaş';

  @override
  String get shareCalendar => 'Takvimi Paylaş';

  @override
  String get importCalendar => 'Takvim İçe Aktar';

  @override
  String get share => 'Paylaş';

  @override
  String get aiWelcomeMessage =>
      'Merhaba! 👋 Ben kişisel takvim asistanınızım. Programınız hakkında bana soru sorabilirsiniz.';

  @override
  String get aiErrorMessage =>
      'Üzgünüm, bir hata oluştu. Lütfen tekrar deneyin.';

  @override
  String get aiReady => 'Takvim asistanınız hazır!';

  @override
  String get aiInputHint => 'Sorunuzu yazın...';

  @override
  String get aiSuggestionToday => 'Bugün ne yapmalıyım?';

  @override
  String get aiSuggestionNextEvent => 'Sıradaki etkinliğim ne?';

  @override
  String get aiSuggestionFreeTime => 'Boş zamanım var mı?';

  @override
  String get aiSuggestionOverdue => 'Geciken görevlerim var mı?';

  @override
  String get aiSuggestionTomorrow => 'Yarın ne var?';

  @override
  String get aiSuggestionWeekend => 'Hafta sonu planım ne?';

  @override
  String get aiSuggestionPriorities => 'Öncelikli görevlerim neler?';

  @override
  String get aiSuggestionWeekSummary => 'Bu hafta özeti';

  @override
  String get noNotificationNoDate =>
      'Tarih seçilmediği için bildirim planlanmaz.';

  @override
  String get noNotificationPastTask =>
      'Geçmiş bir görev için bildirim planlanmaz.';

  @override
  String get noRemindersTaskTooSoon => '• Hatırlatıcı yok (görev çok yakın)';

  @override
  String reminderBefore(String label, String datetime) {
    return '• $label kala: $datetime';
  }

  @override
  String get oneHour => '1 saat';

  @override
  String get thirtyMinutes => '30 dakika';

  @override
  String get themeSettingsLoadFailed => 'Tema ayarları yüklenemedi.';

  @override
  String get fontPreviewSample => 'Örnek metin — Çalışma Takvimi';

  @override
  String get themeColorBlue => 'Mavi';

  @override
  String get themeColorPurple => 'Mor';

  @override
  String get themeColorGreen => 'Yeşil';

  @override
  String get themeColorOrange => 'Turuncu';

  @override
  String get themeColorRed => 'Kırmızı';

  @override
  String get themeColorPink => 'Pembe';

  @override
  String get themeColorTeal => 'Turkuaz';

  @override
  String get themeColorCyan => 'Cyan';

  @override
  String get themeColorIndigo => 'Çivit Mavi';

  @override
  String get themeColorBrown => 'Kahverengi';

  @override
  String get themeColorGrey => 'Gri';

  @override
  String get themeColorAmber => 'Kehribar';

  @override
  String get themeColorDeepPurple => 'Koyu Mor';

  @override
  String get themeColorLightBlue => 'Açık Mavi';

  @override
  String get themeColorLime => 'Limon';

  @override
  String get themeColorDeepOrange => 'Koyu Turuncu';

  @override
  String get themeColorBlueGrey => 'Mavi Gri';

  @override
  String get themeColorYellow => 'Sarı';

  @override
  String get themeColorLightGreen => 'Açık Yeşil';

  @override
  String get themeColorRedAccent => 'Kırmızı Vurgu';

  @override
  String get themeColorGreenAccent => 'Yeşil Vurgu';

  @override
  String get themeColorBlueAccent => 'Mavi Vurgu';

  @override
  String photoSelectError(String error) {
    return 'Fotoğraf seçilirken hata: $error';
  }

  @override
  String fileSelectError(String error) {
    return 'Dosya seçilirken hata: $error';
  }

  @override
  String get chooseFromGallery => 'Galeriden Seç';

  @override
  String get takeWithCamera => 'Kamera ile Çek';

  @override
  String get attachments => 'Ekler';

  @override
  String get photo => 'Fotoğraf';

  @override
  String get file => 'Dosya';

  @override
  String get selectedPhotos => 'Seçilen Fotoğraflar';

  @override
  String get selectedFiles => 'Seçilen Dosyalar';

  @override
  String get eventTitle => 'Başlık';

  @override
  String get eventDescriptionPlaceholder => 'Açıklama girin (isteğe bağlı)';

  @override
  String get weekPrefix => 'Hafta: ';

  @override
  String get eventRepositoryNotFound => 'Event repository bulunamadı';

  @override
  String eventsLoadError(String error) {
    return 'Etkinlikler yüklenirken hata oluştu: $error';
  }

  @override
  String eventsOnDate(int count) {
    return 'Bu tarihte $count etkinlik var.';
  }

  @override
  String get retry => 'Yeniden Dene';

  @override
  String yearEventDensity(int year) {
    return '$year Yılı - Etkinlik Yoğunluğu';
  }

  @override
  String get heatmapSubtitle =>
      'Günlük etkinlik sayısına göre renklendirilmiş yıllık takvim';

  @override
  String get heatmapLegendLess => 'Az';

  @override
  String get heatmapLegendMore => 'Çok';

  @override
  String eventsCount(int count) {
    return '$count etkinlik';
  }

  @override
  String get lightTheme => 'Açık Tema';

  @override
  String get darkTheme => 'Koyu Tema';

  @override
  String get themeSettings => 'Tema Ayarları';

  @override
  String get appearanceMode => 'Görünüm Modu';

  @override
  String get colorScheme => 'Renk Şeması';

  @override
  String get previewControls => 'Önizleme Kontrolleri';

  @override
  String get selectMonth => 'Ay Seç';

  @override
  String get selectToday => 'Bugünü Seç';

  @override
  String get sampleTasks => 'Örnek Görevler';

  @override
  String tasksLoaded(int count) {
    return '$count görev yüklendi';
  }

  @override
  String get refresh => 'Yenile';

  @override
  String get livePreview => 'Canlı Önizleme';

  @override
  String get livePreviewSubtitle =>
      'Takvim ve görev widgetlarının görünümünü buradan önizleyebilirsiniz.';

  @override
  String get calendarWidget => 'Takvim Widget';

  @override
  String get taskListWidget => 'Görev Listesi Widget';

  @override
  String taskTapped(String taskTitle) {
    return 'Görev tıklandı: $taskTitle';
  }

  @override
  String get previewInfo =>
      'Tema ayarlarınızı değiştirerek widgetların farklı görünümlerini test edebilirsiniz.';

  @override
  String get recipientTimezoneOptional => 'Alıcının Zaman Dilimi (Opsiyonel)';

  @override
  String get selectTimezone => 'Zaman dilimi seçin';

  @override
  String get timezoneWarning => 'Zaman Dilimi Uyarısı';

  @override
  String eventsWillBeShared(int count) {
    return '$count etkinlik paylaşılacak';
  }

  @override
  String eventsTimezoneAdjustWarning(String warning, int count) {
    return '$warning\n\n$count etkinlik zaman dilimine göre ayarlanacak.';
  }

  @override
  String get selectIcsFile => '.ics formatında bir takvim dosyası seçin';

  @override
  String get sourceTimezoneOptional => 'Kaynak Zaman Dilimi (Opsiyonel)';

  @override
  String get senderTimezone => 'Gönderenin zaman dilimi';

  @override
  String get autoDetect => 'Otomatik Tespit';

  @override
  String get chooseFile => 'Dosya Seç';

  @override
  String fileSelectionError(String error) {
    return 'Dosya seçim hatası: $error';
  }

  @override
  String importSuccessCount(int count) {
    return '$count etkinlik başarıyla içe aktarıldı!';
  }

  @override
  String get importFailed => 'Etkinlik içe aktarılamadı.';

  @override
  String get importSuccessful => 'İçe Aktarma Başarılı';

  @override
  String get shareExamplesTitle => 'Takvim Paylaşım Örnekleri';

  @override
  String get shareSingleEvent => 'Tek Etkinlik Paylaş';

  @override
  String get shareAllCalendar => 'Tüm Takvimi Paylaş';

  @override
  String get eventSharedSuccess => 'Etkinlik başarıyla paylaşıldı';

  @override
  String shareError(String error) {
    return 'Paylaşım hatası: $error';
  }

  @override
  String get calendarShareTitle => 'Takvim Paylaşımı';

  @override
  String get calendarShareBody => 'İşte tüm takviminiz';

  @override
  String eventsSharedSuccess(int count) {
    return '$count etkinlik başarıyla paylaşıldı';
  }

  @override
  String eventsAdjustedForTimezone(int count) {
    return '$count etkinlik zaman diliminize göre ayarlandı.';
  }

  @override
  String importError(String error) {
    return 'İçe aktarma hatası: $error';
  }

  @override
  String get exactAlarmEnabledMsg => 'Kesin alarm izni açık.';

  @override
  String get exactAlarmStillDisabledMsg =>
      'Kesin alarm izni hâlâ kapalı. Açılan ayar ekranından \"Kesin alarmlar\"ı etkinleştirin.';

  @override
  String get notificationPermissionGranted => 'Bildirim izni verildi!';

  @override
  String get notificationPermissionDenied =>
      'Bildirim izni reddedildi. Ayarlardan manuel olarak açabilirsiniz.';

  @override
  String get notificationPermissionDialogTitle => 'Bildirim İzni';

  @override
  String get notificationPermissionInstructions =>
      'Lütfen cihaz ayarlarından \"Work Schedule\" uygulamasının bildirim izinlerini açın:\n\n1. Ayarlar uygulamasını açın\n2. \"Uygulamalar\" veya \"Apps\" seçeneğine gidin\n3. \"Work Schedule\" uygulamasını bulun\n4. \"Bildirimler\" (Notifications) seçeneğine gidin\n5. Bildirimleri etkinleştirin';

  @override
  String get exactAlarmPermissionTitle => 'Kesin Alarm İzni';

  @override
  String get exactAlarmInstructions =>
      'Zamanında hatırlatma için:\n\nAyarlar → Uygulamalar → Work Schedule → İzinler → Saat ve Alarm → Kesin alarmlar';

  @override
  String get exactAlarmPermissionLabel => 'Kesin alarm izni';

  @override
  String get exactAlarmEnabledHint =>
      'Hatırlatıcılar zamanında gönderilebilir.';

  @override
  String get exactAlarmDisabledHint => 'Kapalıysa bildirimler gecikebilir.';

  @override
  String get statusOn => 'Açık';

  @override
  String get statusOff => 'Kapalı';

  @override
  String get requestPermission => 'İzin iste';

  @override
  String get goToSettings => 'Ayarlara git';

  @override
  String get howToEnable => 'Nasıl açılır?';

  @override
  String get notificationGrantedActive =>
      'Bildirim izni verildi. Görev hatırlatıcıları aktif.';

  @override
  String get notificationDeniedInactive =>
      'Bildirim izni verilmedi. Görev hatırlatıcıları çalışmayacak.';

  @override
  String get requestNotificationPermission => 'Bildirim İzni İste';

  @override
  String get refreshStatus => 'Durumu Yenile';

  @override
  String get scheduledNotifications => 'Zamanlanmış Bildirimler';

  @override
  String get scheduledNotificationsDesc =>
      'Görev bildirimleri 1 saat ve 30 dakika önce gelir; vade anında durum bildirilir.';

  @override
  String get noPendingNotifications =>
      'Bekleyen bildirim yok. Tarih ve saatli görev ekleyin.';

  @override
  String get notificationDefaultTitle => 'Bildirim';

  @override
  String get refreshList => 'Listeyi Yenile';

  @override
  String get infoTitle => 'Bilgi';

  @override
  String get notificationInfoBlock =>
      'Görev bildirimleri görev saatinden 1 saat ve 30 dakika önce gelir.\n  Örnek: Görev 15:00 → 14:00 ve 14:30\n\n• Vade anında tamamlanma durumu renkli bildirimle gösterilir.\n  Yeşil: tamamlandı, Kırmızı: tamamlanmadı\n\n• Bildirime dokunmak veya Ertele tuşu görevi 30 dk erteler.\n  Yeni saat takvimde otomatik güncellenir.\n\n• Saat seçilmezse görev 09:00 varsayılır.\n\n• Bildirim izni + Kesin alarmlar izni birlikte açık olmalıdır.';

  @override
  String lastUpdatedLabel(String date) {
    return 'Son güncelleme: $date';
  }

  @override
  String get privacyLastUpdatedDate => '8 Haziran 2026';

  @override
  String get privacyIntroTitle => 'Giriş';

  @override
  String get privacyIntroBody =>
      'Bu Gizlilik Politikası, Çalışma Takvimi mobil uygulamasını kullandığınızda kişisel verilerinizin nasıl toplandığını, kullanıldığını, saklandığını ve korunduğunu açıklar. Uygulamayı kullanarak bu politikayı kabul etmiş sayılırsınız.';

  @override
  String get privacyDataControllerTitle => 'Veri Sorumlusu';

  @override
  String privacyDataControllerBullet1(String controller) {
    return 'Veri sorumlusu: $controller';
  }

  @override
  String get privacyDataControllerBullet2 => 'Uygulama: Çalışma Takvimi';

  @override
  String get privacyDataControllerBullet3 =>
      'Paket adı: com.Appworkschedule.app';

  @override
  String privacyDataControllerBullet4(String email) {
    return 'İletişim: $email';
  }

  @override
  String get privacyDataCollectedTitle => 'Toplanan Veriler';

  @override
  String get privacyDataCollectedIntro =>
      'Uygulama aşağıdaki veri kategorilerini toplayabilir:';

  @override
  String get privacyDataCollectedBullet1 =>
      'Hesap bilgileri: e-posta, şifre (Firebase tarafından güvenli işlenir), Google profil bilgileri';

  @override
  String get privacyDataCollectedBullet2 =>
      'Görev ve etkinlik verileri: başlık, açıklama, tarihler, öncelik, konum, katılımcılar';

  @override
  String get privacyDataCollectedBullet3 =>
      'Etkinlik ekleri: fotoğraf ve dosyalar';

  @override
  String get privacyDataCollectedBullet4 =>
      'Google Takvim verileri (senkronizasyon etkinse)';

  @override
  String get privacyDataCollectedBullet5 =>
      'Tercihler: tema, bildirim ve senkronizasyon ayarları';

  @override
  String get privacyDataCollectedBullet6 =>
      'Cihaz saat dilimi (hatırlatıcılar için)';

  @override
  String get privacyDataCollectedBullet7 =>
      '\"Beni hatırla\" seçeneğiyle kaydedilen giriş bilgileri (cihazda yerel)';

  @override
  String get privacyDataUseTitle => 'Verilerin Kullanım Amaçları';

  @override
  String get privacyDataUseBullet1 => 'Hesap oluşturma ve kimlik doğrulama';

  @override
  String get privacyDataUseBullet2 => 'Görev ve etkinlik yönetimi';

  @override
  String get privacyDataUseBullet3 => 'Hatırlatıcı ve bildirim gönderimi';

  @override
  String get privacyDataUseBullet4 => 'Bulut senkronizasyonu ve yedekleme';

  @override
  String get privacyDataUseBullet5 => 'Google Takvim senkronizasyonu';

  @override
  String get privacyDataUseBullet6 => 'Takvim paylaşımı ve dışa aktarma';

  @override
  String get privacyDataUseBullet7 => 'AI Asistan ile program bilgisi sunma';

  @override
  String get privacyDataUseBullet8 => 'Uygulama güvenliği';

  @override
  String get privacyLegalBasisTitle => 'Hukuki Dayanak (KVKK)';

  @override
  String get privacyLegalBasisBody =>
      'Kişisel verileriniz KVKK kapsamında sözleşmenin ifası, meşru menfaat ve açık rızanız (Google bağlantısı, bildirim, kamera/galeri izinleri) hukuki sebeplerine dayanılarak işlenir.';

  @override
  String get privacyStorageTitle => 'Verilerin Saklanması';

  @override
  String get privacyStorageBullet1 =>
      'Görev ve etkinlikler cihazınızdaki SQLite veritabanında saklanır';

  @override
  String get privacyStorageBullet2 =>
      'Senkronizasyon etkinse veriler Google Firebase (Firestore) üzerinde saklanır';

  @override
  String get privacyStorageBullet3 =>
      'Ayarlar SharedPreferences ile cihazınızda saklanır';

  @override
  String get privacyStorageBullet4 =>
      'Ekler uygulama belgeler dizininde saklanır';

  @override
  String get privacyStorageBody =>
      'Verileriniz hesabınız aktif olduğu sürece saklanır. Hesap silme talebinde yasal yükümlülükler saklı kalmak kaydıyla verileriniz silinir.';

  @override
  String get privacyThirdPartyTitle => 'Üçüncü Taraf Hizmetler';

  @override
  String get privacyThirdPartyBullet1 =>
      'Google Firebase (kimlik doğrulama ve bulut veritabanı)';

  @override
  String get privacyThirdPartyBullet2 =>
      'Google Sign-In ve Google Takvim API (isteğe bağlı)';

  @override
  String get privacyThirdPartyBullet3 =>
      'Google Fonts (yazı tipleri; IP adresi iletilebilir)';

  @override
  String get privacyThirdPartyBody =>
      'Bu hizmet sağlayıcılar kendi gizlilik politikalarına tabidir.';

  @override
  String get privacyPermissionsTitle => 'Cihaz İzinleri';

  @override
  String get privacyPermissionsBullet1 => 'Bildirimler: hatırlatıcılar için';

  @override
  String get privacyPermissionsBullet2 =>
      'Kamera ve galeri: etkinlik fotoğrafları için';

  @override
  String get privacyPermissionsBullet3 =>
      'Dosya erişimi: içe/dışa aktarma için';

  @override
  String get privacyPermissionsBullet4 =>
      'İnternet: bulut senkronizasyonu için';

  @override
  String get privacyPermissionsBullet5 =>
      'Cihaz yeniden başlatma: hatırlatıcıları yeniden planlamak için';

  @override
  String get privacyPermissionsBody =>
      'İzinleri cihaz ayarlarınızdan istediğiniz zaman geri alabilirsiniz.';

  @override
  String get privacyAiTitle => 'AI Asistan';

  @override
  String get privacyAiBody =>
      'AI Asistan varsayılan olarak yerel modda çalışır; görev ve etkinlik verilerinize erişir ancak bunları üçüncü taraflara göndermez. Harici bir yapay zeka API\'si yapılandırılırsa soru metniniz ilgili sağlayıcıya iletilebilir.';

  @override
  String get privacySecurityTitle => 'Veri Güvenliği';

  @override
  String get privacySecurityBody =>
      'Verilerinizi korumak için endüstri standardı güvenlik önlemleri uygulanır. Firebase iletişimi şifrelenmiş bağlantılar (HTTPS/TLS) üzerinden gerçekleştirilir.';

  @override
  String get privacySharingTitle => 'Veri Paylaşımı';

  @override
  String get privacySharingBody =>
      'Kişisel verilerinizi satmayız. Veriler yalnızca hizmet sunumu için gerekli sağlayıcılarla, sizin talebinizle (paylaşım/dışa aktarma) veya yasal zorunluluk halinde paylaşılabilir.';

  @override
  String get privacyRightsTitle => 'Kullanıcı Haklarınız (KVKK Madde 11)';

  @override
  String get privacyRightsBullet1 =>
      'Verilerinizin işlenip işlenmediğini öğrenme';

  @override
  String get privacyRightsBullet2 => 'İşlenmişse bilgi talep etme';

  @override
  String get privacyRightsBullet3 =>
      'Eksik veya yanlış verilerin düzeltilmesini isteme';

  @override
  String get privacyRightsBullet4 =>
      'Verilerin silinmesini veya yok edilmesini isteme';

  @override
  String get privacyRightsBullet5 => 'Otomatik analiz sonuçlarına itiraz etme';

  @override
  String get privacyRightsBullet6 => 'Zararın giderilmesini talep etme';

  @override
  String privacyRightsBody(String email) {
    return 'Haklarınızı kullanmak için $email adresine başvurabilirsiniz. Talebiniz en geç 30 gün içinde yanıtlanacaktır.';
  }

  @override
  String get privacyChildrenTitle => 'Çocukların Gizliliği';

  @override
  String get privacyChildrenBody =>
      'Uygulama 13 yaşın altındaki çocuklara yönelik değildir. Bilerek bu yaş grubundan kişisel veri toplamıyoruz.';

  @override
  String get privacyTransferTitle => 'Uluslararası Veri Aktarımı';

  @override
  String get privacyTransferBody =>
      'Firebase ve Google hizmetleri verilerinizi Türkiye dışındaki sunucularda işleyebilir. Bu aktarım KVKK\'nın 9. maddesi kapsamındaki güvenceler çerçevesinde gerçekleşir.';

  @override
  String get privacyChangesTitle => 'Politika Değişiklikleri';

  @override
  String get privacyChangesBody =>
      'Bu politika zaman zaman güncellenebilir. Önemli değişikliklerde uygulama içi bildirim veya güncellenmiş tarih ile bilgilendirilirsiniz.';

  @override
  String get privacyContactTitle => 'İletişim';

  @override
  String privacyContactBody(String controller, String email) {
    return 'Gizlilik politikası veya kişisel verileriniz hakkında sorularınız için veri sorumlusu $controller ($email) adresine yazabilirsiniz.';
  }

  @override
  String get packageName => 'com.Appworkschedule.app';

  @override
  String get taskReminderChannelName => 'Görev Hatırlatıcıları';

  @override
  String get taskReminderChannelDesc =>
      'Görevler için 1 saat ve 30 dakika önce hatırlatma';

  @override
  String get eventReminderChannelName => 'Hatırlatıcı Bildirimleri';

  @override
  String get eventReminderChannelDesc => 'Etkinlik hatırlatıcıları';

  @override
  String get taskNotificationChannelName => 'Görev Bildirimleri';

  @override
  String get taskNotificationChannelDesc =>
      'Tamamlama ve erteleme bildirimleri';

  @override
  String get taskCompletedTitle => 'Görev Tamamlandı ✓';

  @override
  String get taskNotCompletedTitle => 'Görev Tamamlanmadı';

  @override
  String taskCompletedOnTime(String title, String dueTime) {
    return '\"$title\" $dueTime için zamanında tamamlanmış.';
  }

  @override
  String taskNotCompletedOverdue(String title, String dueTime) {
    return '\"$title\" süresi doldu ($dueTime). Henüz tamamlanmadı.';
  }

  @override
  String get completeAction => 'Tamamla';

  @override
  String get snoozeAction => 'Ertele';

  @override
  String get notificationPermissionRequired =>
      'Bildirim izni verilmedi. Ayarlar > Bildirimler bölümünden izin verin.';

  @override
  String get exactAlarmPermissionRequired =>
      'Kesin alarm izni gerekli. Ayarlar > İzinler > Saat ve Alarm bölümünden açın.';

  @override
  String get testNotificationTitle => 'Test Bildirimi';

  @override
  String get testNotificationBody =>
      'Eğer bunu görüyorsanız bildirimler çalışıyor!';

  @override
  String get taskCompletedNotificationTitle => 'Görev Tamamlandı';

  @override
  String taskCompletedNotificationBody(String title) {
    return '\"$title\" tamamlandı olarak işaretlendi.';
  }

  @override
  String get taskSnoozedTitle => 'Görev Ertelendi';

  @override
  String taskSnoozedBody(String title, String datetime) {
    return '\"$title\" → $datetime';
  }

  @override
  String get taskReminderTitle => 'Görev Hatırlatıcısı';

  @override
  String taskReminderBody(String dueDate, String dueTime, String label) {
    return '$dueDate saat $dueTime — $label kaldı';
  }

  @override
  String get notificationScheduled => 'Bildirim zamanlandı';

  @override
  String get notificationNotScheduled => 'Bildirim zamanlanamadı';

  @override
  String get eventReminderTitle => 'Etkinlik Hatırlatıcısı';

  @override
  String get aiTodaySchedule => 'Bugünkü Programınız';

  @override
  String get aiTasksUnavailable => 'Görev bilgilerine erişilemiyor.';

  @override
  String get aiGreetingHello => 'Merhaba';

  @override
  String get aiGreetingMorning => 'Günaydın';

  @override
  String get aiGreetingEvening => 'İyi akşamlar';

  @override
  String get aiHelpIntro =>
      'Ben kişisel takvim asistanınızım. Bana şunları sorabilirsiniz:\n• \"Bugün ne yapmalıyım?\"\n• \"Sıradaki etkinliğim ne?\"\n• \"Geciken görevlerim var mı?\"\n• \"Boş zamanım var mı?\"\n\nTüm komutlar için \"yardım\" yazabilirsiniz.';

  @override
  String shareEventText(String title) {
    return 'Etkinlik: $title';
  }

  @override
  String get defaultCalendarName => 'WorkSchedule Takvimi';

  @override
  String timezoneCheckError(String error) {
    return 'Zaman dilimi kontrol hatası: $error';
  }

  @override
  String get aiEventsLoadError => 'Etkinlikler yüklenirken bir hata oluştu.';

  @override
  String get aiEventsUnavailable => 'Etkinlik bilgilerine erişilemiyor.';

  @override
  String get aiTasksLoadError => 'Görevler yüklenirken bir hata oluştu.';

  @override
  String get aiNoEventsThisWeek =>
      'Bu hafta için planlanmış etkinlik bulunmuyor.';

  @override
  String get aiWeekendPlan => 'Hafta Sonu Planınız';

  @override
  String get aiWeekendNoEvents =>
      'Hafta sonu için planlanmış etkinlik bulunmuyor.';

  @override
  String get aiWeekendEmpty =>
      'Hafta sonu için henüz planlanmış bir şey görünmüyor. Dinlenmek için güzel bir fırsat! 🌿';

  @override
  String get aiNoOverdueTasks =>
      'Harika! Geciken göreviniz yok. Her şey yolunda! 🎉';

  @override
  String get aiOverdueTasksTitle => 'Geciken Görevler';

  @override
  String aiOverdueTasksCount(int count) {
    return 'Geciken Görevler ($count adet)';
  }

  @override
  String get aiNoPriorityTasks => 'Yüksek öncelikli bekleyen göreviniz yok.';

  @override
  String get aiPriorityTasksTitle => 'Öncelikli Görevler';

  @override
  String get aiNextEventTitle => 'Sıradaki Etkinliğiniz';

  @override
  String get aiNoUpcomingEvents =>
      'Önümüzdeki 30 gün içinde planlanmış etkinlik bulunmuyor.';

  @override
  String get aiTomorrowProgram => 'Yarınki Programınız';

  @override
  String get aiTomorrowEmpty =>
      'Yarın için henüz planlanmış etkinlik veya görev görünmüyor.';

  @override
  String get aiFreeTimeTitle => 'Bugünkü Boş Zamanlarınız';

  @override
  String get aiBusyToday =>
      'Bugün çok yoğun görünüyorsunuz! Boş zaman bulunmuyor. Dinlenmeyi unutmayın! 😊';

  @override
  String get aiTaskSummary => 'Görev Özeti';

  @override
  String get aiWeekSummaryTitle => 'Bu Hafta Özeti';

  @override
  String get aiWeekEventsTitle => 'Bu Hafta Etkinlikleri';

  @override
  String get aiTodayEmpty =>
      'Bugün için planlanmış etkinlik veya görev görünmüyor. Rahat bir gününüz var! 🎉';

  @override
  String get aiHelpFull =>
      '🤖 **AI Asistan Yardım**\n\nBen size şu konularda yardımcı olabilirim:\n\n📅 **Günlük Plan:**\n• \"Bugün ne yapmalıyım?\"\n• \"Yarın ne var?\"\n• \"Hafta sonu planım ne?\"\n• \"Boş zamanım var mı?\"\n• \"Bugün yoğun muyum?\"\n\n📌 **Etkinlikler:**\n• \"Sıradaki etkinliğim ne?\"\n• \"Bu hafta ne planlı?\"\n• \"Etkinliklerim neler?\"\n\n✅ **Görevler:**\n• \"Görevlerim neler?\"\n• \"Geciken görevlerim var mı?\"\n• \"Öncelikli görevlerim neler?\"\n• \"Tamamlanmamış görevler\"\n\n📊 **Özet:**\n• \"Bu hafta özeti\"\n• \"Haftalık özet\"\n\nSormak istediğiniz herhangi bir soruyu doğal dil ile sorabilirsiniz!';

  @override
  String get aiDefaultResponse =>
      '🤖 Anlamadım, ama şunları sorabilirsiniz:\n\n• \"Bugün ne yapmalıyım?\"\n• \"Sıradaki etkinliğim ne?\"\n• \"Geciken görevlerim var mı?\"\n• \"Boş zamanım var mı?\"\n• \"Hafta sonu planım ne?\"\n• \"Bu hafta özeti\"\n\nDaha fazla yardım için \"yardım\" yazabilirsiniz.';

  @override
  String get wearOsNextEvent => 'Sonraki Etkinlik';

  @override
  String wearOsUrgentTasks(int count) {
    return 'Acil Görevler ($count)';
  }

  @override
  String get wearOsTodayTasks => 'Bugünkü Görevler';

  @override
  String get wearOsTasksLabel => 'Görevler';

  @override
  String get wearOsEventsLabel => 'Etkinlikler';

  @override
  String get wearOsOverdue => 'Süresi doldu';

  @override
  String get eventCardExamplesTitle => 'Etkinlik Kartı Örnekleri';

  @override
  String aiAndMoreTasks(int count) {
    return '... ve $count görev daha';
  }

  @override
  String aiDaysOverdue(int days) {
    return '$days gün gecikti';
  }

  @override
  String get aiRecommendPrioritize =>
      '\n💡 Bu görevleri önceliklendirmenizi öneririm.';

  @override
  String get wearOsNoData => 'Veri bulunamadı';

  @override
  String get wearOsDailySummaryTitle => '📊 Bugünün Özeti';
}
