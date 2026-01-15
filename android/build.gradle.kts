buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // 🔥 WAJIB untuk Firebase
        classpath("com.google.gms:google-services:4.4.1")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// 🔽 Optimasi build directory (hemat disk, aman)
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    project.evaluationDependsOn(":app")
}

// 🔽 Clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
