package nova

import java.io.File
import java.net.HttpURLConnection
import java.net.URL

class PackageManager(private val projectDir: File = File(System.getProperty("user.dir"))) {

    private val tomlFile get() = File(projectDir, "nova.toml")
    private val packagesDir get() = File(projectDir, "nova_packages")
    private val registryBase = "https://raw.githubusercontent.com/nova-lang/packages/main/registry/"

    fun init() {
        if (tomlFile.exists()) {
            println("nova.toml already exists")
            return
        }
        val dirName = projectDir.name.replace(Regex("[^a-zA-Z0-9_-]"), "-")
        tomlFile.writeText(buildString {
            appendLine("[package]")
            appendLine("name = \"$dirName\"")
            appendLine("version = \"0.1.0\"")
            appendLine("description = \"\"")
            appendLine("author = \"\"")
            appendLine()
            appendLine("[dependencies]")
        })
        println("Created nova.toml")
    }

    fun get(pkgSpec: String) {
        val (name, version) = parsePkgSpec(pkgSpec)
        if (!tomlFile.exists()) {
            System.err.println("error: no nova.toml found. Run 'nova init' first")
            System.exit(1)
        }
        val deps = parseTomlDeps()
        if (name in deps) {
            println("Package $name already in dependencies")
            return
        }
        val tomlText = tomlFile.readText()
        tomlFile.writeText(tomlText.trimEnd() + "\n$name = \"$version\"\n")
        println("Added $name@$version to nova.toml")
        download(name, version)
    }

    fun install(): Int {
        if (!tomlFile.exists()) {
            System.err.println("error: no nova.toml found. Run 'nova init' first")
            return 1
        }
        val deps = parseTomlDeps()
        if (deps.isEmpty()) {
            println("No dependencies to install")
            return 0
        }
        println("Installing ${deps.size} package(s)...")
        var installed = 0
        for ((name, version) in deps) {
            if (download(name, version)) installed++
        }
        println("Installed $installed/${deps.size} packages")
        return if (installed == deps.size) 0 else 1
    }

    fun list() {
        if (!packagesDir.isDirectory) {
            println("No packages installed (nova_packages/ not found)")
            return
        }
        val pkgs = packagesDir.listFiles()
            ?.filter { it.isDirectory }
            ?.sorted()
            ?: emptyList()

        if (pkgs.isEmpty()) {
            println("No packages installed")
            return
        }

        val deps = if (tomlFile.exists()) parseTomlDeps() else emptyMap()

        println("Installed packages (${pkgs.size}):")
        for (dir in pkgs) {
            val novaFile = File(dir, "${dir.name}.nova")
            val status = if (novaFile.exists()) "ok" else "missing source"
            val ver = deps[dir.name] ?: "local"
            println("  ${dir.name} ($ver) [$status]")
        }
    }

    fun remove(name: String) {
        if (!tomlFile.exists()) {
            System.err.println("error: no nova.toml found")
            return
        }
        val lines = tomlFile.readLines().toMutableList()
        val filtered = lines.filter { line ->
            val trimmed = line.trim()
            !(trimmed.startsWith(name) && trimmed.contains("="))
        }
        if (filtered.size == lines.size) {
            println("Package $name not found in nova.toml")
            return
        }
        tomlFile.writeText(filtered.joinToString("\n") + "\n")
        val pkgDir = File(packagesDir, name)
        if (pkgDir.isDirectory) {
            pkgDir.deleteRecursively()
            println("Removed $name")
        } else {
            println("Removed $name from nova.toml (no local files)")
        }
    }

    private fun download(name: String, version: String): Boolean {
        val pkgDir = File(packagesDir, name)
        val marker = File(pkgDir, "$name.nova")
        if (marker.exists()) {
            println("  $name — already installed")
            return true
        }
        pkgDir.mkdirs()

        val indexUrl = "$registryBase$name/index.toml"
        val indexContent = httpGet(indexUrl)
        if (indexContent != null && !isNovaSource(indexContent)) {
            val sourceUrl = extractSourceUrl(indexContent)
            if (sourceUrl != null) {
                val content = httpGet(sourceUrl)
                if (content != null && isNovaSource(content)) {
                    marker.writeText(content)
                    println("  Downloaded $name")
                    return true
                }
            }
        }

        val ghUrl = "https://raw.githubusercontent.com/nova-lang/pkg-$name/main/$name.nova"
        val content = httpGet(ghUrl)
        if (content != null && isNovaSource(content)) {
            marker.writeText(content)
            println("  Downloaded $name (github)")
            return true
        }

        System.err.println("  error: could not download $name — not found in registry or github")
        System.err.println("  Place $name.nova in nova_packages/$name/ manually")
        return false
    }

    private fun httpGet(url: String): String? {
        return try {
            val conn = URL(url).openConnection() as HttpURLConnection
            conn.connectTimeout = 10_000
            conn.readTimeout = 10_000
            conn.requestMethod = "GET"
            conn.setRequestProperty("User-Agent", "NOVA/0.1.0")
            if (conn.responseCode == 200) {
                conn.inputStream.bufferedReader().readText()
            } else null
        } catch (_: Exception) {
            null
        }
    }

    private fun isNovaSource(content: String): Boolean {
        val t = content.trim()
        if (t.startsWith("<") || t.startsWith("<!") || t.startsWith("404")) return false
        val keywords = listOf("fn ", "//", "let ", "type ", "import ", "enum ")
        return keywords.any { t.startsWith(it) } || t.contains("fn ")
    }

    private fun extractSourceUrl(indexContent: String): String? {
        for (line in indexContent.lines()) {
            val trimmed = line.trim()
            if (trimmed.startsWith("source")) {
                val eqPos = trimmed.indexOf('=')
                if (eqPos >= 0) {
                    var value = trimmed.substring(eqPos + 1).trim()
                    if (value.length >= 2 && value.startsWith("\"")) {
                        value = value.substring(1, value.length - 1)
                    }
                    if (value.isNotEmpty()) return value
                }
            }
        }
        return null
    }

    private fun parseTomlDeps(): Map<String, String> {
        if (!tomlFile.exists()) return emptyMap()
        val deps = mutableMapOf<String, String>()
        var inDeps = false
        for (line in tomlFile.readLines()) {
            val trimmed = line.trim()
            if (trimmed == "[dependencies]") {
                inDeps = true
                continue
            }
            if (trimmed.startsWith("[") && trimmed != "[dependencies]") {
                inDeps = false
                continue
            }
            if (inDeps && trimmed.isNotEmpty() && !trimmed.startsWith("#")) {
                val eqPos = trimmed.indexOf('=')
                if (eqPos >= 0) {
                    val key = trimmed.substring(0, eqPos).trim()
                    var value = trimmed.substring(eqPos + 1).trim()
                    if (value.length >= 2 && value.startsWith("\"") && value.endsWith("\"")) {
                        value = value.substring(1, value.length - 1)
                    }
                    deps[key] = value
                }
            }
        }
        return deps
    }

    private fun parsePkgSpec(spec: String): Pair<String, String> {
        val atPos = spec.indexOf('@')
        return if (atPos >= 0) {
            Pair(spec.substring(0, atPos), spec.substring(atPos + 1))
        } else {
            Pair(spec, "*")
        }
    }

    companion object {
        fun packagesDir(projectRoot: File): File = File(projectRoot, "nova_packages")
    }
}
