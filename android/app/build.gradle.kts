plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")

    // 🔥 WAJIB Firebase
    id("com.google.gms.google-services")
}

android {
    namespace = "com.hafeeza.ramadhan_app"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.hafeeza.ramadhan_app"
        minSdk = 23
        targetSdk = 34

        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        debug {
            isMinifyEnabled = false
            isShrinkResources = false
        }

        release {
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17

        // 🔴 WAJIB untuk flutter_local_notifications
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "17"
    }
}

dependencies {
    // 🔴 WAJIB untuk desugaring Java 8+ API
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}

flutter {
    source = "../.."
}
