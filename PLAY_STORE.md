# Play Store upload — Student Guide

Application ID: `com.audrey.student.guide`  
Version in `pubspec.yaml`: `1.0.0+1` (name `1.0.0`, version code `1`)

## 1. Create the upload keystore (once)

Keep this file private. Losing it means you cannot update the app on Play.

```bash
keytool -genkey -v \
  -keystore android/upload-keystore.jks \
  -storetype JKS \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias upload
```

Copy `android/key.properties.example` to `android/key.properties` and fill in the passwords. `key.properties` and `*.jks` are gitignored.

## 2. Build the Android App Bundle

```bash
flutter pub get
dart run flutter_launcher_icons
flutter build appbundle --release
```

The file to upload:

`build/app/outputs/bundle/release/app-release.aab`

If `key.properties` is missing, the release build still signs with the debug key. Play Console will reject that — add the upload keystore first.

## 3. Store listing

**App name (30 chars):** Student Guide

**Short description (80 chars):** Plan classes, tasks, and exams. Track GPA and study with a timer and flashcards.

**Full description:**

Student Guide helps you stay on top of school without an account or ads.

• Home dashboard with today’s classes, due work, exam countdown, GPA, and study streak  
• Planner for assignments, a weekly timetable, and exams  
• Subjects with credits, weighted scores, and a 4.0 GPA  
• Notes and flashcard decks for active recall  
• Pomodoro study timer with a daily minute goal  
• Study tips for recall, exams, notes, and wellbeing  
• Light and dark theme  
• Export or import a backup JSON file  

Your data stays on this device. There are no ads, no tracking, and no sign-in.

**Category:** Education  
**Tags:** student, planner, GPA, flashcards, study timer  
**Contact email:** use the same address as your Play Console account.

## 4. Graphics

- High-res icon: Play Console accepts 512×512; the launcher source is `assets/icon/app_icon.png`
- Feature graphic: `assets/store/feature_graphic.png` (crop to 1024×500 in Play Console if needed)
- Phone screenshots: run the app on a device or emulator and capture Home, Planner, Study, Grades, and Timer (at least 2)

## 5. Privacy and the rest of Play Console

Follow **[PLAY_CONSOLE.md](PLAY_CONSOLE.md)** for the privacy policy URL and every App content / store listing answer (sign-in, ads, rating, audience, Data safety, government, financial, health, category, listing).

## 6. Content rating

Questionnaire: Education / reference. No violence, no user-generated public sharing, no ads. Expected rating: Everyone / PEGI 3.

## 7. After upload

Each Play update must increase `version:` in `pubspec.yaml`, for example `1.0.1+2`.
