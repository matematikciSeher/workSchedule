allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Some pub plugins omit `namespace` in android/build.gradle; AGP 8+ requires it (match AndroidManifest package).
val legacyLibraryNamespaces =
    mapOf(
        "isar_flutter_libs" to "dev.isar.isar_flutter_libs",
    )
subprojects {
    plugins.withId("com.android.library") {
        val namespace = legacyLibraryNamespaces[project.name] ?: return@withId
        val androidExt = project.extensions.findByName("android") ?: return@withId
        val getNs = androidExt.javaClass.methods.find { it.name == "getNamespace" } ?: return@withId
        val current = getNs.invoke(androidExt) as? String
        if (current.isNullOrEmpty()) {
            androidExt.javaClass.getMethod("setNamespace", String::class.java)
                .invoke(androidExt, namespace)
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
