class UserData {
  String uid;
  bool isHomeTutorialSeen;
  bool isSettingsTutorialSeen;
  String calendarToUse;
  String calendarToUseName;
  String email;
  bool nightOwl;
  int sweetSpotStart;
  int sweetSpotEnd;
  int morning;
  int night;
  bool isWelcomeScreenSeen;
  List deviceCalendars;
  bool isLoading;
  UserData(
      {this.isHomeTutorialSeen,
      this.isSettingsTutorialSeen,
      this.isLoading,
      this.isWelcomeScreenSeen,
      this.calendarToUseName,
      this.calendarToUse,
      this.uid,
      this.morning,
      this.night,
      this.email,
      this.nightOwl,
      this.sweetSpotEnd,
      this.sweetSpotStart,
      this.deviceCalendars});
}
