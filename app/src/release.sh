#!/bin/bash

set -e

# Setup gcloud
echo $GOOGLE_AUTH_JSON > $GOOGLE_APPLICATION_CREDENTIALS
gcloud config set core/project $GOOGLE_PROJECT_ID
gcloud auth activate-service-account \
  --key-file $GOOGLE_APPLICATION_CREDENTIALS
gsutil cp gs://minodisk-credentials/certificates/release.keystore ./android/app/

# Setup Android SDK
echo $ANDROID_LICENSE > $ANDROID_HOME/licenses/android-sdk-license

# Build Android Application
cd android
./gradlew assembleRelease
cd -
react-native run-android --variant=release
