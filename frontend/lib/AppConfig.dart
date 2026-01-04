class AppConfig {
  // Enable this if your device is an emulator ran in an IDE or such
  static const bool isEmulator = false;

  static const String emulatorBasedUrl = 'http://10.0.2.2:8080';
  // If you use a physical device like an Android Phone,
  // you should configure this setting for your appropriate IPV4 address on your host machine
  static const String deviceBasedUrl = 'http://10.0.0.10:8080';

  static String getBaseUrl (){
    return isEmulator ? emulatorBasedUrl : deviceBasedUrl;
  }
}

