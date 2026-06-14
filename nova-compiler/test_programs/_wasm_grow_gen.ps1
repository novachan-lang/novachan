Set-Location $PSScriptRoot
# Generator for grow.wasm -- the memory.grow oracle (see wasm_grow_test.nova).
# Module: 1 page initial memory. main():
#   i32.const 1; memory.grow      -> grows to 2 pages, pushes prev page count (1)
#   i32.const 65536; i32.const 42; i32.store   -> write 42 at the FIRST byte of the
#                                                 newly grown 2nd page (only valid
#                                                 because grow succeeded)
#   i32.const 65536; i32.load; i32.add   -> 1 (prev pages) + 42 (loaded) = 43
# Oracle: wasm_run returns 43 ONLY if memory.grow really extended the buffer, zeroed
# the new page, and returned the previous page count.
$wasm = [byte[]]@(
    0x00,0x61,0x73,0x6D, 0x01,0x00,0x00,0x00,            # magic + version
    0x01,0x05,0x01,0x60,0x00,0x01,0x7F,                  # type: () -> i32
    0x03,0x02,0x01,0x00,                                 # func: 1 func, type 0
    0x05,0x03,0x01,0x00,0x01,                            # memory: 1 mem, flags 0, min 1 page
    0x07,0x08,0x01,0x04,0x6D,0x61,0x69,0x6E,0x00,0x00,   # export "main" -> func 0
    0x0A,0x19,0x01,0x17,                                 # code: section 0x19, 1 func, body 0x17 (23)
        0x00,                                            #  locals: 0
        0x41,0x01,                                       #  i32.const 1
        0x40,0x00,                                       #  memory.grow (reserved 0x00) -> prev pages
        0x41,0x80,0x80,0x04,                             #  i32.const 65536 (addr in new page)
        0x41,0x2A,                                       #  i32.const 42 (value)
        0x36,0x02,0x00,                                  #  i32.store @ mem[65536]
        0x41,0x80,0x80,0x04,                             #  i32.const 65536
        0x28,0x02,0x00,                                  #  i32.load mem[65536] -> 42
        0x6A,                                            #  i32.add -> 1 + 42 = 43
    0x0B                                                 # end
)
[System.IO.File]::WriteAllBytes("$PSScriptRoot\grow.wasm", $wasm)
Write-Host ("wrote grow.wasm (" + $wasm.Length + " bytes)")
