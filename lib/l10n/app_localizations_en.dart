// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Work Schedule';

  @override
  String get settings => 'Settings';

  @override
  String get aiAssistant => 'AI Assistant';

  @override
  String get newTask => 'New Task';

  @override
  String get addNewTask => 'Add new task';

  @override
  String get deleteTaskTitle => 'Delete Task';

  @override
  String deleteTaskConfirm(String taskTitle) {
    return 'Are you sure you want to delete \"$taskTitle\"?';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get ok => 'OK';

  @override
  String get save => 'Save';

  @override
  String get update => 'Update';

  @override
  String get edit => 'Edit';

  @override
  String get selectADay => 'Select a day';

  @override
  String get selectDayHint => 'Tap a date on the calendar to view your tasks';

  @override
  String get noTasksForDay => 'No tasks for this day';

  @override
  String get addTaskHint => 'Tap + to add a new task';

  @override
  String get allTasksCompleted => 'All tasks completed';

  @override
  String taskProgressSummary(int pending, int completed) {
    return '$pending pending • $completed completed';
  }

  @override
  String get today => 'Today';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get editTask => 'Edit Task';

  @override
  String get notificationTime => 'Notification time';

  @override
  String get notificationCannotBeScheduled =>
      'Notification cannot be scheduled.';

  @override
  String get notificationVisibleOnLockScreen =>
      'Visible in notification bar and lock screen.';

  @override
  String get taskUpdated => 'Task updated';

  @override
  String get taskAdded => 'Task added';

  @override
  String get myTasks => 'My Tasks';

  @override
  String get noTasksYet => 'No tasks yet';

  @override
  String get addTaskTapPlus => 'Tap + to add a new task';

  @override
  String get taskDeleted => 'Task deleted';

  @override
  String get priorityLow => 'Low';

  @override
  String get priorityMedium => 'Medium';

  @override
  String get priorityHigh => 'High';

  @override
  String get priorityUnspecified => 'Unspecified';

  @override
  String get snooze => 'Snooze';

  @override
  String get taskNotFound => 'Task not found';

  @override
  String get taskLoadFailed => 'Failed to load task';

  @override
  String get pleaseSelectDateAndTime => 'Please select date and time';

  @override
  String get snoozeMustBeFuture => 'Snooze time must be in the future';

  @override
  String snoozeFailed(String error) {
    return 'Snooze failed: $error';
  }

  @override
  String currentDueDate(String datetime) {
    return 'Current due: $datetime';
  }

  @override
  String get quickOptions => 'Quick options';

  @override
  String get snooze15Min => '15 min';

  @override
  String get snooze30Min => '30 min';

  @override
  String get snooze1Hour => '1 hour';

  @override
  String get snooze3Hours => '3 hours';

  @override
  String get customDateAndTime => 'Custom date and time';

  @override
  String newReminderAt(String datetime) {
    return 'New reminder: $datetime';
  }

  @override
  String get editEvent => 'Edit Event';

  @override
  String get newEvent => 'New Event';

  @override
  String get location => 'Location';

  @override
  String get allDay => 'All Day';

  @override
  String get allDaySubtitle => 'Event lasts all day';

  @override
  String get startDate => 'Start Date';

  @override
  String get startTime => 'Start Time';

  @override
  String get endDate => 'End Date';

  @override
  String get endTime => 'End Time';

  @override
  String get pleaseSelectStartEndDates => 'Please select start and end dates';

  @override
  String get pleaseEnterTitle => 'Please enter a title';

  @override
  String get titleRequired => 'Title *';

  @override
  String get description => 'Description';

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String get dateNotSelected => 'No date selected';

  @override
  String get timeNotSelected => 'No time selected';

  @override
  String get eventUpdated => 'Event updated';

  @override
  String get eventCreated => 'Event created';

  @override
  String get eventDetails => 'Event Details';

  @override
  String get monthView => 'Month View';

  @override
  String get weekView => 'Week View';

  @override
  String get dayView => 'Day View';

  @override
  String yearTitle(int year) {
    return 'Year $year';
  }

  @override
  String get previousYear => 'Previous year';

  @override
  String get nextYear => 'Next year';

  @override
  String get managePreferences => 'Manage Your Preferences';

  @override
  String get settingsHeaderSubtitle =>
      'Adjust sync, notifications, and appearance settings here.';

  @override
  String get sectionGeneral => 'General';

  @override
  String get syncSettings => 'Sync Settings';

  @override
  String get syncSettingsSubtitle => 'Cloud sync and backup';

  @override
  String get widgetPreview => 'Widget Preview';

  @override
  String get widgetPreviewSubtitle => 'Preview home screen widget';

  @override
  String get sectionPersonalization => 'Personalization';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationsSubtitle => 'Notification permissions and settings';

  @override
  String get themeAndFont => 'Theme & Font';

  @override
  String get themeAndFontSubtitle =>
      'Light/dark theme, colors, and text settings';

  @override
  String get sectionApp => 'App';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicySubtitle => 'Data usage and privacy information';

  @override
  String get about => 'About';

  @override
  String get aboutSubtitle => 'App info and version';

  @override
  String versionLabel(String version) {
    return 'Version $version';
  }

  @override
  String get aboutDescription =>
      'A smart calendar app that lets you manage tasks and events in one place. From daily planning to weekly views, reminders to cloud sync — all the tools you need are at your fingertips.';

  @override
  String get features => 'Features';

  @override
  String get featureTaskManagement => 'Task Management';

  @override
  String get featureTaskManagementSubtitle => 'Create, edit, and track tasks';

  @override
  String get featureEventCalendar => 'Event Calendar';

  @override
  String get featureEventCalendarSubtitle => 'Day, week, month, and year views';

  @override
  String get featureReminders => 'Reminders';

  @override
  String get featureRemindersSubtitle => 'Get timely notifications';

  @override
  String get featureCloudSync => 'Cloud Sync';

  @override
  String get featureCloudSyncSubtitle => 'Safely back up and sync your data';

  @override
  String get featureAiAssistantSubtitle => 'Ask questions about your schedule';

  @override
  String get featurePersonalization => 'Personalization';

  @override
  String get featurePersonalizationSubtitle => 'Theme colors and font size';

  @override
  String get developerNote => 'Developer Note';

  @override
  String get developerNoteBody =>
      'This app is built with Flutter. Your feedback and suggestions are valuable to us.';

  @override
  String copyright(int year, String appName) {
    return '© $year $appName';
  }

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get enableSync => 'Enable Sync';

  @override
  String get enableSyncSubtitle => 'Turn cloud sync on/off';

  @override
  String get autoSync => 'Auto Sync';

  @override
  String get autoSyncSubtitle => 'Automatically sync changes';

  @override
  String get wifiOnlySync => 'Sync on Wi-Fi Only';

  @override
  String get wifiOnlySyncSubtitle => 'Reduce mobile data usage';

  @override
  String get manualSync => 'Manual Sync';

  @override
  String get syncNow => 'Sync now';

  @override
  String get syncStarted => 'Sync started';

  @override
  String get lastSync => 'Last Sync';

  @override
  String get notSyncedYet => 'Not synced yet';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeColors => 'Theme Colors';

  @override
  String get fontAndSize => 'Font & Size';

  @override
  String get lightMode => 'Light';

  @override
  String get darkMode => 'Dark';

  @override
  String get error => 'Error';

  @override
  String get taskIdRequired => 'Task ID required';

  @override
  String get eventIdRequired => 'Event ID required';

  @override
  String get eventSharing => 'Event Sharing';

  @override
  String eventIdLabel(String eventId) {
    return 'Event ID: $eventId';
  }

  @override
  String get eventInfoNotFound => 'Event information not found';

  @override
  String get calendarOperations => 'Calendar Operations';

  @override
  String get featureComingSoon => 'This feature is coming soon';

  @override
  String get pageNotFound => 'Page Not Found';

  @override
  String pageNotFoundWithRoute(String routeName) {
    return 'Page not found: $routeName';
  }

  @override
  String get unknown => 'Unknown';

  @override
  String timezoneLabel(String timezone) {
    return 'Timezone: $timezone';
  }

  @override
  String get calendarSharing => 'Calendar Sharing';

  @override
  String calendarNameLabel(String calendarName) {
    return 'Calendar: $calendarName';
  }

  @override
  String get calendarImport => 'Calendar Import';

  @override
  String get importingCalendar => 'Importing calendar...';

  @override
  String sourceTimezoneLabel(String timezone) {
    return 'Source Timezone: $timezone';
  }

  @override
  String get invalidDeepLink => 'Invalid deep link';

  @override
  String get tryAgain => 'Try Again';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get shareEvent => 'Share Event';

  @override
  String get shareCalendar => 'Share Calendar';

  @override
  String get importCalendar => 'Import Calendar';

  @override
  String get share => 'Share';

  @override
  String get aiWelcomeMessage =>
      'Hello! 👋 I\'m your personal calendar assistant. Ask me anything about your schedule.';

  @override
  String get aiErrorMessage => 'Sorry, an error occurred. Please try again.';

  @override
  String get aiReady => 'Your calendar assistant is ready!';

  @override
  String get aiInputHint => 'Type your question...';

  @override
  String get aiSuggestionToday => 'What should I do today?';

  @override
  String get aiSuggestionNextEvent => 'What\'s my next event?';

  @override
  String get aiSuggestionFreeTime => 'Do I have free time?';

  @override
  String get aiSuggestionOverdue => 'Do I have overdue tasks?';

  @override
  String get aiSuggestionTomorrow => 'What\'s on tomorrow?';

  @override
  String get aiSuggestionWeekend => 'What\'s my weekend plan?';

  @override
  String get aiSuggestionPriorities => 'What are my priority tasks?';

  @override
  String get aiSuggestionWeekSummary => 'This week\'s summary';

  @override
  String get noNotificationNoDate =>
      'No notification scheduled because no date was selected.';

  @override
  String get noNotificationPastTask =>
      'No notification scheduled for a past task.';

  @override
  String get noRemindersTaskTooSoon => '• No reminders (task is too soon)';

  @override
  String reminderBefore(String label, String datetime) {
    return '• $label before: $datetime';
  }

  @override
  String get oneHour => '1 hour';

  @override
  String get thirtyMinutes => '30 minutes';

  @override
  String get themeSettingsLoadFailed => 'Failed to load theme settings.';

  @override
  String get fontPreviewSample => 'Sample text — Work Schedule';

  @override
  String get themeColorBlue => 'Blue';

  @override
  String get themeColorPurple => 'Purple';

  @override
  String get themeColorGreen => 'Green';

  @override
  String get themeColorOrange => 'Orange';

  @override
  String get themeColorRed => 'Red';

  @override
  String get themeColorPink => 'Pink';

  @override
  String get themeColorTeal => 'Teal';

  @override
  String get themeColorCyan => 'Cyan';

  @override
  String get themeColorIndigo => 'Indigo';

  @override
  String get themeColorBrown => 'Brown';

  @override
  String get themeColorGrey => 'Grey';

  @override
  String get themeColorAmber => 'Amber';

  @override
  String get themeColorDeepPurple => 'Deep Purple';

  @override
  String get themeColorLightBlue => 'Light Blue';

  @override
  String get themeColorLime => 'Lime';

  @override
  String get themeColorDeepOrange => 'Deep Orange';

  @override
  String get themeColorBlueGrey => 'Blue Grey';

  @override
  String get themeColorYellow => 'Yellow';

  @override
  String get themeColorLightGreen => 'Light Green';

  @override
  String get themeColorRedAccent => 'Red Accent';

  @override
  String get themeColorGreenAccent => 'Green Accent';

  @override
  String get themeColorBlueAccent => 'Blue Accent';

  @override
  String photoSelectError(String error) {
    return 'Error selecting photo: $error';
  }

  @override
  String fileSelectError(String error) {
    return 'Error selecting file: $error';
  }

  @override
  String get chooseFromGallery => 'Choose from Gallery';

  @override
  String get takeWithCamera => 'Take with Camera';

  @override
  String get attachments => 'Attachments';

  @override
  String get photo => 'Photo';

  @override
  String get file => 'File';

  @override
  String get selectedPhotos => 'Selected Photos';

  @override
  String get selectedFiles => 'Selected Files';

  @override
  String get eventTitle => 'Title';

  @override
  String get eventDescriptionPlaceholder => 'Enter a description (optional)';

  @override
  String get weekPrefix => 'Week: ';

  @override
  String get eventRepositoryNotFound => 'Event repository not found';

  @override
  String eventsLoadError(String error) {
    return 'Error loading events: $error';
  }

  @override
  String eventsOnDate(int count) {
    return '$count events on this date';
  }

  @override
  String get retry => 'Retry';

  @override
  String yearEventDensity(int year) {
    return '$year Event Density';
  }

  @override
  String get heatmapSubtitle => 'Annual calendar colored by daily event count';

  @override
  String get heatmapLegendLess => 'Less';

  @override
  String get heatmapLegendMore => 'More';

  @override
  String eventsCount(int count) {
    return '$count events';
  }

  @override
  String get lightTheme => 'Light Theme';

  @override
  String get darkTheme => 'Dark Theme';

  @override
  String get themeSettings => 'Theme Settings';

  @override
  String get appearanceMode => 'Appearance Mode';

  @override
  String get colorScheme => 'Color Scheme';

  @override
  String get previewControls => 'Preview Controls';

  @override
  String get selectMonth => 'Select Month';

  @override
  String get selectToday => 'Select Today';

  @override
  String get sampleTasks => 'Sample Tasks';

  @override
  String tasksLoaded(int count) {
    return '$count tasks loaded';
  }

  @override
  String get refresh => 'Refresh';

  @override
  String get livePreview => 'Live Preview';

  @override
  String get livePreviewSubtitle =>
      'Preview how calendar and task widgets look here.';

  @override
  String get calendarWidget => 'Calendar Widget';

  @override
  String get taskListWidget => 'Task List Widget';

  @override
  String taskTapped(String taskTitle) {
    return 'Task tapped: $taskTitle';
  }

  @override
  String get previewInfo =>
      'Change your theme settings to test different widget appearances.';

  @override
  String get recipientTimezoneOptional => 'Recipient Timezone (Optional)';

  @override
  String get selectTimezone => 'Select timezone';

  @override
  String get timezoneWarning => 'Timezone Warning';

  @override
  String eventsWillBeShared(int count) {
    return '$count events will be shared';
  }

  @override
  String eventsTimezoneAdjustWarning(String warning, int count) {
    return '$warning\n\n$count events will be adjusted for the timezone.';
  }

  @override
  String get selectIcsFile => 'Select a calendar file in .ics format';

  @override
  String get sourceTimezoneOptional => 'Source Timezone (Optional)';

  @override
  String get senderTimezone => 'Sender timezone';

  @override
  String get autoDetect => 'Auto Detect';

  @override
  String get chooseFile => 'Choose File';

  @override
  String fileSelectionError(String error) {
    return 'File selection error: $error';
  }

  @override
  String importSuccessCount(int count) {
    return '$count events imported successfully!';
  }

  @override
  String get importFailed => 'Events could not be imported.';

  @override
  String get importSuccessful => 'Import Successful';

  @override
  String get shareExamplesTitle => 'Calendar Sharing Examples';

  @override
  String get shareSingleEvent => 'Share Single Event';

  @override
  String get shareAllCalendar => 'Share All Calendar';

  @override
  String get eventSharedSuccess => 'Event shared successfully';

  @override
  String shareError(String error) {
    return 'Share error: $error';
  }

  @override
  String get calendarShareTitle => 'Calendar Sharing';

  @override
  String get calendarShareBody => 'Here is your full calendar';

  @override
  String eventsSharedSuccess(int count) {
    return '$count events shared successfully';
  }

  @override
  String eventsAdjustedForTimezone(int count) {
    return '$count events adjusted for your timezone.';
  }

  @override
  String importError(String error) {
    return 'Import error: $error';
  }

  @override
  String get exactAlarmEnabledMsg => 'Exact alarm permission is enabled.';

  @override
  String get exactAlarmStillDisabledMsg =>
      'Exact alarm permission is still disabled. Enable \"Exact alarms\" in the settings screen that opens.';

  @override
  String get notificationPermissionGranted =>
      'Notification permission granted!';

  @override
  String get notificationPermissionDenied =>
      'Notification permission denied. You can enable it manually in Settings.';

  @override
  String get notificationPermissionDialogTitle => 'Notification Permission';

  @override
  String get notificationPermissionInstructions =>
      'Please enable notification permissions for \"Work Schedule\" in device settings:\n\n1. Open the Settings app\n2. Go to \"Apps\" or \"Applications\"\n3. Find the \"Work Schedule\" app\n4. Go to \"Notifications\"\n5. Enable notifications';

  @override
  String get exactAlarmPermissionTitle => 'Exact Alarm Permission';

  @override
  String get exactAlarmInstructions =>
      'For on-time reminders:\n\nSettings → Apps → Work Schedule → Permissions → Alarms & reminders → Exact alarms';

  @override
  String get exactAlarmPermissionLabel => 'Exact alarm permission';

  @override
  String get exactAlarmEnabledHint => 'Reminders can be sent on time.';

  @override
  String get exactAlarmDisabledHint =>
      'If disabled, notifications may be delayed.';

  @override
  String get statusOn => 'On';

  @override
  String get statusOff => 'Off';

  @override
  String get requestPermission => 'Request Permission';

  @override
  String get goToSettings => 'Go to Settings';

  @override
  String get howToEnable => 'How to enable?';

  @override
  String get notificationGrantedActive =>
      'Notification permission granted. Task reminders are active.';

  @override
  String get notificationDeniedInactive =>
      'Notification permission not granted. Task reminders will not work.';

  @override
  String get requestNotificationPermission => 'Request Notification Permission';

  @override
  String get refreshStatus => 'Refresh Status';

  @override
  String get scheduledNotifications => 'Scheduled Notifications';

  @override
  String get scheduledNotificationsDesc =>
      'Task notifications arrive 1 hour and 30 minutes before; status is reported at due time.';

  @override
  String get noPendingNotifications =>
      'No pending notifications. Add tasks with date and time.';

  @override
  String get notificationDefaultTitle => 'Notification';

  @override
  String get refreshList => 'Refresh List';

  @override
  String get infoTitle => 'Info';

  @override
  String get notificationInfoBlock =>
      'Task notifications arrive 1 hour and 30 minutes before the task time.\n  Example: Task at 15:00 → 14:00 and 14:30\n\n• Completion status at due time is shown with a colored notification.\n  Green: completed, Red: not completed\n\n• Tapping the notification or Snooze postpones the task by 30 min.\n  The new time is updated automatically in the calendar.\n\n• If no time is selected, the task defaults to 09:00.\n\n• Notification permission + Exact alarms permission must both be enabled.';

  @override
  String lastUpdatedLabel(String date) {
    return 'Last updated: $date';
  }

  @override
  String get privacyLastUpdatedDate => 'June 8, 2026';

  @override
  String get privacyIntroTitle => 'Introduction';

  @override
  String get privacyIntroBody =>
      'This Privacy Policy explains how your personal data is collected, used, stored, and protected when you use the Work Schedule mobile app. By using the app, you are deemed to have accepted this policy.';

  @override
  String get privacyDataControllerTitle => 'Data Controller';

  @override
  String privacyDataControllerBullet1(String controller) {
    return 'Data controller: $controller';
  }

  @override
  String get privacyDataControllerBullet2 => 'App: Work Schedule';

  @override
  String get privacyDataControllerBullet3 =>
      'Package name: com.Appworkschedule.app';

  @override
  String privacyDataControllerBullet4(String email) {
    return 'Contact: $email';
  }

  @override
  String get privacyDataCollectedTitle => 'Data Collected';

  @override
  String get privacyDataCollectedIntro =>
      'The app may collect the following categories of data:';

  @override
  String get privacyDataCollectedBullet1 =>
      'Account information: email, password (securely processed by Firebase), Google profile information';

  @override
  String get privacyDataCollectedBullet2 =>
      'Task and event data: title, description, dates, priority, location, attendees';

  @override
  String get privacyDataCollectedBullet3 =>
      'Event attachments: photos and files';

  @override
  String get privacyDataCollectedBullet4 =>
      'Google Calendar data (if sync is enabled)';

  @override
  String get privacyDataCollectedBullet5 =>
      'Preferences: theme, notification, and sync settings';

  @override
  String get privacyDataCollectedBullet6 => 'Device timezone (for reminders)';

  @override
  String get privacyDataCollectedBullet7 =>
      'Login credentials saved with \"Remember me\" (stored locally on device)';

  @override
  String get privacyDataUseTitle => 'Purposes of Data Use';

  @override
  String get privacyDataUseBullet1 => 'Account creation and authentication';

  @override
  String get privacyDataUseBullet2 => 'Task and event management';

  @override
  String get privacyDataUseBullet3 => 'Reminder and notification delivery';

  @override
  String get privacyDataUseBullet4 => 'Cloud sync and backup';

  @override
  String get privacyDataUseBullet5 => 'Google Calendar synchronization';

  @override
  String get privacyDataUseBullet6 => 'Calendar sharing and export';

  @override
  String get privacyDataUseBullet7 =>
      'Providing schedule information via AI Assistant';

  @override
  String get privacyDataUseBullet8 => 'App security';

  @override
  String get privacyLegalBasisTitle => 'Legal Basis (KVKK)';

  @override
  String get privacyLegalBasisBody =>
      'Your personal data is processed based on contract performance, legitimate interest, and your explicit consent (Google connection, notifications, camera/gallery permissions) under KVKK.';

  @override
  String get privacyStorageTitle => 'Data Storage';

  @override
  String get privacyStorageBullet1 =>
      'Tasks and events are stored in the SQLite database on your device';

  @override
  String get privacyStorageBullet2 =>
      'If sync is enabled, data is stored on Google Firebase (Firestore)';

  @override
  String get privacyStorageBullet3 =>
      'Settings are stored on your device with SharedPreferences';

  @override
  String get privacyStorageBullet4 =>
      'Attachments are stored in the app documents directory';

  @override
  String get privacyStorageBody =>
      'Your data is retained while your account is active. Upon account deletion request, your data will be deleted subject to legal obligations.';

  @override
  String get privacyThirdPartyTitle => 'Third-Party Services';

  @override
  String get privacyThirdPartyBullet1 =>
      'Google Firebase (authentication and cloud database)';

  @override
  String get privacyThirdPartyBullet2 =>
      'Google Sign-In and Google Calendar API (optional)';

  @override
  String get privacyThirdPartyBullet3 =>
      'Google Fonts (fonts; IP address may be transmitted)';

  @override
  String get privacyThirdPartyBody =>
      'These service providers are subject to their own privacy policies.';

  @override
  String get privacyPermissionsTitle => 'Device Permissions';

  @override
  String get privacyPermissionsBullet1 => 'Notifications: for reminders';

  @override
  String get privacyPermissionsBullet2 =>
      'Camera and gallery: for event photos';

  @override
  String get privacyPermissionsBullet3 => 'File access: for import/export';

  @override
  String get privacyPermissionsBullet4 => 'Internet: for cloud sync';

  @override
  String get privacyPermissionsBullet5 =>
      'Device reboot: to reschedule reminders';

  @override
  String get privacyPermissionsBody =>
      'You can revoke permissions at any time from your device settings.';

  @override
  String get privacyAiTitle => 'AI Assistant';

  @override
  String get privacyAiBody =>
      'The AI Assistant runs in local mode by default; it accesses your task and event data but does not send it to third parties. If an external AI API is configured, your question text may be sent to the relevant provider.';

  @override
  String get privacySecurityTitle => 'Data Security';

  @override
  String get privacySecurityBody =>
      'Industry-standard security measures are applied to protect your data. Firebase communication is conducted over encrypted connections (HTTPS/TLS).';

  @override
  String get privacySharingTitle => 'Data Sharing';

  @override
  String get privacySharingBody =>
      'We do not sell your personal data. Data is shared only with providers necessary for service delivery, at your request (sharing/export), or when legally required.';

  @override
  String get privacyRightsTitle => 'Your Rights (KVKK Article 11)';

  @override
  String get privacyRightsBullet1 =>
      'Learn whether your data is being processed';

  @override
  String get privacyRightsBullet2 => 'Request information if processed';

  @override
  String get privacyRightsBullet3 =>
      'Request correction of incomplete or inaccurate data';

  @override
  String get privacyRightsBullet4 => 'Request deletion or destruction of data';

  @override
  String get privacyRightsBullet5 => 'Object to automated analysis results';

  @override
  String get privacyRightsBullet6 => 'Request compensation for damages';

  @override
  String privacyRightsBody(String email) {
    return 'To exercise your rights, contact $email. Your request will be answered within 30 days at the latest.';
  }

  @override
  String get privacyChildrenTitle => 'Children\'s Privacy';

  @override
  String get privacyChildrenBody =>
      'The app is not intended for children under 13. We do not knowingly collect personal data from this age group.';

  @override
  String get privacyTransferTitle => 'International Data Transfer';

  @override
  String get privacyTransferBody =>
      'Firebase and Google services may process your data on servers outside Turkey. This transfer takes place within the safeguards of KVKK Article 9.';

  @override
  String get privacyChangesTitle => 'Policy Changes';

  @override
  String get privacyChangesBody =>
      'This policy may be updated from time to time. For significant changes, you will be notified via in-app notification or an updated date.';

  @override
  String get privacyContactTitle => 'Contact';

  @override
  String privacyContactBody(String controller, String email) {
    return 'For questions about the privacy policy or your personal data, contact the data controller $controller at $email.';
  }

  @override
  String get packageName => 'com.Appworkschedule.app';

  @override
  String get taskReminderChannelName => 'Task Reminders';

  @override
  String get taskReminderChannelDesc =>
      'Reminders 1 hour and 30 minutes before tasks';

  @override
  String get eventReminderChannelName => 'Reminder Notifications';

  @override
  String get eventReminderChannelDesc => 'Event reminders';

  @override
  String get taskNotificationChannelName => 'Task Notifications';

  @override
  String get taskNotificationChannelDesc =>
      'Completion and snooze notifications';

  @override
  String get taskCompletedTitle => 'Task Completed ✓';

  @override
  String get taskNotCompletedTitle => 'Task Not Completed';

  @override
  String taskCompletedOnTime(String title, String dueTime) {
    return '\"$title\" was completed on time for $dueTime.';
  }

  @override
  String taskNotCompletedOverdue(String title, String dueTime) {
    return '\"$title\" is overdue ($dueTime). Not completed yet.';
  }

  @override
  String get completeAction => 'Complete';

  @override
  String get snoozeAction => 'Snooze';

  @override
  String get notificationPermissionRequired =>
      'Notification permission not granted. Enable it in Settings > Notifications.';

  @override
  String get exactAlarmPermissionRequired =>
      'Exact alarm permission required. Enable it in Settings > Permissions > Alarms & reminders.';

  @override
  String get testNotificationTitle => 'Test Notification';

  @override
  String get testNotificationBody =>
      'If you see this, notifications are working!';

  @override
  String get taskCompletedNotificationTitle => 'Task Completed';

  @override
  String taskCompletedNotificationBody(String title) {
    return '\"$title\" marked as completed.';
  }

  @override
  String get taskSnoozedTitle => 'Task Snoozed';

  @override
  String taskSnoozedBody(String title, String datetime) {
    return '\"$title\" → $datetime';
  }

  @override
  String get taskReminderTitle => 'Task Reminder';

  @override
  String taskReminderBody(String dueDate, String dueTime, String label) {
    return '$dueDate at $dueTime — $label left';
  }

  @override
  String get notificationScheduled => 'Notification scheduled';

  @override
  String get notificationNotScheduled => 'Notification could not be scheduled';

  @override
  String get eventReminderTitle => 'Event Reminder';

  @override
  String get aiTodaySchedule => 'Today\'s Schedule';

  @override
  String get aiTasksUnavailable => 'Task information is unavailable.';

  @override
  String get aiGreetingHello => 'Hello';

  @override
  String get aiGreetingMorning => 'Good morning';

  @override
  String get aiGreetingEvening => 'Good evening';

  @override
  String get aiHelpIntro =>
      'I\'m your personal calendar assistant. You can ask me:\n• \"What should I do today?\"\n• \"What\'s my next event?\"\n• \"Do I have overdue tasks?\"\n• \"Do I have free time?\"\n\nType \"help\" for all commands.';

  @override
  String shareEventText(String title) {
    return 'Event: $title';
  }

  @override
  String get defaultCalendarName => 'WorkSchedule Calendar';

  @override
  String timezoneCheckError(String error) {
    return 'Timezone check error: $error';
  }

  @override
  String get aiEventsLoadError => 'An error occurred while loading events.';

  @override
  String get aiEventsUnavailable => 'Event information is unavailable.';

  @override
  String get aiTasksLoadError => 'An error occurred while loading tasks.';

  @override
  String get aiNoEventsThisWeek => 'No events scheduled this week.';

  @override
  String get aiWeekendPlan => 'Your Weekend Plan';

  @override
  String get aiWeekendNoEvents => 'No events scheduled for the weekend.';

  @override
  String get aiWeekendEmpty =>
      'Nothing scheduled for the weekend yet. A good chance to rest! 🌿';

  @override
  String get aiNoOverdueTasks =>
      'Great! You have no overdue tasks. Everything is on track! 🎉';

  @override
  String get aiOverdueTasksTitle => 'Overdue Tasks';

  @override
  String aiOverdueTasksCount(int count) {
    return 'Overdue Tasks ($count)';
  }

  @override
  String get aiNoPriorityTasks => 'You have no high-priority pending tasks.';

  @override
  String get aiPriorityTasksTitle => 'Priority Tasks';

  @override
  String get aiNextEventTitle => 'Your Next Event';

  @override
  String get aiNoUpcomingEvents => 'No events scheduled in the next 30 days.';

  @override
  String get aiTomorrowProgram => 'Tomorrow\'s Schedule';

  @override
  String get aiTomorrowEmpty =>
      'No events or tasks scheduled for tomorrow yet.';

  @override
  String get aiFreeTimeTitle => 'Your Free Time Today';

  @override
  String get aiBusyToday =>
      'You look very busy today! No free time available. Don\'t forget to rest! 😊';

  @override
  String get aiTaskSummary => 'Task Summary';

  @override
  String get aiWeekSummaryTitle => 'This Week Summary';

  @override
  String get aiWeekEventsTitle => 'Events This Week';

  @override
  String get aiTodayEmpty =>
      'No events or tasks scheduled for today. You have a relaxed day! 🎉';

  @override
  String get aiHelpFull =>
      '🤖 **AI Assistant Help**\n\nI can help you with:\n\n📅 **Daily Plan:**\n• \"What should I do today?\"\n• \"What\'s on tomorrow?\"\n• \"What\'s my weekend plan?\"\n• \"Do I have free time?\"\n• \"Am I busy today?\"\n\n📌 **Events:**\n• \"What\'s my next event?\"\n• \"What\'s planned this week?\"\n• \"What are my events?\"\n\n✅ **Tasks:**\n• \"What are my tasks?\"\n• \"Do I have overdue tasks?\"\n• \"What are my priority tasks?\"\n• \"Incomplete tasks\"\n\n📊 **Summary:**\n• \"This week\'s summary\"\n• \"Weekly summary\"\n\nYou can ask any question in natural language!';

  @override
  String get aiDefaultResponse =>
      '🤖 I didn\'t understand, but you can ask:\n\n• \"What should I do today?\"\n• \"What\'s my next event?\"\n• \"Do I have overdue tasks?\"\n• \"Do I have free time?\"\n• \"What\'s my weekend plan?\"\n• \"This week\'s summary\"\n\nType \"help\" for more assistance.';

  @override
  String get wearOsNextEvent => 'Next Event';

  @override
  String wearOsUrgentTasks(int count) {
    return 'Urgent Tasks ($count)';
  }

  @override
  String get wearOsTodayTasks => 'Today\'s Tasks';

  @override
  String get wearOsTasksLabel => 'Tasks';

  @override
  String get wearOsEventsLabel => 'Events';

  @override
  String get wearOsOverdue => 'Overdue';

  @override
  String get eventCardExamplesTitle => 'Event Card Examples';

  @override
  String aiAndMoreTasks(int count) {
    return '... and $count more tasks';
  }

  @override
  String aiDaysOverdue(int days) {
    return '$days days overdue';
  }

  @override
  String get aiRecommendPrioritize =>
      '\n💡 I recommend prioritizing these tasks.';

  @override
  String get wearOsNoData => 'No data found';

  @override
  String get wearOsDailySummaryTitle => '📊 Today\'s Summary';
}
