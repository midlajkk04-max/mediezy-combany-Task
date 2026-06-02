# Mediezy HR Task - MVVM Provider

Base URL: `https://test.zyromate.com/api/`

Implemented flow:
- Login with mobile number + password
- Register/Create Account
- Dashboard with attendance status
- Mark In / Mark Out with current latitude & longitude
- Apply Leave
- Leave List with All/Pending/Approved/Rejected filters
- Route List
- My Route Map screen

## Run
```bash
flutter pub get
flutter run
```

## Android permission
Add these to `android/app/src/main/AndroidManifest.xml` above `<application>`:
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
```

For Google Map, add Google Maps API key inside AndroidManifest if you use real map.


## Included HR Flow Update
- Login uses `mobile_number` and `password`, not username.
- Dashboard Mark In / Mark Out uses `/attendance/mark` with current latitude and longitude.
- Create Route screen is included. Because HR provided no separate create-route endpoint, route start/stop is handled using `/attendance/mark` with location, and route history is loaded using `/attendance/route-list`.
- Route List screen calls `/attendance/route-list` and opens My Route map screen.
- Apply Leave screen calls `/apply-leave`.
- Leave List screen calls `/leaves` with filters: all, pending, approved, rejected.
- SharedPreferences stores login state and user/employee id.
- MVVM + Provider structure is used.
