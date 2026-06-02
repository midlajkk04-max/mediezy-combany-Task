# Zyromate HR Task

A production-quality Flutter HR mobile application built with Provider state management and MVVM architecture. The app manages employee attendance, leave applications, and route tracking via REST API.

## Project Overview

- **Project Name:** zyromate_hr_task
- **Architecture:** MVVM with Provider
- **State Management:** Provider
- **API Base URL:** `https://test.zyromate.com/api/`
- **Language:** Dart
- **Platform:** Flutter (Android)

## Features

- **Authentication:** Login and Register with API
- **Dashboard:** Attendance status, quick actions (Route, Apply Leave), recent activity
- **Attendance:** Mark In / Mark Out with GPS location
- **Leave Management:** Apply leave (full/half day), view leave list with status filters
- **Route Management:** View route list, search routes, view on map
- **Persistent Login:** Session saved via SharedPreferences

## Architecture (MVVM)

```
lib/
├── main.dart                     # App entry, Provider setup
├── core/
│   ├── constants/                # AppColors, ApiConstants, AppStrings
│   ├── network/                  # ApiClient/DioClient, endpoints, exceptions
│   ├── storage/                  # LocalStorageService (SharedPreferences)
│   └── utils/                    # Validators, DateUtils, LocationHelper
├── data/
│   ├── models/                   # Data models with fromJson parsing
│   └── repositories/            # API repositories
├── viewmodels/                   # ChangeNotifier ViewModels
├── views/
│   ├── splash/                   # Splash screen
│   ├── auth/                     # Login, Register
│   ├── dashboard/                # Dashboard
│   ├── leave/                    # Apply Leave, Leave List
│   ├── route/                    # Route List, Route Map
│   └── main/                     # Main navigation
└── widgets/                      # Reusable UI components
```

## Screens

1. **Splash Screen** - Auto-login check via SharedPreferences
2. **Login Screen** - Mobile number + password authentication
3. **Register Screen** - Create account with date pickers
4. **Dashboard Screen** - Attendance card, action cards, recent activity
5. **Apply Leave Screen** - Full/Half day toggle, date pickers, leave type dropdown
6. **Leave List Screen** - Filter tabs (All/Pending/Approved/Rejected), month selector
7. **Route List Screen** - Searchable route history
8. **Route Map Screen** - Google Maps with marker (fallback when no API key)

## How to Run

### Prerequisites

- Flutter SDK (latest stable)
- Dart SDK (latest stable)
- Android Studio / VS Code
- Physical device or emulator

### Steps

```bash
# Clone the repository
git clone https://github.com/your-username/zyromate_hr_task.git
cd zyromate_hr_task

# Get dependencies
flutter pub get

# Run the app
flutter run

# Build APK
flutter build apk --release
```

## API Endpoints

| Method | Endpoint                 | Description        |
|--------|--------------------------|--------------------|
| POST   | /user-login              | User login         |
| POST   | /register                | User registration  |
| GET    | /attendance/status       | Attendance status  |
| POST   | /attendance/mark         | Mark attendance    |
| POST   | /apply-leave             | Apply for leave    |
| POST   | /leaves                  | Leave list         |
| GET    | /attendance/route-list   | Route list         |

## Dependencies

- **provider**: State management
- **dio**: HTTP client with interceptors
- **shared_preferences**: Local persistence
- **intl**: Date formatting
- **geolocator**: GPS location
- **permission_handler**: Runtime permissions
- **google_maps_flutter**: Map display (optional, add API key)

## Google Maps Setup

To enable the map view, add your Google Maps API key:

**Android:**
In `android/app/src/main/AndroidManifest.xml`, uncomment the `com.google.android.geo.API_KEY` meta-data and replace `YOUR_GOOGLE_MAPS_API_KEY_HERE` with your key.

**iOS:**
In `ios/Runner/AppDelegate.swift`, add `GMSServices.provideAPIKey("YOUR_KEY_HERE")`.

## Build Commands

```bash
# Debug build
flutter run

# Release APK
flutter build apk --release

# Split APKs per architecture
flutter build apk --split-per-abi

# App bundle
flutter build appbundle
```

## APK Location

After building, the APK is located at:
```
build/app/outputs/flutter-apk/app-release.apk
```

## GitHub Submission Steps

```bash
git init
git add .
git commit -m "Initial commit: Zyromate HR app with MVVM + Provider"
git branch -M main
git remote add origin https://github.com/your-username/zyromate_hr_task.git
git push -u origin main
```
