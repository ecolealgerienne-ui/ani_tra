
subprojects {
    // Pour tous les modules Android (app & libraries)
    plugins.withId("com.android.application") {
        extensions.configure<com.android.build.gradle.AppExtension>("android") {
            compileOptions {
                sourceCompatibility = JavaVersion.VERSION_17
                targetCompatibility = JavaVersion.VERSION_17
                isCoreLibraryDesugaringEnabled = true
            }
        }
    }
    plugins.withId("com.android.library") {
        extensions.configure<com.android.build.gradle.LibraryExtension>("android") {
            compileOptions {
                sourceCompatibility = JavaVersion.VERSION_17
                targetCompatibility = JavaVersion.VERSION_17
                isCoreLibraryDesugaringEnabled = true
            }
        }
    }

    // Pour tous les modules Kotlin (y compris libs tierces du projet)
    tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
        kotlinOptions {
            jvmTarget = JavaVersion.VERSION_17.toString()
        }
    }

    // Dernier filet de sécurité : si un module Java pur traîne encore en 1.8,
    // on lui pousse un "release 17"
    tasks.withType<JavaCompile>().configureEach {
        options.release.set(17)
        // (Optionnel) couper le warning si une lib externe insiste à 1.8 :
        // options.compilerArgs.add("-Xlint:-options")
    }
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.animal_trace"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    // ----- Java compile options (passage à 17) -----
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    // ----- Kotlin JVM target (17) -----
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString() // "17"
    }

    defaultConfig {
        applicationId = "com.example.animal_trace"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

// ----- Toolchains : force Java 17 pour éviter l’avertissement JDK 21 -----
java {
    toolchain {
        languageVersion.set(JavaLanguageVersion.of(17))
    }
}

kotlin {
    jvmToolchain(17)
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.2")
}
