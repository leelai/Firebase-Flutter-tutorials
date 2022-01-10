## Install

Install libs
```
flutter pub get
```

Install launcher icon
```
flutter pub run flutter_launcher_icons:main -f flutter_launcher_icons-siot.yaml

flutter pub run flutter_launcher_icons:main -f flutter_launcher_icons-ciot.yaml
```
## Debug

```
flutter run --flavor siot
flutter run --flavor ciot
```

## Build apk

```
flutter build apk --debug --flavor siot
flutter build apk --debug --flavor ciot
```
## Reference
Source code For Firebase Realtime Database Tutorial

https://petercoding.com/firebase/2021/05/04/using-firebase-cloud-messaging-in-flutter/
