plugins {
    kotlin("jvm") version "2.0.21"
    application
}

group = "nova"
// Single source of truth: nova-compiler/VERSION (also read at runtime by nova_find_version()
// in nova_compiler.nova). Bump the VERSION file, not this line.
version = file("VERSION").readText().trim()

repositories {
    mavenCentral()
}

dependencies {
    testImplementation(kotlin("test"))
    testImplementation("org.junit.jupiter:junit-jupiter:5.10.2")
    testImplementation("org.junit.jupiter:junit-jupiter-params:5.10.2")
}

application {
    mainClass.set("nova.EmitLlvmKt")
}

tasks.register<Jar>("fatJar") {
    archiveClassifier.set("all")
    duplicatesStrategy = DuplicatesStrategy.EXCLUDE
    manifest {
        attributes["Main-Class"] = "nova.EmitLlvmKt"
    }
    from(configurations.runtimeClasspath.get().map { if (it.isDirectory) it else zipTree(it) })
    with(tasks.jar.get())
}

tasks.test {
    useJUnitPlatform()
}

kotlin {
    jvmToolchain(21)
}
