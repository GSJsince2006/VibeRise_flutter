// android/build.gradle.kts  (root of the Android folder)

// No plugin versions here — Flutter’s settings.gradle handles that.
// Keep the root build file minimal.

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

tasks.register<Delete>("clean") {
    delete(layout.buildDirectory)
}
