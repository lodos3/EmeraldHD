plugins {
    id("com.android.application")
}

android {
    namespace = "dev.dgdigital.trainernexus"
    compileSdk = 36
    buildToolsVersion = "35.0.0"

    defaultConfig {
        applicationId = "dev.dgdigital.trainernexus"
        minSdk = 28
        targetSdk = 36
        versionCode = 1
        versionName = "0.1.0-foundation"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
}
