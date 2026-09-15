plugins {
    id("com.android.application")
    id("kotlin-android")

    // Flutter Gradle Plugin must be applied after
    // Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.pahad_alert_app"

    compileSdk = flutter.compileSdkVersion

    // Keep Flutter's NDK version
    ndkVersion = flutter.ndkVersion

    // ============================================================
    // JAVA 17
    // ============================================================

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    // ============================================================
    // KOTLIN 17
    // ============================================================

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    // ============================================================
    // DEFAULT CONFIG
    // ============================================================

    defaultConfig {
        applicationId = "com.example.pahad_alert_app"

        // ArcGIS Maps SDK for Flutter requires Android API 28+
        minSdk = 28

        targetSdk = flutter.targetSdkVersion

        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // ============================================================
    // RELEASE
    // ============================================================

    buildTypes {
        release {
            // Debug signing for now.
            // Later you can add your own release keystore.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

// ================================================================
// FLUTTER
// ================================================================

flutter {
    source = "../.."
}