class Languages {
  static Lang currentLocal;
  Map<String, Lang> _langs = {
    "ar": Lang("First screen title", "First intro screen description ",
        "Welcome to Eggate online shop"),
    "en": Lang("First screen title", "First intro screen description ",
        "Welcome to Eggate online shop"),
  };

  void getLocal(String local) {
    Languages.currentLocal = _langs[local];
  }
}

class Lang {
  String firstIntroTitle;
  String firstIntroDescription;
  String welcomeScreen;
  Lang(this.firstIntroTitle, this.firstIntroDescription, this.welcomeScreen);
}
