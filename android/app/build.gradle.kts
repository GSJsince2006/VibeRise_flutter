import java.io.File as JFile
import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystorePropsFile = rootProject.file("key.properties")
val keystoreProps = Properties().apply {
    if (keystorePropsFile.exists()) {
        load(FileInputStream(keystorePropsFile))
    }
}

android {
    namespace = "com.example.vibe_rise"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.vibe_rise"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    ndkVersion = "27.0.12077973"

    signingConfigs {
        create("release") {
            storeFile = keystoreProps["storeFile"]?.let { file(it as String) }
            storePassword = keystoreProps["storePassword"] as String?
            keyAlias = keystoreProps["keyAlias"] as String?
            keyPassword = keystoreProps["keyPassword"] as String?
        }
    }

    buildTypes {
        // keep debug for development
        getByName("debug") {
            isDebuggable = true
            // optional:
            // applicationIdSuffix = ".debug"
            // versionNameSuffix = "-debug"
        }

        getByName("release") {
            // THIS is the important line:
            signingConfig = signingConfigs.getByName("release")

            // optional optimizations (enable later once things work)
            // isMinifyEnabled = true
            // isShrinkResources = true
            // proguardFiles(
            //     getDefaultProguardFile("proguard-android-optimize.txt"),
            //     "proguard-rules.pro"
            // )
            isDebuggable = false
        }
    }
}

flutter {
    source = "../.."
}

// === Post-build rename for final APKs in outputs/apk/release (handles single APK and split-per-abi) ===
// Works for both single APK and split-per-abi builds
// ---- Rename only the final APKs in outputs/apk/release ----

val releaseOutDir = layout.buildDirectory.dir("outputs/apk/release")

tasks.register("renameReleaseApk") {
    doLast {
        val dir = releaseOutDir.get().asFile
        if (!dir.exists()) return@doLast

        dir.listFiles()?.forEach { f ->
            when {
                // Single, non‑split build
                f.name == "app-release.apk" -> {
                    val target = dir.resolve("viberise-release.apk")
                    if (target.exists()) target.delete()
                    f.renameTo(target)
                }

                // Split‑per‑ABI build (e.g., app-arm64-v8a-release.apk)
                f.name.startsWith("app-") && f.name.endsWith("-release.apk") -> {
                    val abi = f.name.removePrefix("app-").removeSuffix("-release.apk")
                    val target = dir.resolve("viberise-$abi-release.apk")
                    if (target.exists()) target.delete()
                    f.renameTo(target)
                }
            }
        }
    }
}

// Hook up only after Gradle actually creates assembleRelease (Flutter creates tasks late)
tasks.whenTaskAdded {
    if (name == "assembleRelease") {
        finalizedBy("renameReleaseApk")
    }
}

