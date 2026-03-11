# Play Store App Bundle – Checklist

Do these steps **before** running `flutter build appbundle`.

---

## Done in this project

- **Version** – `pubspec.yaml` has `version: 2.0.0+4` (versionName+versionCode).
- **Application ID** – Set in `android/app/build.gradle.kts`: `com.liwasride.user`.
- **Multidex** – `multiDexEnabled = true` in `defaultConfig`.
- **Release signing** – Uses release keystore when `android/key.properties` exists.
- **NDK debug symbols** – `debugSymbolLevel = "SYMBOL_TABLE"` for release (for Play Console crash reports).
- **Secrets** – `key.properties`, `*.jks`, `*.keystore` are in `.gitignore`.
- **Template** – `android/key.properties.example` shows how to create `key.properties`.

---

## You must do manually

### 1. Create upload keystore (once)

From the project root:

```bash
keytool -genkey -v -keystore android/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

- Store the `.jks` file and passwords safely (e.g. backup drive).
- You need the same keystore for all future updates.

### 2. Create `android/key.properties`

Copy the example and edit with your real values:

```bash
# Windows (PowerShell)
copy android\key.properties.example android\key.properties

# Then edit android/key.properties:
# - storePassword, keyPassword = passwords you set when creating the keystore
# - keyAlias = upload
# - storeFile = upload-keystore.jks   (or path relative to android/ folder)
```

Example content:

```properties
storePassword=your_keystore_password
keyPassword=your_key_password
keyAlias=upload
storeFile=upload-keystore.jks
```

If the keystore is in the project root instead of `android/`:

```properties
storeFile=../upload-keystore.jks
```

### 3. Generate launcher icons

From the project root:

```bash
dart run flutter_launcher_icons
```

Uses `assets/image/logo.png` (configured in `pubspec.yaml`). Ensure the image exists and is at least 1024×1024 for best results.

### 4. (Optional) Analyze and test

```bash
flutter clean
flutter pub get
flutter analyze
flutter test
```

---

## Build the app bundle

```bash
flutter build appbundle
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### With Dart/Flutter debug symbols (for Play Console)

To upload symbol files for better crash reports:

```bash
flutter build appbundle --split-debug-info=build/app/outputs/symbols
```

Then upload the generated symbols (ZIP or folder) in Play Console → your app → Release → App bundle explorer → the version → Debug symbols.

---

## Quick reference

| Step                    | Status / Action                    |
|-------------------------|------------------------------------|
| Version in pubspec      | Done                               |
| applicationId           | Done                               |
| Multidex                | Done                               |
| Release signing config  | Done (use release when key exists) |
| NDK debug symbols       | Done                               |
| key.properties in .gitignore | Done                         |
| Create keystore         | You do once                        |
| Create key.properties   | You do (from example)              |
| Generate launcher icons | Run `dart run flutter_launcher_icons` |
| Build app bundle        | Run `flutter build appbundle`      |
