package nova

import nova.lexer.Lexer
import nova.parser.*
import java.io.File

data class ModuleInfo(
    val name: String,
    val path: List<String>,
    val file: File,
    val program: Program,
    val publicFunctions: Set<String>,
    val publicTypes: Set<String>,
    val publicEnums: Set<String>,
    val imports: List<ImportStmt>
)

class ModuleResolver(private val projectRoot: File) {

    private val resolved = mutableMapOf<String, ModuleInfo>()

    fun resolve(importPath: List<String>, fromFile: File): ModuleInfo? {
        val key = importPath.joinToString(".")
        resolved[key]?.let { return it }

        val file = findModuleFile(importPath, fromFile) ?: return null
        val info = parseModule(importPath, file) ?: return null
        resolved[key] = info
        return info
    }

    fun resolveAll(mainFile: File): List<ModuleInfo> {
        val mainProgram = parseFile(mainFile) ?: return emptyList()
        val mainInfo = extractModuleInfo("main", listOf("main"), mainFile, mainProgram)

        val order = mutableListOf<ModuleInfo>()
        val visited = mutableSetOf<String>()
        val visiting = mutableSetOf<String>()

        fun visit(info: ModuleInfo): Boolean {
            val key = info.path.joinToString(".")
            if (key in visited) return true
            if (key in visiting) {
                System.err.println("error: circular dependency detected involving module '${info.name}'")
                return false
            }
            visiting.add(key)

            for (imp in info.imports) {
                val depInfo = resolve(imp.path, info.file)
                if (depInfo != null) {
                    if (!visit(depInfo)) return false
                }
            }

            visiting.remove(key)
            visited.add(key)
            order.add(info)
            return true
        }

        for (imp in mainInfo.imports) {
            val depInfo = resolve(imp.path, mainFile)
            if (depInfo != null) {
                if (!visit(depInfo)) return emptyList()
            }
        }
        order.add(mainInfo)
        return order
    }

    private fun findModuleFile(importPath: List<String>, fromFile: File): File? {
        val fromDir = fromFile.parentFile ?: projectRoot
        val relativePath = importPath.joinToString(File.separator) + ".nova"

        // 1. Check relative to the importing file's directory
        val relativeFile = File(fromDir, relativePath)
        if (relativeFile.exists()) return relativeFile

        // 2. Check single-segment import in same directory
        if (importPath.size == 1) {
            val sameDir = File(fromDir, importPath[0] + ".nova")
            if (sameDir.exists()) return sameDir
        }

        // 3. Check relative to project root
        val rootFile = File(projectRoot, relativePath)
        if (rootFile.exists()) return rootFile

        // 4. Check stdlib directory (relative to project root or jar location)
        for (stdlibDir in findStdlibDirs()) {
            val stdlibFile = File(stdlibDir, relativePath)
            if (stdlibFile.exists()) return stdlibFile
        }

        // 5. Check for directory module: path/to/module/mod.nova
        val dirPath = importPath.joinToString(File.separator)
        val dirMod = File(fromDir, "$dirPath${File.separator}mod.nova")
        if (dirMod.exists()) return dirMod
        val rootDirMod = File(projectRoot, "$dirPath${File.separator}mod.nova")
        if (rootDirMod.exists()) return rootDirMod

        return null
    }

    private fun findStdlibDirs(): List<File> {
        val dirs = mutableListOf<File>()
        val seen = mutableSetOf<String>()
        fun addIfDir(f: File) {
            val path = f.canonicalPath
            if (path !in seen && f.isDirectory) { seen.add(path); dirs.add(f) }
        }

        // 1. Relative to project root
        addIfDir(File(projectRoot, "stdlib"))

        // 2. Walk up from project root (handles subdirectory source files)
        var parent = projectRoot.canonicalFile.parentFile
        while (parent != null) {
            addIfDir(File(parent, "stdlib"))
            parent = parent.parentFile
        }

        // 3. Current working directory
        addIfDir(File(System.getProperty("user.dir"), "stdlib"))

        // 4. Relative to the jar/class location
        val classUrl = ModuleResolver::class.java.protectionDomain?.codeSource?.location
        if (classUrl != null) {
            val jarDir = File(classUrl.toURI()).parentFile
            addIfDir(File(jarDir, "stdlib"))
            if (jarDir.parentFile != null) addIfDir(File(jarDir.parentFile, "stdlib"))
        }
        return dirs
    }

    private fun parseFile(file: File): Program? {
        val src = file.readText()
        val tokens = Lexer(src, file.name).tokenize()
        val parser = Parser(tokens)
        val prog = parser.parse()
        if (parser.errors.isNotEmpty()) {
            System.err.println("Parse errors in ${file.name}:")
            parser.errors.forEach { System.err.println("  $it") }
            return null
        }
        return prog
    }

    private fun parseModule(importPath: List<String>, file: File): ModuleInfo? {
        val program = parseFile(file) ?: return null
        val name = importPath.last()
        return extractModuleInfo(name, importPath, file, program)
    }

    private fun extractModuleInfo(name: String, path: List<String>, file: File, program: Program): ModuleInfo {
        val publicFns = mutableSetOf<String>()
        val publicTypes = mutableSetOf<String>()
        val publicEnums = mutableSetOf<String>()
        val imports = mutableListOf<ImportStmt>()

        for (stmt in program.stmts) {
            when (stmt) {
                is FnDecl -> {
                    if (!stmt.name.startsWith("_")) publicFns.add(stmt.name)
                }
                is TypeDecl -> {
                    if (!stmt.name.startsWith("_")) publicTypes.add(stmt.name)
                }
                is EnumDecl -> {
                    if (!stmt.name.startsWith("_")) publicEnums.add(stmt.name)
                }
                is ImportStmt -> imports.add(stmt)
                else -> {}
            }
        }

        return ModuleInfo(name, path, file, program, publicFns, publicTypes, publicEnums, imports)
    }
}
