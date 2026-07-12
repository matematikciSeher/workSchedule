import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Work Schedule'**
  String get appName;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @aiAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get aiAssistant;

  /// No description provided for @newTask.
  ///
  /// In en, this message translates to:
  /// **'New Task'**
  String get newTask;

  /// No description provided for @addNewTask.
  ///
  /// In en, this message translates to:
  /// **'Add new task'**
  String get addNewTask;

  /// No description provided for @deleteTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Task'**
  String get deleteTaskTitle;

  /// No description provided for @deleteTaskConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{taskTitle}\"?'**
  String deleteTaskConfirm(String taskTitle);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @selectADay.
  ///
  /// In en, this message translates to:
  /// **'Select a day'**
  String get selectADay;

  /// No description provided for @selectDayHint.
  ///
  /// In en, this message translates to:
  /// **'Tap a date on the calendar to view your tasks'**
  String get selectDayHint;

  /// No description provided for @noTasksForDay.
  ///
  /// In en, this message translates to:
  /// **'No tasks for this day'**
  String get noTasksForDay;

  /// No description provided for @addTaskHint.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add a new task'**
  String get addTaskHint;

  /// No description provided for @allTasksCompleted.
  ///
  /// In en, this message translates to:
  /// **'All tasks completed'**
  String get allTasksCompleted;

  /// No description provided for @taskProgressSummary.
  ///
  /// In en, this message translates to:
  /// **'{pending} pending • {completed} completed'**
  String taskProgressSummary(int pending, int completed);

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @editTask.
  ///
  /// In en, this message translates to:
  /// **'Edit Task'**
  String get editTask;

  /// No description provided for @notificationTime.
  ///
  /// In en, this message translates to:
  /// **'Notification time'**
  String get notificationTime;

  /// No description provided for @notificationCannotBeScheduled.
  ///
  /// In en, this message translates to:
  /// **'Notification cannot be scheduled.'**
  String get notificationCannotBeScheduled;

  /// No description provided for @notificationVisibleOnLockScreen.
  ///
  /// In en, this message translates to:
  /// **'Visible in notification bar and lock screen.'**
  String get notificationVisibleOnLockScreen;

  /// No description provided for @taskUpdated.
  ///
  /// In en, this message translates to:
  /// **'Task updated'**
  String get taskUpdated;

  /// No description provided for @taskAdded.
  ///
  /// In en, this message translates to:
  /// **'Task added'**
  String get taskAdded;

  /// No description provided for @myTasks.
  ///
  /// In en, this message translates to:
  /// **'My Tasks'**
  String get myTasks;

  /// No description provided for @noTasksYet.
  ///
  /// In en, this message translates to:
  /// **'No tasks yet'**
  String get noTasksYet;

  /// No description provided for @addTaskTapPlus.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add a new task'**
  String get addTaskTapPlus;

  /// No description provided for @taskDeleted.
  ///
  /// In en, this message translates to:
  /// **'Task deleted'**
  String get taskDeleted;

  /// No description provided for @priorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get priorityLow;

  /// No description provided for @priorityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get priorityMedium;

  /// No description provided for @priorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get priorityHigh;

  /// No description provided for @priorityUnspecified.
  ///
  /// In en, this message translates to:
  /// **'Unspecified'**
  String get priorityUnspecified;

  /// No description provided for @snooze.
  ///
  /// In en, this message translates to:
  /// **'Snooze'**
  String get snooze;

  /// No description provided for @taskNotFound.
  ///
  /// In en, this message translates to:
  /// **'Task not found'**
  String get taskNotFound;

  /// No description provided for @taskLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load task'**
  String get taskLoadFailed;

  /// No description provided for @pleaseSelectDateAndTime.
  ///
  /// In en, this message translates to:
  /// **'Please select date and time'**
  String get pleaseSelectDateAndTime;

  /// No description provided for @snoozeMustBeFuture.
  ///
  /// In en, this message translates to:
  /// **'Snooze time must be in the future'**
  String get snoozeMustBeFuture;

  /// No description provided for @snoozeFailed.
  ///
  /// In en, this message translates to:
  /// **'Snooze failed: {error}'**
  String snoozeFailed(String error);

  /// No description provided for @currentDueDate.
  ///
  /// In en, this message translates to:
  /// **'Current due: {datetime}'**
  String currentDueDate(String datetime);

  /// No description provided for @quickOptions.
  ///
  /// In en, this message translates to:
  /// **'Quick options'**
  String get quickOptions;

  /// No description provided for @snooze15Min.
  ///
  /// In en, this message translates to:
  /// **'15 min'**
  String get snooze15Min;

  /// No description provided for @snooze30Min.
  ///
  /// In en, this message translates to:
  /// **'30 min'**
  String get snooze30Min;

  /// No description provided for @snooze1Hour.
  ///
  /// In en, this message translates to:
  /// **'1 hour'**
  String get snooze1Hour;

  /// No description provided for @snooze3Hours.
  ///
  /// In en, this message translates to:
  /// **'3 hours'**
  String get snooze3Hours;

  /// No description provided for @customDateAndTime.
  ///
  /// In en, this message translates to:
  /// **'Custom date and time'**
  String get customDateAndTime;

  /// No description provided for @newReminderAt.
  ///
  /// In en, this message translates to:
  /// **'New reminder: {datetime}'**
  String newReminderAt(String datetime);

  /// No description provided for @editEvent.
  ///
  /// In en, this message translates to:
  /// **'Edit Event'**
  String get editEvent;

  /// No description provided for @newEvent.
  ///
  /// In en, this message translates to:
  /// **'New Event'**
  String get newEvent;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @allDay.
  ///
  /// In en, this message translates to:
  /// **'All Day'**
  String get allDay;

  /// No description provided for @allDaySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Event lasts all day'**
  String get allDaySubtitle;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTime;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get endTime;

  /// No description provided for @pleaseSelectStartEndDates.
  ///
  /// In en, this message translates to:
  /// **'Please select start and end dates'**
  String get pleaseSelectStartEndDates;

  /// No description provided for @pleaseEnterTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get pleaseEnterTitle;

  /// No description provided for @titleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title *'**
  String get titleRequired;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @dateNotSelected.
  ///
  /// In en, this message translates to:
  /// **'No date selected'**
  String get dateNotSelected;

  /// No description provided for @timeNotSelected.
  ///
  /// In en, this message translates to:
  /// **'No time selected'**
  String get timeNotSelected;

  /// No description provided for @eventUpdated.
  ///
  /// In en, this message translates to:
  /// **'Event updated'**
  String get eventUpdated;

  /// No description provided for @eventCreated.
  ///
  /// In en, this message translates to:
  /// **'Event created'**
  String get eventCreated;

  /// No description provided for @eventDetails.
  ///
  /// In en, this message translates to:
  /// **'Event Details'**
  String get eventDetails;

  /// No description provided for @monthView.
  ///
  /// In en, this message translates to:
  /// **'Month View'**
  String get monthView;

  /// No description provided for @weekView.
  ///
  /// In en, this message translates to:
  /// **'Week View'**
  String get weekView;

  /// No description provided for @dayView.
  ///
  /// In en, this message translates to:
  /// **'Day View'**
  String get dayView;

  /// No description provided for @yearTitle.
  ///
  /// In en, this message translates to:
  /// **'Year {year}'**
  String yearTitle(int year);

  /// No description provided for @previousYear.
  ///
  /// In en, this message translates to:
  /// **'Previous year'**
  String get previousYear;

  /// No description provided for @nextYear.
  ///
  /// In en, this message translates to:
  /// **'Next year'**
  String get nextYear;

  /// No description provided for @managePreferences.
  ///
  /// In en, this message translates to:
  /// **'Manage Your Preferences'**
  String get managePreferences;

  /// No description provided for @settingsHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Adjust sync, notifications, and appearance settings here.'**
  String get settingsHeaderSubtitle;

  /// No description provided for @sectionGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get sectionGeneral;

  /// No description provided for @syncSettings.
  ///
  /// In en, this message translates to:
  /// **'Sync Settings'**
  String get syncSettings;

  /// No description provided for @syncSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Cloud sync and backup'**
  String get syncSettingsSubtitle;

  /// No description provided for @widgetPreview.
  ///
  /// In en, this message translates to:
  /// **'Widget Preview'**
  String get widgetPreview;

  /// No description provided for @widgetPreviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Preview home screen widget'**
  String get widgetPreviewSubtitle;

  /// No description provided for @sectionPersonalization.
  ///
  /// In en, this message translates to:
  /// **'Personalization'**
  String get sectionPersonalization;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Notification permissions and settings'**
  String get notificationsSubtitle;

  /// No description provided for @themeAndFont.
  ///
  /// In en, this message translates to:
  /// **'Theme & Font'**
  String get themeAndFont;

  /// No description provided for @themeAndFontSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Light/dark theme, colors, and text settings'**
  String get themeAndFontSubtitle;

  /// No description provided for @sectionApp.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get sectionApp;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Data usage and privacy information'**
  String get privacyPolicySubtitle;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'App info and version'**
  String get aboutSubtitle;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String versionLabel(String version);

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'A smart calendar app that lets you manage tasks and events in one place. From daily planning to weekly views, reminders to cloud sync — all the tools you need are at your fingertips.'**
  String get aboutDescription;

  /// No description provided for @features.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get features;

  /// No description provided for @featureTaskManagement.
  ///
  /// In en, this message translates to:
  /// **'Task Management'**
  String get featureTaskManagement;

  /// No description provided for @featureTaskManagementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create, edit, and track tasks'**
  String get featureTaskManagementSubtitle;

  /// No description provided for @featureEventCalendar.
  ///
  /// In en, this message translates to:
  /// **'Event Calendar'**
  String get featureEventCalendar;

  /// No description provided for @featureEventCalendarSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Day, week, month, and year views'**
  String get featureEventCalendarSubtitle;

  /// No description provided for @featureReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get featureReminders;

  /// No description provided for @featureRemindersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get timely notifications'**
  String get featureRemindersSubtitle;

  /// No description provided for @featureCloudSync.
  ///
  /// In en, this message translates to:
  /// **'Cloud Sync'**
  String get featureCloudSync;

  /// No description provided for @featureCloudSyncSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Safely back up and sync your data'**
  String get featureCloudSyncSubtitle;

  /// No description provided for @featureAiAssistantSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ask questions about your schedule'**
  String get featureAiAssistantSubtitle;

  /// No description provided for @featurePersonalization.
  ///
  /// In en, this message translates to:
  /// **'Personalization'**
  String get featurePersonalization;

  /// No description provided for @featurePersonalizationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Theme colors and font size'**
  String get featurePersonalizationSubtitle;

  /// No description provided for @developerNote.
  ///
  /// In en, this message translates to:
  /// **'Developer Note'**
  String get developerNote;

  /// No description provided for @developerNoteBody.
  ///
  /// In en, this message translates to:
  /// **'This app is built with Flutter. Your feedback and suggestions are valuable to us.'**
  String get developerNoteBody;

  /// No description provided for @copyright.
  ///
  /// In en, this message translates to:
  /// **'© {year} {appName}'**
  String copyright(int year, String appName);

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// No description provided for @enableSync.
  ///
  /// In en, this message translates to:
  /// **'Enable Sync'**
  String get enableSync;

  /// No description provided for @enableSyncSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Turn cloud sync on/off'**
  String get enableSyncSubtitle;

  /// No description provided for @autoSync.
  ///
  /// In en, this message translates to:
  /// **'Auto Sync'**
  String get autoSync;

  /// No description provided for @autoSyncSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Automatically sync changes'**
  String get autoSyncSubtitle;

  /// No description provided for @wifiOnlySync.
  ///
  /// In en, this message translates to:
  /// **'Sync on Wi-Fi Only'**
  String get wifiOnlySync;

  /// No description provided for @wifiOnlySyncSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reduce mobile data usage'**
  String get wifiOnlySyncSubtitle;

  /// No description provided for @manualSync.
  ///
  /// In en, this message translates to:
  /// **'Manual Sync'**
  String get manualSync;

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get syncNow;

  /// No description provided for @syncStarted.
  ///
  /// In en, this message translates to:
  /// **'Sync started'**
  String get syncStarted;

  /// No description provided for @lastSync.
  ///
  /// In en, this message translates to:
  /// **'Last Sync'**
  String get lastSync;

  /// No description provided for @notSyncedYet.
  ///
  /// In en, this message translates to:
  /// **'Not synced yet'**
  String get notSyncedYet;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @themeColors.
  ///
  /// In en, this message translates to:
  /// **'Theme Colors'**
  String get themeColors;

  /// No description provided for @fontAndSize.
  ///
  /// In en, this message translates to:
  /// **'Font & Size'**
  String get fontAndSize;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkMode;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @taskIdRequired.
  ///
  /// In en, this message translates to:
  /// **'Task ID required'**
  String get taskIdRequired;

  /// No description provided for @eventIdRequired.
  ///
  /// In en, this message translates to:
  /// **'Event ID required'**
  String get eventIdRequired;

  /// No description provided for @eventSharing.
  ///
  /// In en, this message translates to:
  /// **'Event Sharing'**
  String get eventSharing;

  /// No description provided for @eventIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Event ID: {eventId}'**
  String eventIdLabel(String eventId);

  /// No description provided for @eventInfoNotFound.
  ///
  /// In en, this message translates to:
  /// **'Event information not found'**
  String get eventInfoNotFound;

  /// No description provided for @calendarOperations.
  ///
  /// In en, this message translates to:
  /// **'Calendar Operations'**
  String get calendarOperations;

  /// No description provided for @featureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'This feature is coming soon'**
  String get featureComingSoon;

  /// No description provided for @pageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Page Not Found'**
  String get pageNotFound;

  /// No description provided for @pageNotFoundWithRoute.
  ///
  /// In en, this message translates to:
  /// **'Page not found: {routeName}'**
  String pageNotFoundWithRoute(String routeName);

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @timezoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Timezone: {timezone}'**
  String timezoneLabel(String timezone);

  /// No description provided for @calendarSharing.
  ///
  /// In en, this message translates to:
  /// **'Calendar Sharing'**
  String get calendarSharing;

  /// No description provided for @calendarNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Calendar: {calendarName}'**
  String calendarNameLabel(String calendarName);

  /// No description provided for @calendarImport.
  ///
  /// In en, this message translates to:
  /// **'Calendar Import'**
  String get calendarImport;

  /// No description provided for @importingCalendar.
  ///
  /// In en, this message translates to:
  /// **'Importing calendar...'**
  String get importingCalendar;

  /// No description provided for @sourceTimezoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Source Timezone: {timezone}'**
  String sourceTimezoneLabel(String timezone);

  /// No description provided for @invalidDeepLink.
  ///
  /// In en, this message translates to:
  /// **'Invalid deep link'**
  String get invalidDeepLink;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @errorWithMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorWithMessage(String message);

  /// No description provided for @shareEvent.
  ///
  /// In en, this message translates to:
  /// **'Share Event'**
  String get shareEvent;

  /// No description provided for @shareCalendar.
  ///
  /// In en, this message translates to:
  /// **'Share Calendar'**
  String get shareCalendar;

  /// No description provided for @importCalendar.
  ///
  /// In en, this message translates to:
  /// **'Import Calendar'**
  String get importCalendar;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @aiWelcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Hello! 👋 I\'m your personal calendar assistant. Ask me anything about your schedule.'**
  String get aiWelcomeMessage;

  /// No description provided for @aiErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Sorry, an error occurred. Please try again.'**
  String get aiErrorMessage;

  /// No description provided for @aiReady.
  ///
  /// In en, this message translates to:
  /// **'Your calendar assistant is ready!'**
  String get aiReady;

  /// No description provided for @aiInputHint.
  ///
  /// In en, this message translates to:
  /// **'Type your question...'**
  String get aiInputHint;

  /// No description provided for @aiSuggestionToday.
  ///
  /// In en, this message translates to:
  /// **'What should I do today?'**
  String get aiSuggestionToday;

  /// No description provided for @aiSuggestionNextEvent.
  ///
  /// In en, this message translates to:
  /// **'What\'s my next event?'**
  String get aiSuggestionNextEvent;

  /// No description provided for @aiSuggestionFreeTime.
  ///
  /// In en, this message translates to:
  /// **'Do I have free time?'**
  String get aiSuggestionFreeTime;

  /// No description provided for @aiSuggestionOverdue.
  ///
  /// In en, this message translates to:
  /// **'Do I have overdue tasks?'**
  String get aiSuggestionOverdue;

  /// No description provided for @aiSuggestionTomorrow.
  ///
  /// In en, this message translates to:
  /// **'What\'s on tomorrow?'**
  String get aiSuggestionTomorrow;

  /// No description provided for @aiSuggestionWeekend.
  ///
  /// In en, this message translates to:
  /// **'What\'s my weekend plan?'**
  String get aiSuggestionWeekend;

  /// No description provided for @aiSuggestionPriorities.
  ///
  /// In en, this message translates to:
  /// **'What are my priority tasks?'**
  String get aiSuggestionPriorities;

  /// No description provided for @aiSuggestionWeekSummary.
  ///
  /// In en, this message translates to:
  /// **'This week\'s summary'**
  String get aiSuggestionWeekSummary;

  /// No description provided for @noNotificationNoDate.
  ///
  /// In en, this message translates to:
  /// **'No notification scheduled because no date was selected.'**
  String get noNotificationNoDate;

  /// No description provided for @noNotificationPastTask.
  ///
  /// In en, this message translates to:
  /// **'No notification scheduled for a past task.'**
  String get noNotificationPastTask;

  /// No description provided for @noRemindersTaskTooSoon.
  ///
  /// In en, this message translates to:
  /// **'• No reminders (task is too soon)'**
  String get noRemindersTaskTooSoon;

  /// No description provided for @reminderBefore.
  ///
  /// In en, this message translates to:
  /// **'• {label} before: {datetime}'**
  String reminderBefore(String label, String datetime);

  /// No description provided for @oneHour.
  ///
  /// In en, this message translates to:
  /// **'1 hour'**
  String get oneHour;

  /// No description provided for @thirtyMinutes.
  ///
  /// In en, this message translates to:
  /// **'30 minutes'**
  String get thirtyMinutes;

  /// No description provided for @themeSettingsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load theme settings.'**
  String get themeSettingsLoadFailed;

  /// No description provided for @fontPreviewSample.
  ///
  /// In en, this message translates to:
  /// **'Sample text — Work Schedule'**
  String get fontPreviewSample;

  /// No description provided for @themeColorBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get themeColorBlue;

  /// No description provided for @themeColorPurple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get themeColorPurple;

  /// No description provided for @themeColorGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get themeColorGreen;

  /// No description provided for @themeColorOrange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get themeColorOrange;

  /// No description provided for @themeColorRed.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get themeColorRed;

  /// No description provided for @themeColorPink.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get themeColorPink;

  /// No description provided for @themeColorTeal.
  ///
  /// In en, this message translates to:
  /// **'Teal'**
  String get themeColorTeal;

  /// No description provided for @themeColorCyan.
  ///
  /// In en, this message translates to:
  /// **'Cyan'**
  String get themeColorCyan;

  /// No description provided for @themeColorIndigo.
  ///
  /// In en, this message translates to:
  /// **'Indigo'**
  String get themeColorIndigo;

  /// No description provided for @themeColorBrown.
  ///
  /// In en, this message translates to:
  /// **'Brown'**
  String get themeColorBrown;

  /// No description provided for @themeColorGrey.
  ///
  /// In en, this message translates to:
  /// **'Grey'**
  String get themeColorGrey;

  /// No description provided for @themeColorAmber.
  ///
  /// In en, this message translates to:
  /// **'Amber'**
  String get themeColorAmber;

  /// No description provided for @themeColorDeepPurple.
  ///
  /// In en, this message translates to:
  /// **'Deep Purple'**
  String get themeColorDeepPurple;

  /// No description provided for @themeColorLightBlue.
  ///
  /// In en, this message translates to:
  /// **'Light Blue'**
  String get themeColorLightBlue;

  /// No description provided for @themeColorLime.
  ///
  /// In en, this message translates to:
  /// **'Lime'**
  String get themeColorLime;

  /// No description provided for @themeColorDeepOrange.
  ///
  /// In en, this message translates to:
  /// **'Deep Orange'**
  String get themeColorDeepOrange;

  /// No description provided for @themeColorBlueGrey.
  ///
  /// In en, this message translates to:
  /// **'Blue Grey'**
  String get themeColorBlueGrey;

  /// No description provided for @themeColorYellow.
  ///
  /// In en, this message translates to:
  /// **'Yellow'**
  String get themeColorYellow;

  /// No description provided for @themeColorLightGreen.
  ///
  /// In en, this message translates to:
  /// **'Light Green'**
  String get themeColorLightGreen;

  /// No description provided for @themeColorRedAccent.
  ///
  /// In en, this message translates to:
  /// **'Red Accent'**
  String get themeColorRedAccent;

  /// No description provided for @themeColorGreenAccent.
  ///
  /// In en, this message translates to:
  /// **'Green Accent'**
  String get themeColorGreenAccent;

  /// No description provided for @themeColorBlueAccent.
  ///
  /// In en, this message translates to:
  /// **'Blue Accent'**
  String get themeColorBlueAccent;

  /// No description provided for @photoSelectError.
  ///
  /// In en, this message translates to:
  /// **'Error selecting photo: {error}'**
  String photoSelectError(String error);

  /// No description provided for @fileSelectError.
  ///
  /// In en, this message translates to:
  /// **'Error selecting file: {error}'**
  String fileSelectError(String error);

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @takeWithCamera.
  ///
  /// In en, this message translates to:
  /// **'Take with Camera'**
  String get takeWithCamera;

  /// No description provided for @attachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get attachments;

  /// No description provided for @photo.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get photo;

  /// No description provided for @file.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get file;

  /// No description provided for @selectedPhotos.
  ///
  /// In en, this message translates to:
  /// **'Selected Photos'**
  String get selectedPhotos;

  /// No description provided for @selectedFiles.
  ///
  /// In en, this message translates to:
  /// **'Selected Files'**
  String get selectedFiles;

  /// No description provided for @eventTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get eventTitle;

  /// No description provided for @eventDescriptionPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter a description (optional)'**
  String get eventDescriptionPlaceholder;

  /// No description provided for @weekPrefix.
  ///
  /// In en, this message translates to:
  /// **'Week: '**
  String get weekPrefix;

  /// No description provided for @eventRepositoryNotFound.
  ///
  /// In en, this message translates to:
  /// **'Event repository not found'**
  String get eventRepositoryNotFound;

  /// No description provided for @eventsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Error loading events: {error}'**
  String eventsLoadError(String error);

  /// No description provided for @eventsOnDate.
  ///
  /// In en, this message translates to:
  /// **'{count} events on this date'**
  String eventsOnDate(int count);

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @yearEventDensity.
  ///
  /// In en, this message translates to:
  /// **'{year} Event Density'**
  String yearEventDensity(int year);

  /// No description provided for @heatmapSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Annual calendar colored by daily event count'**
  String get heatmapSubtitle;

  /// No description provided for @heatmapLegendLess.
  ///
  /// In en, this message translates to:
  /// **'Less'**
  String get heatmapLegendLess;

  /// No description provided for @heatmapLegendMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get heatmapLegendMore;

  /// No description provided for @eventsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} events'**
  String eventsCount(int count);

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light Theme'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get darkTheme;

  /// No description provided for @themeSettings.
  ///
  /// In en, this message translates to:
  /// **'Theme Settings'**
  String get themeSettings;

  /// No description provided for @appearanceMode.
  ///
  /// In en, this message translates to:
  /// **'Appearance Mode'**
  String get appearanceMode;

  /// No description provided for @colorScheme.
  ///
  /// In en, this message translates to:
  /// **'Color Scheme'**
  String get colorScheme;

  /// No description provided for @previewControls.
  ///
  /// In en, this message translates to:
  /// **'Preview Controls'**
  String get previewControls;

  /// No description provided for @selectMonth.
  ///
  /// In en, this message translates to:
  /// **'Select Month'**
  String get selectMonth;

  /// No description provided for @selectToday.
  ///
  /// In en, this message translates to:
  /// **'Select Today'**
  String get selectToday;

  /// No description provided for @sampleTasks.
  ///
  /// In en, this message translates to:
  /// **'Sample Tasks'**
  String get sampleTasks;

  /// No description provided for @tasksLoaded.
  ///
  /// In en, this message translates to:
  /// **'{count} tasks loaded'**
  String tasksLoaded(int count);

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @livePreview.
  ///
  /// In en, this message translates to:
  /// **'Live Preview'**
  String get livePreview;

  /// No description provided for @livePreviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Preview how calendar and task widgets look here.'**
  String get livePreviewSubtitle;

  /// No description provided for @calendarWidget.
  ///
  /// In en, this message translates to:
  /// **'Calendar Widget'**
  String get calendarWidget;

  /// No description provided for @taskListWidget.
  ///
  /// In en, this message translates to:
  /// **'Task List Widget'**
  String get taskListWidget;

  /// No description provided for @taskTapped.
  ///
  /// In en, this message translates to:
  /// **'Task tapped: {taskTitle}'**
  String taskTapped(String taskTitle);

  /// No description provided for @previewInfo.
  ///
  /// In en, this message translates to:
  /// **'Change your theme settings to test different widget appearances.'**
  String get previewInfo;

  /// No description provided for @recipientTimezoneOptional.
  ///
  /// In en, this message translates to:
  /// **'Recipient Timezone (Optional)'**
  String get recipientTimezoneOptional;

  /// No description provided for @selectTimezone.
  ///
  /// In en, this message translates to:
  /// **'Select timezone'**
  String get selectTimezone;

  /// No description provided for @timezoneWarning.
  ///
  /// In en, this message translates to:
  /// **'Timezone Warning'**
  String get timezoneWarning;

  /// No description provided for @eventsWillBeShared.
  ///
  /// In en, this message translates to:
  /// **'{count} events will be shared'**
  String eventsWillBeShared(int count);

  /// No description provided for @eventsTimezoneAdjustWarning.
  ///
  /// In en, this message translates to:
  /// **'{warning}\n\n{count} events will be adjusted for the timezone.'**
  String eventsTimezoneAdjustWarning(String warning, int count);

  /// No description provided for @selectIcsFile.
  ///
  /// In en, this message translates to:
  /// **'Select a calendar file in .ics format'**
  String get selectIcsFile;

  /// No description provided for @sourceTimezoneOptional.
  ///
  /// In en, this message translates to:
  /// **'Source Timezone (Optional)'**
  String get sourceTimezoneOptional;

  /// No description provided for @senderTimezone.
  ///
  /// In en, this message translates to:
  /// **'Sender timezone'**
  String get senderTimezone;

  /// No description provided for @autoDetect.
  ///
  /// In en, this message translates to:
  /// **'Auto Detect'**
  String get autoDetect;

  /// No description provided for @chooseFile.
  ///
  /// In en, this message translates to:
  /// **'Choose File'**
  String get chooseFile;

  /// No description provided for @fileSelectionError.
  ///
  /// In en, this message translates to:
  /// **'File selection error: {error}'**
  String fileSelectionError(String error);

  /// No description provided for @importSuccessCount.
  ///
  /// In en, this message translates to:
  /// **'{count} events imported successfully!'**
  String importSuccessCount(int count);

  /// No description provided for @importFailed.
  ///
  /// In en, this message translates to:
  /// **'Events could not be imported.'**
  String get importFailed;

  /// No description provided for @importSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Import Successful'**
  String get importSuccessful;

  /// No description provided for @shareExamplesTitle.
  ///
  /// In en, this message translates to:
  /// **'Calendar Sharing Examples'**
  String get shareExamplesTitle;

  /// No description provided for @shareSingleEvent.
  ///
  /// In en, this message translates to:
  /// **'Share Single Event'**
  String get shareSingleEvent;

  /// No description provided for @shareAllCalendar.
  ///
  /// In en, this message translates to:
  /// **'Share All Calendar'**
  String get shareAllCalendar;

  /// No description provided for @eventSharedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Event shared successfully'**
  String get eventSharedSuccess;

  /// No description provided for @shareError.
  ///
  /// In en, this message translates to:
  /// **'Share error: {error}'**
  String shareError(String error);

  /// No description provided for @calendarShareTitle.
  ///
  /// In en, this message translates to:
  /// **'Calendar Sharing'**
  String get calendarShareTitle;

  /// No description provided for @calendarShareBody.
  ///
  /// In en, this message translates to:
  /// **'Here is your full calendar'**
  String get calendarShareBody;

  /// No description provided for @eventsSharedSuccess.
  ///
  /// In en, this message translates to:
  /// **'{count} events shared successfully'**
  String eventsSharedSuccess(int count);

  /// No description provided for @eventsAdjustedForTimezone.
  ///
  /// In en, this message translates to:
  /// **'{count} events adjusted for your timezone.'**
  String eventsAdjustedForTimezone(int count);

  /// No description provided for @importError.
  ///
  /// In en, this message translates to:
  /// **'Import error: {error}'**
  String importError(String error);

  /// No description provided for @exactAlarmEnabledMsg.
  ///
  /// In en, this message translates to:
  /// **'Exact alarm permission is enabled.'**
  String get exactAlarmEnabledMsg;

  /// No description provided for @exactAlarmStillDisabledMsg.
  ///
  /// In en, this message translates to:
  /// **'Exact alarm permission is still disabled. Enable \"Exact alarms\" in the settings screen that opens.'**
  String get exactAlarmStillDisabledMsg;

  /// No description provided for @notificationPermissionGranted.
  ///
  /// In en, this message translates to:
  /// **'Notification permission granted!'**
  String get notificationPermissionGranted;

  /// No description provided for @notificationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Notification permission denied. You can enable it manually in Settings.'**
  String get notificationPermissionDenied;

  /// No description provided for @notificationPermissionDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification Permission'**
  String get notificationPermissionDialogTitle;

  /// No description provided for @notificationPermissionInstructions.
  ///
  /// In en, this message translates to:
  /// **'Please enable notification permissions for \"Work Schedule\" in device settings:\n\n1. Open the Settings app\n2. Go to \"Apps\" or \"Applications\"\n3. Find the \"Work Schedule\" app\n4. Go to \"Notifications\"\n5. Enable notifications'**
  String get notificationPermissionInstructions;

  /// No description provided for @exactAlarmPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Exact Alarm Permission'**
  String get exactAlarmPermissionTitle;

  /// No description provided for @exactAlarmInstructions.
  ///
  /// In en, this message translates to:
  /// **'For on-time reminders:\n\nSettings → Apps → Work Schedule → Permissions → Alarms & reminders → Exact alarms'**
  String get exactAlarmInstructions;

  /// No description provided for @exactAlarmPermissionLabel.
  ///
  /// In en, this message translates to:
  /// **'Exact alarm permission'**
  String get exactAlarmPermissionLabel;

  /// No description provided for @exactAlarmEnabledHint.
  ///
  /// In en, this message translates to:
  /// **'Reminders can be sent on time.'**
  String get exactAlarmEnabledHint;

  /// No description provided for @exactAlarmDisabledHint.
  ///
  /// In en, this message translates to:
  /// **'If disabled, notifications may be delayed.'**
  String get exactAlarmDisabledHint;

  /// No description provided for @statusOn.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get statusOn;

  /// No description provided for @statusOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get statusOff;

  /// No description provided for @requestPermission.
  ///
  /// In en, this message translates to:
  /// **'Request Permission'**
  String get requestPermission;

  /// No description provided for @goToSettings.
  ///
  /// In en, this message translates to:
  /// **'Go to Settings'**
  String get goToSettings;

  /// No description provided for @howToEnable.
  ///
  /// In en, this message translates to:
  /// **'How to enable?'**
  String get howToEnable;

  /// No description provided for @notificationGrantedActive.
  ///
  /// In en, this message translates to:
  /// **'Notification permission granted. Task reminders are active.'**
  String get notificationGrantedActive;

  /// No description provided for @notificationDeniedInactive.
  ///
  /// In en, this message translates to:
  /// **'Notification permission not granted. Task reminders will not work.'**
  String get notificationDeniedInactive;

  /// No description provided for @requestNotificationPermission.
  ///
  /// In en, this message translates to:
  /// **'Request Notification Permission'**
  String get requestNotificationPermission;

  /// No description provided for @refreshStatus.
  ///
  /// In en, this message translates to:
  /// **'Refresh Status'**
  String get refreshStatus;

  /// No description provided for @scheduledNotifications.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Notifications'**
  String get scheduledNotifications;

  /// No description provided for @scheduledNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Task notifications arrive 1 hour and 30 minutes before; status is reported at due time.'**
  String get scheduledNotificationsDesc;

  /// No description provided for @noPendingNotifications.
  ///
  /// In en, this message translates to:
  /// **'No pending notifications. Add tasks with date and time.'**
  String get noPendingNotifications;

  /// No description provided for @notificationDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notificationDefaultTitle;

  /// No description provided for @refreshList.
  ///
  /// In en, this message translates to:
  /// **'Refresh List'**
  String get refreshList;

  /// No description provided for @infoTitle.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get infoTitle;

  /// No description provided for @notificationInfoBlock.
  ///
  /// In en, this message translates to:
  /// **'Task notifications arrive 1 hour and 30 minutes before the task time.\n  Example: Task at 15:00 → 14:00 and 14:30\n\n• Completion status at due time is shown with a colored notification.\n  Green: completed, Red: not completed\n\n• Tapping the notification or Snooze postpones the task by 30 min.\n  The new time is updated automatically in the calendar.\n\n• If no time is selected, the task defaults to 09:00.\n\n• Notification permission + Exact alarms permission must both be enabled.'**
  String get notificationInfoBlock;

  /// No description provided for @lastUpdatedLabel.
  ///
  /// In en, this message translates to:
  /// **'Last updated: {date}'**
  String lastUpdatedLabel(String date);

  /// No description provided for @privacyLastUpdatedDate.
  ///
  /// In en, this message translates to:
  /// **'June 8, 2026'**
  String get privacyLastUpdatedDate;

  /// No description provided for @privacyIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get privacyIntroTitle;

  /// No description provided for @privacyIntroBody.
  ///
  /// In en, this message translates to:
  /// **'This Privacy Policy explains how your personal data is collected, used, stored, and protected when you use the Work Schedule mobile app. By using the app, you are deemed to have accepted this policy.'**
  String get privacyIntroBody;

  /// No description provided for @privacyDataControllerTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Controller'**
  String get privacyDataControllerTitle;

  /// No description provided for @privacyDataControllerBullet1.
  ///
  /// In en, this message translates to:
  /// **'Data controller: {controller}'**
  String privacyDataControllerBullet1(String controller);

  /// No description provided for @privacyDataControllerBullet2.
  ///
  /// In en, this message translates to:
  /// **'App: Work Schedule'**
  String get privacyDataControllerBullet2;

  /// No description provided for @privacyDataControllerBullet3.
  ///
  /// In en, this message translates to:
  /// **'Package name: com.Appworkschedule.app'**
  String get privacyDataControllerBullet3;

  /// No description provided for @privacyDataControllerBullet4.
  ///
  /// In en, this message translates to:
  /// **'Contact: {email}'**
  String privacyDataControllerBullet4(String email);

  /// No description provided for @privacyDataCollectedTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Collected'**
  String get privacyDataCollectedTitle;

  /// No description provided for @privacyDataCollectedIntro.
  ///
  /// In en, this message translates to:
  /// **'The app may collect the following categories of data:'**
  String get privacyDataCollectedIntro;

  /// No description provided for @privacyDataCollectedBullet1.
  ///
  /// In en, this message translates to:
  /// **'Account information: email, password (securely processed by Firebase), Google profile information'**
  String get privacyDataCollectedBullet1;

  /// No description provided for @privacyDataCollectedBullet2.
  ///
  /// In en, this message translates to:
  /// **'Task and event data: title, description, dates, priority, location, attendees'**
  String get privacyDataCollectedBullet2;

  /// No description provided for @privacyDataCollectedBullet3.
  ///
  /// In en, this message translates to:
  /// **'Event attachments: photos and files'**
  String get privacyDataCollectedBullet3;

  /// No description provided for @privacyDataCollectedBullet4.
  ///
  /// In en, this message translates to:
  /// **'Google Calendar data (if sync is enabled)'**
  String get privacyDataCollectedBullet4;

  /// No description provided for @privacyDataCollectedBullet5.
  ///
  /// In en, this message translates to:
  /// **'Preferences: theme, notification, and sync settings'**
  String get privacyDataCollectedBullet5;

  /// No description provided for @privacyDataCollectedBullet6.
  ///
  /// In en, this message translates to:
  /// **'Device timezone (for reminders)'**
  String get privacyDataCollectedBullet6;

  /// No description provided for @privacyDataCollectedBullet7.
  ///
  /// In en, this message translates to:
  /// **'Login credentials saved with \"Remember me\" (stored locally on device)'**
  String get privacyDataCollectedBullet7;

  /// No description provided for @privacyDataUseTitle.
  ///
  /// In en, this message translates to:
  /// **'Purposes of Data Use'**
  String get privacyDataUseTitle;

  /// No description provided for @privacyDataUseBullet1.
  ///
  /// In en, this message translates to:
  /// **'Account creation and authentication'**
  String get privacyDataUseBullet1;

  /// No description provided for @privacyDataUseBullet2.
  ///
  /// In en, this message translates to:
  /// **'Task and event management'**
  String get privacyDataUseBullet2;

  /// No description provided for @privacyDataUseBullet3.
  ///
  /// In en, this message translates to:
  /// **'Reminder and notification delivery'**
  String get privacyDataUseBullet3;

  /// No description provided for @privacyDataUseBullet4.
  ///
  /// In en, this message translates to:
  /// **'Cloud sync and backup'**
  String get privacyDataUseBullet4;

  /// No description provided for @privacyDataUseBullet5.
  ///
  /// In en, this message translates to:
  /// **'Google Calendar synchronization'**
  String get privacyDataUseBullet5;

  /// No description provided for @privacyDataUseBullet6.
  ///
  /// In en, this message translates to:
  /// **'Calendar sharing and export'**
  String get privacyDataUseBullet6;

  /// No description provided for @privacyDataUseBullet7.
  ///
  /// In en, this message translates to:
  /// **'Providing schedule information via AI Assistant'**
  String get privacyDataUseBullet7;

  /// No description provided for @privacyDataUseBullet8.
  ///
  /// In en, this message translates to:
  /// **'App security'**
  String get privacyDataUseBullet8;

  /// No description provided for @privacyLegalBasisTitle.
  ///
  /// In en, this message translates to:
  /// **'Legal Basis (KVKK)'**
  String get privacyLegalBasisTitle;

  /// No description provided for @privacyLegalBasisBody.
  ///
  /// In en, this message translates to:
  /// **'Your personal data is processed based on contract performance, legitimate interest, and your explicit consent (Google connection, notifications, camera/gallery permissions) under KVKK.'**
  String get privacyLegalBasisBody;

  /// No description provided for @privacyStorageTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Storage'**
  String get privacyStorageTitle;

  /// No description provided for @privacyStorageBullet1.
  ///
  /// In en, this message translates to:
  /// **'Tasks and events are stored in the SQLite database on your device'**
  String get privacyStorageBullet1;

  /// No description provided for @privacyStorageBullet2.
  ///
  /// In en, this message translates to:
  /// **'If sync is enabled, data is stored on Google Firebase (Firestore)'**
  String get privacyStorageBullet2;

  /// No description provided for @privacyStorageBullet3.
  ///
  /// In en, this message translates to:
  /// **'Settings are stored on your device with SharedPreferences'**
  String get privacyStorageBullet3;

  /// No description provided for @privacyStorageBullet4.
  ///
  /// In en, this message translates to:
  /// **'Attachments are stored in the app documents directory'**
  String get privacyStorageBullet4;

  /// No description provided for @privacyStorageBody.
  ///
  /// In en, this message translates to:
  /// **'Your data is retained while your account is active. Upon account deletion request, your data will be deleted subject to legal obligations.'**
  String get privacyStorageBody;

  /// No description provided for @privacyThirdPartyTitle.
  ///
  /// In en, this message translates to:
  /// **'Third-Party Services'**
  String get privacyThirdPartyTitle;

  /// No description provided for @privacyThirdPartyBullet1.
  ///
  /// In en, this message translates to:
  /// **'Google Firebase (authentication and cloud database)'**
  String get privacyThirdPartyBullet1;

  /// No description provided for @privacyThirdPartyBullet2.
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In and Google Calendar API (optional)'**
  String get privacyThirdPartyBullet2;

  /// No description provided for @privacyThirdPartyBullet3.
  ///
  /// In en, this message translates to:
  /// **'Google Fonts (fonts; IP address may be transmitted)'**
  String get privacyThirdPartyBullet3;

  /// No description provided for @privacyThirdPartyBody.
  ///
  /// In en, this message translates to:
  /// **'These service providers are subject to their own privacy policies.'**
  String get privacyThirdPartyBody;

  /// No description provided for @privacyPermissionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Device Permissions'**
  String get privacyPermissionsTitle;

  /// No description provided for @privacyPermissionsBullet1.
  ///
  /// In en, this message translates to:
  /// **'Notifications: for reminders'**
  String get privacyPermissionsBullet1;

  /// No description provided for @privacyPermissionsBullet2.
  ///
  /// In en, this message translates to:
  /// **'Camera and gallery: for event photos'**
  String get privacyPermissionsBullet2;

  /// No description provided for @privacyPermissionsBullet3.
  ///
  /// In en, this message translates to:
  /// **'File access: for import/export'**
  String get privacyPermissionsBullet3;

  /// No description provided for @privacyPermissionsBullet4.
  ///
  /// In en, this message translates to:
  /// **'Internet: for cloud sync'**
  String get privacyPermissionsBullet4;

  /// No description provided for @privacyPermissionsBullet5.
  ///
  /// In en, this message translates to:
  /// **'Device reboot: to reschedule reminders'**
  String get privacyPermissionsBullet5;

  /// No description provided for @privacyPermissionsBody.
  ///
  /// In en, this message translates to:
  /// **'You can revoke permissions at any time from your device settings.'**
  String get privacyPermissionsBody;

  /// No description provided for @privacyAiTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get privacyAiTitle;

  /// No description provided for @privacyAiBody.
  ///
  /// In en, this message translates to:
  /// **'The AI Assistant runs in local mode by default; it accesses your task and event data but does not send it to third parties. If an external AI API is configured, your question text may be sent to the relevant provider.'**
  String get privacyAiBody;

  /// No description provided for @privacySecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Security'**
  String get privacySecurityTitle;

  /// No description provided for @privacySecurityBody.
  ///
  /// In en, this message translates to:
  /// **'Industry-standard security measures are applied to protect your data. Firebase communication is conducted over encrypted connections (HTTPS/TLS).'**
  String get privacySecurityBody;

  /// No description provided for @privacySharingTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Sharing'**
  String get privacySharingTitle;

  /// No description provided for @privacySharingBody.
  ///
  /// In en, this message translates to:
  /// **'We do not sell your personal data. Data is shared only with providers necessary for service delivery, at your request (sharing/export), or when legally required.'**
  String get privacySharingBody;

  /// No description provided for @privacyRightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Rights (KVKK Article 11)'**
  String get privacyRightsTitle;

  /// No description provided for @privacyRightsBullet1.
  ///
  /// In en, this message translates to:
  /// **'Learn whether your data is being processed'**
  String get privacyRightsBullet1;

  /// No description provided for @privacyRightsBullet2.
  ///
  /// In en, this message translates to:
  /// **'Request information if processed'**
  String get privacyRightsBullet2;

  /// No description provided for @privacyRightsBullet3.
  ///
  /// In en, this message translates to:
  /// **'Request correction of incomplete or inaccurate data'**
  String get privacyRightsBullet3;

  /// No description provided for @privacyRightsBullet4.
  ///
  /// In en, this message translates to:
  /// **'Request deletion or destruction of data'**
  String get privacyRightsBullet4;

  /// No description provided for @privacyRightsBullet5.
  ///
  /// In en, this message translates to:
  /// **'Object to automated analysis results'**
  String get privacyRightsBullet5;

  /// No description provided for @privacyRightsBullet6.
  ///
  /// In en, this message translates to:
  /// **'Request compensation for damages'**
  String get privacyRightsBullet6;

  /// No description provided for @privacyRightsBody.
  ///
  /// In en, this message translates to:
  /// **'To exercise your rights, contact {email}. Your request will be answered within 30 days at the latest.'**
  String privacyRightsBody(String email);

  /// No description provided for @privacyChildrenTitle.
  ///
  /// In en, this message translates to:
  /// **'Children\'s Privacy'**
  String get privacyChildrenTitle;

  /// No description provided for @privacyChildrenBody.
  ///
  /// In en, this message translates to:
  /// **'The app is not intended for children under 13. We do not knowingly collect personal data from this age group.'**
  String get privacyChildrenBody;

  /// No description provided for @privacyTransferTitle.
  ///
  /// In en, this message translates to:
  /// **'International Data Transfer'**
  String get privacyTransferTitle;

  /// No description provided for @privacyTransferBody.
  ///
  /// In en, this message translates to:
  /// **'Firebase and Google services may process your data on servers outside Turkey. This transfer takes place within the safeguards of KVKK Article 9.'**
  String get privacyTransferBody;

  /// No description provided for @privacyChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'Policy Changes'**
  String get privacyChangesTitle;

  /// No description provided for @privacyChangesBody.
  ///
  /// In en, this message translates to:
  /// **'This policy may be updated from time to time. For significant changes, you will be notified via in-app notification or an updated date.'**
  String get privacyChangesBody;

  /// No description provided for @privacyContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get privacyContactTitle;

  /// No description provided for @privacyContactBody.
  ///
  /// In en, this message translates to:
  /// **'For questions about the privacy policy or your personal data, contact the data controller {controller} at {email}.'**
  String privacyContactBody(String controller, String email);

  /// No description provided for @packageName.
  ///
  /// In en, this message translates to:
  /// **'com.Appworkschedule.app'**
  String get packageName;

  /// No description provided for @taskReminderChannelName.
  ///
  /// In en, this message translates to:
  /// **'Task Reminders'**
  String get taskReminderChannelName;

  /// No description provided for @taskReminderChannelDesc.
  ///
  /// In en, this message translates to:
  /// **'Reminders 1 hour and 30 minutes before tasks'**
  String get taskReminderChannelDesc;

  /// No description provided for @eventReminderChannelName.
  ///
  /// In en, this message translates to:
  /// **'Reminder Notifications'**
  String get eventReminderChannelName;

  /// No description provided for @eventReminderChannelDesc.
  ///
  /// In en, this message translates to:
  /// **'Event reminders'**
  String get eventReminderChannelDesc;

  /// No description provided for @taskNotificationChannelName.
  ///
  /// In en, this message translates to:
  /// **'Task Notifications'**
  String get taskNotificationChannelName;

  /// No description provided for @taskNotificationChannelDesc.
  ///
  /// In en, this message translates to:
  /// **'Completion and snooze notifications'**
  String get taskNotificationChannelDesc;

  /// No description provided for @taskCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Task Completed ✓'**
  String get taskCompletedTitle;

  /// No description provided for @taskNotCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Task Not Completed'**
  String get taskNotCompletedTitle;

  /// No description provided for @taskCompletedOnTime.
  ///
  /// In en, this message translates to:
  /// **'\"{title}\" was completed on time for {dueTime}.'**
  String taskCompletedOnTime(String title, String dueTime);

  /// No description provided for @taskNotCompletedOverdue.
  ///
  /// In en, this message translates to:
  /// **'\"{title}\" is overdue ({dueTime}). Not completed yet.'**
  String taskNotCompletedOverdue(String title, String dueTime);

  /// No description provided for @completeAction.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get completeAction;

  /// No description provided for @snoozeAction.
  ///
  /// In en, this message translates to:
  /// **'Snooze'**
  String get snoozeAction;

  /// No description provided for @notificationPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Notification permission not granted. Enable it in Settings > Notifications.'**
  String get notificationPermissionRequired;

  /// No description provided for @exactAlarmPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Exact alarm permission required. Enable it in Settings > Permissions > Alarms & reminders.'**
  String get exactAlarmPermissionRequired;

  /// No description provided for @testNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Test Notification'**
  String get testNotificationTitle;

  /// No description provided for @testNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'If you see this, notifications are working!'**
  String get testNotificationBody;

  /// No description provided for @taskCompletedNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Task Completed'**
  String get taskCompletedNotificationTitle;

  /// No description provided for @taskCompletedNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'\"{title}\" marked as completed.'**
  String taskCompletedNotificationBody(String title);

  /// No description provided for @taskSnoozedTitle.
  ///
  /// In en, this message translates to:
  /// **'Task Snoozed'**
  String get taskSnoozedTitle;

  /// No description provided for @taskSnoozedBody.
  ///
  /// In en, this message translates to:
  /// **'\"{title}\" → {datetime}'**
  String taskSnoozedBody(String title, String datetime);

  /// No description provided for @taskReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Task Reminder'**
  String get taskReminderTitle;

  /// No description provided for @taskReminderBody.
  ///
  /// In en, this message translates to:
  /// **'{dueDate} at {dueTime} — {label} left'**
  String taskReminderBody(String dueDate, String dueTime, String label);

  /// No description provided for @notificationScheduled.
  ///
  /// In en, this message translates to:
  /// **'Notification scheduled'**
  String get notificationScheduled;

  /// No description provided for @notificationNotScheduled.
  ///
  /// In en, this message translates to:
  /// **'Notification could not be scheduled'**
  String get notificationNotScheduled;

  /// No description provided for @eventReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Event Reminder'**
  String get eventReminderTitle;

  /// No description provided for @aiTodaySchedule.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Schedule'**
  String get aiTodaySchedule;

  /// No description provided for @aiTasksUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Task information is unavailable.'**
  String get aiTasksUnavailable;

  /// No description provided for @aiGreetingHello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get aiGreetingHello;

  /// No description provided for @aiGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get aiGreetingMorning;

  /// No description provided for @aiGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get aiGreetingEvening;

  /// No description provided for @aiHelpIntro.
  ///
  /// In en, this message translates to:
  /// **'I\'m your personal calendar assistant. You can ask me:\n• \"What should I do today?\"\n• \"What\'s my next event?\"\n• \"Do I have overdue tasks?\"\n• \"Do I have free time?\"\n\nType \"help\" for all commands.'**
  String get aiHelpIntro;

  /// No description provided for @shareEventText.
  ///
  /// In en, this message translates to:
  /// **'Event: {title}'**
  String shareEventText(String title);

  /// No description provided for @defaultCalendarName.
  ///
  /// In en, this message translates to:
  /// **'WorkSchedule Calendar'**
  String get defaultCalendarName;

  /// No description provided for @timezoneCheckError.
  ///
  /// In en, this message translates to:
  /// **'Timezone check error: {error}'**
  String timezoneCheckError(String error);

  /// No description provided for @aiEventsLoadError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while loading events.'**
  String get aiEventsLoadError;

  /// No description provided for @aiEventsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Event information is unavailable.'**
  String get aiEventsUnavailable;

  /// No description provided for @aiTasksLoadError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while loading tasks.'**
  String get aiTasksLoadError;

  /// No description provided for @aiNoEventsThisWeek.
  ///
  /// In en, this message translates to:
  /// **'No events scheduled this week.'**
  String get aiNoEventsThisWeek;

  /// No description provided for @aiWeekendPlan.
  ///
  /// In en, this message translates to:
  /// **'Your Weekend Plan'**
  String get aiWeekendPlan;

  /// No description provided for @aiWeekendNoEvents.
  ///
  /// In en, this message translates to:
  /// **'No events scheduled for the weekend.'**
  String get aiWeekendNoEvents;

  /// No description provided for @aiWeekendEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing scheduled for the weekend yet. A good chance to rest! 🌿'**
  String get aiWeekendEmpty;

  /// No description provided for @aiNoOverdueTasks.
  ///
  /// In en, this message translates to:
  /// **'Great! You have no overdue tasks. Everything is on track! 🎉'**
  String get aiNoOverdueTasks;

  /// No description provided for @aiOverdueTasksTitle.
  ///
  /// In en, this message translates to:
  /// **'Overdue Tasks'**
  String get aiOverdueTasksTitle;

  /// No description provided for @aiOverdueTasksCount.
  ///
  /// In en, this message translates to:
  /// **'Overdue Tasks ({count})'**
  String aiOverdueTasksCount(int count);

  /// No description provided for @aiNoPriorityTasks.
  ///
  /// In en, this message translates to:
  /// **'You have no high-priority pending tasks.'**
  String get aiNoPriorityTasks;

  /// No description provided for @aiPriorityTasksTitle.
  ///
  /// In en, this message translates to:
  /// **'Priority Tasks'**
  String get aiPriorityTasksTitle;

  /// No description provided for @aiNextEventTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Next Event'**
  String get aiNextEventTitle;

  /// No description provided for @aiNoUpcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'No events scheduled in the next 30 days.'**
  String get aiNoUpcomingEvents;

  /// No description provided for @aiTomorrowProgram.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow\'s Schedule'**
  String get aiTomorrowProgram;

  /// No description provided for @aiTomorrowEmpty.
  ///
  /// In en, this message translates to:
  /// **'No events or tasks scheduled for tomorrow yet.'**
  String get aiTomorrowEmpty;

  /// No description provided for @aiFreeTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Free Time Today'**
  String get aiFreeTimeTitle;

  /// No description provided for @aiBusyToday.
  ///
  /// In en, this message translates to:
  /// **'You look very busy today! No free time available. Don\'t forget to rest! 😊'**
  String get aiBusyToday;

  /// No description provided for @aiTaskSummary.
  ///
  /// In en, this message translates to:
  /// **'Task Summary'**
  String get aiTaskSummary;

  /// No description provided for @aiWeekSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'This Week Summary'**
  String get aiWeekSummaryTitle;

  /// No description provided for @aiWeekEventsTitle.
  ///
  /// In en, this message translates to:
  /// **'Events This Week'**
  String get aiWeekEventsTitle;

  /// No description provided for @aiTodayEmpty.
  ///
  /// In en, this message translates to:
  /// **'No events or tasks scheduled for today. You have a relaxed day! 🎉'**
  String get aiTodayEmpty;

  /// No description provided for @aiHelpFull.
  ///
  /// In en, this message translates to:
  /// **'🤖 **AI Assistant Help**\n\nI can help you with:\n\n📅 **Daily Plan:**\n• \"What should I do today?\"\n• \"What\'s on tomorrow?\"\n• \"What\'s my weekend plan?\"\n• \"Do I have free time?\"\n• \"Am I busy today?\"\n\n📌 **Events:**\n• \"What\'s my next event?\"\n• \"What\'s planned this week?\"\n• \"What are my events?\"\n\n✅ **Tasks:**\n• \"What are my tasks?\"\n• \"Do I have overdue tasks?\"\n• \"What are my priority tasks?\"\n• \"Incomplete tasks\"\n\n📊 **Summary:**\n• \"This week\'s summary\"\n• \"Weekly summary\"\n\nYou can ask any question in natural language!'**
  String get aiHelpFull;

  /// No description provided for @aiDefaultResponse.
  ///
  /// In en, this message translates to:
  /// **'🤖 I didn\'t understand, but you can ask:\n\n• \"What should I do today?\"\n• \"What\'s my next event?\"\n• \"Do I have overdue tasks?\"\n• \"Do I have free time?\"\n• \"What\'s my weekend plan?\"\n• \"This week\'s summary\"\n\nType \"help\" for more assistance.'**
  String get aiDefaultResponse;

  /// No description provided for @wearOsNextEvent.
  ///
  /// In en, this message translates to:
  /// **'Next Event'**
  String get wearOsNextEvent;

  /// No description provided for @wearOsUrgentTasks.
  ///
  /// In en, this message translates to:
  /// **'Urgent Tasks ({count})'**
  String wearOsUrgentTasks(int count);

  /// No description provided for @wearOsTodayTasks.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Tasks'**
  String get wearOsTodayTasks;

  /// No description provided for @wearOsTasksLabel.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get wearOsTasksLabel;

  /// No description provided for @wearOsEventsLabel.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get wearOsEventsLabel;

  /// No description provided for @wearOsOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get wearOsOverdue;

  /// No description provided for @eventCardExamplesTitle.
  ///
  /// In en, this message translates to:
  /// **'Event Card Examples'**
  String get eventCardExamplesTitle;

  /// No description provided for @aiAndMoreTasks.
  ///
  /// In en, this message translates to:
  /// **'... and {count} more tasks'**
  String aiAndMoreTasks(int count);

  /// No description provided for @aiDaysOverdue.
  ///
  /// In en, this message translates to:
  /// **'{days} days overdue'**
  String aiDaysOverdue(int days);

  /// No description provided for @aiRecommendPrioritize.
  ///
  /// In en, this message translates to:
  /// **'\n💡 I recommend prioritizing these tasks.'**
  String get aiRecommendPrioritize;

  /// No description provided for @wearOsNoData.
  ///
  /// In en, this message translates to:
  /// **'No data found'**
  String get wearOsNoData;

  /// No description provided for @wearOsDailySummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'📊 Today\'s Summary'**
  String get wearOsDailySummaryTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
