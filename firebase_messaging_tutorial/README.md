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

## Build apk (debug)

```
flutter build apk --debug --flavor siot
flutter build apk --debug --flavor ciot

cd .//build/app/outputs/apk/siot/debug/
cd .//build/app/outputs/apk/ciot/debug/
```

## Build apk (release)

```
flutter build apk --release --flavor siot
flutter build apk --release --flavor ciot

cd .//build/app/outputs/apk/siot/release/
cd .//build/app/outputs/apk/ciot/release/
```

## Build apk (aab)

必須要先修改keystore的路徑

路徑設定android/key.properties
```
storeFile=XXXXXXX/keystore
```


```
flutter build appbundle --release --flavor siot
flutter build appbundle --release --flavor ciot

cd .//build/app/outputs/bundle/ciotRelease/
cd .//build/app/outputs/bundle/siotRelease/
```
## Reference
Source code For Firebase Realtime Database Tutorial

https://petercoding.com/firebase/2021/05/04/using-firebase-cloud-messaging-in-flutter/
