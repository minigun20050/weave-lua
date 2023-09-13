--[[
    Author: LiterallyNN
    Pattern scanning for weave.

    Заебало, я с 2 до 5:30 сижу и все еще не закончил - в 3 раз переписываю (да, все плохо с ффи у меня)
      Экзи, если ты это читаешь, добавь пожалуйста нормальный паттерн скан <3

    Есть несколько сбособов сделать что-то типа паттернскана в луашках, которые я пробовал:
      1. Как в читах (указатели и PIMAGE_DOS_HEADER/PIMAGE_NT_HEADER) - у меня не вышло, потому что я скорее всего где-то с указателями накосячил
      2. По-убогому (честно уже не помню как пытался, но пытался!) - не вышло потому что сам метод убогий, хз как я вообще к нему пришел :/
      3. Тот, что используется сейчас. Просто получает полностью весь файл. Максимально тупое и легкое решение, но почти в 6 утра я не хочу писать что-то сложнее
    Но можно реализовать иначе, получая байты по чанкам (размер, например, 1024 * 20 - взял из головы конечно же)
      В этом случае все будет сильно лучше, так как файл грузится не целиком (+ уходит проблема с тем,
        что будет использовать несколько сотен мб оперативы если очень много модулей будет отсканировано),
            и луашке банально не надо для поиска нужного грузить вообще всё
              (что как бы улучшает скорость загрузки скрипта в дохулиард раз)

    Идею к последнему подал .cygu, ему за это спасибо, но его код не работал по вполне очевидной причине, но я чет тогда это пропустил,
       а так бы мог иметь рабочий паттернскан и не ебал бы себе мозги сейчас :(

    Я сделал в 6:16 сука, в 6:16! А мог бы выспаться...
--]]

local ffi = require("ffi")

ffi.cdef [[
    typedef unsigned long   DWORD;
    typedef long            LONG;
    typedef int             BOOL;
    typedef unsigned char   BYTE;
    typedef unsigned short  WORD;
    typedef char            CHAR;
    typedef size_t          SIZE_T;
    typedef unsigned long   *ULONG_PTR;
    typedef void            *LPVOID, *LPCVOID;
    typedef void            *HANDLE;

    typedef const CHAR      *LPCSTR, *PCSTR;
]]

ffi.cdef [[
    typedef struct {
        uint16_t e_magic;       // Magic number (0x4D42 for "MZ")
        uint16_t e_cblp;        // Bytes on last page of file
        uint16_t e_cp;          // Pages in file
        uint16_t e_crlc;        // Relocations
        uint16_t e_cparhdr;     // Size of header in paragraphs
        uint16_t e_minalloc;    // Minimum extra paragraphs needed
        uint16_t e_maxalloc;    // Maximum extra paragraphs needed
        uint16_t e_ss;          // Initial (relative) SS value
        uint16_t e_sp;          // Initial SP value
        uint16_t e_csum;        // Checksum
        uint16_t e_ip;          // Initial IP value
        uint16_t e_cs;          // Initial (relative) CS value
        uint16_t e_lfarlc;      // File address of relocation table
        uint16_t e_ovno;        // Overlay number
        uint16_t e_res[4];      // Reserved words
        uint16_t e_oemid;       // OEM identifier (for e_oeminfo)
        uint16_t e_oeminfo;     // OEM information; e_oemid specific
        uint16_t e_res2[10];    // Reserved words
        int32_t e_lfanew;       // File address of new exe header
    } IMAGE_DOS_HEADER, *PIMAGE_DOS_HEADER;

    typedef struct {
        WORD   Machine;
        WORD   NumberOfSections;
        DWORD  TimeDateStamp;
        DWORD  PointerToSymbolTable;
        DWORD  NumberOfSymbols;
        WORD   SizeOfOptionalHeader;
        WORD   Characteristics;
    } IMAGE_FILE_HEADER, *PIMAGE_FILE_HEADER;

    typedef struct {
        WORD   Magic;
        BYTE   MajorLinkerVersion;
        BYTE   MinorLinkerVersion;
        DWORD  SizeOfCode;
        DWORD  SizeOfInitializedData;
        DWORD  SizeOfUninitializedData;
        DWORD  AddressOfEntryPoint;
        DWORD  BaseOfCode;
        DWORD  BaseOfData;
        DWORD  ImageBase;
        DWORD  SectionAlignment;
        DWORD  FileAlignment;
        WORD   MajorOperatingSystemVersion;
        WORD   MinorOperatingSystemVersion;
        WORD   MajorImageVersion;
        WORD   MinorImageVersion;
        WORD   MajorSubsystemVersion;
        WORD   MinorSubsystemVersion;
        DWORD  Win32VersionValue;
        DWORD  SizeOfImage;
        DWORD  SizeOfHeaders;
        DWORD  CheckSum;
        WORD   Subsystem;
        WORD   DllCharacteristics;
        DWORD  SizeOfStackReserve;
        DWORD  SizeOfStackCommit;
        DWORD  SizeOfHeapReserve;
        DWORD  SizeOfHeapCommit;
        DWORD  LoaderFlags;
        DWORD  NumberOfRvaAndSizes;
    } IMAGE_OPTIONAL_HEADER;

    typedef struct {
        uint32_t            Signature;
        IMAGE_FILE_HEADER   FileHeader;
        IMAGE_OPTIONAL_HEADER OptionalHeader;
    } IMAGE_NT_HEADERS, *PIMAGE_NT_HEADERS;
]]

ffi.cdef [[ 
    void* GetModuleHandleA(LPCSTR lpModuleName);
    BOOL ReadProcessMemory(HANDLE hProcess, const void* lpBaseAddress, void* lpBuffer, size_t nSize, size_t* lpNumberOfBytesRead);
    HANDLE OpenProcess(DWORD dwDesiredAccess, BOOL  bInheritHandle, DWORD dwProcessId);
    BOOL CloseHandle(HANDLE hObject);
]]

ffi.cdef[[
    typedef struct {
        DWORD     dwSize;
        DWORD     cntUsage;
        DWORD     th32ProcessID;
        ULONG_PTR th32DefaultHeapID;
        DWORD     th32ModuleID;
        DWORD     cntThreads;
        DWORD     th32ParentProcessID;
        LONG      pcPriClassBase;
        DWORD     dwFlags;
        CHAR      szExeFile[260];
      } PROCESSENTRY32, *LPPROCESSENTRY32;

    BOOL __stdcall Process32First(HANDLE hSnapshot, LPPROCESSENTRY32 lppe);
    BOOL __stdcall Process32Next(HANDLE hSnapshot, LPPROCESSENTRY32 lppe);
    HANDLE __stdcall CreateToolhelp32Snapshot(DWORD dwFlags, DWORD th32ProcessID);
]]

local pattern_scan = {}; do
    pattern_scan["found"] = {} -- cache to prevent idiotic devs that makes sigscan every frame/tick
    pattern_scan["bytes"] = {} -- cache to prevent calling shit everytime someone needs signature
    pattern_scan["csgo_handle"] = nil

    local signature_to_bytes = function(signature)
        local signature_bytes = {}
        for byteStr in string.gmatch(signature, "%S+") do
            table.insert(signature_bytes, byteStr == "?" and -1 or tonumber(byteStr, 16))
        end
        return signature_bytes
    end

    -- https://stackoverflow.com/questions/865152/how-can-i-get-a-process-handle-by-its-name-in-c
    local get_handle_by_name = function(fname)
        local entry = ffi.new("PROCESSENTRY32")
        local entry_ptr = ffi.cast("PROCESSENTRY32*", entry)
        entry.dwSize = ffi.sizeof(entry)

        local handle = ffi.new("HANDLE")

        local snapshot = ffi.new("HANDLE")
            snapshot = ffi.C.CreateToolhelp32Snapshot(0x00000002, 0)

        if ffi.C.Process32First(snapshot, entry_ptr) == 1 then
            local fowund = false
            while ffi.C.Process32Next(snapshot, entry_ptr) == 1 do
                if ffi.string(entry.szExeFile) == fname then
                    handle = ffi.C.OpenProcess(0x1F0FFF, 0, entry.th32ProcessID)
                    ffi.C.CloseHandle(snapshot)
                    fowund = true
                    break
                end
            end
            if not fowund then
                error("Can't get " .. fname .. " handle.")
                return -1
            end
        else
            error("Can't get " .. fname .. " handle.")
            return -1
        end
        
        return handle
    end
    
    pattern_scan["csgo_handle"] = get_handle_by_name("csgo.exe")

    function pattern_scan:find(mname, signature_)
        local handle = ffi.C.GetModuleHandleA(mname)
        if handle == nil then
            error("Can't get handle of " .. mname)
            return -1
        end

        local dos_header = ffi.cast("PIMAGE_DOS_HEADER", handle)
        print("Got DOS header.\n\te_lfanew: " .. tostring(dos_header.e_lfanew))
        
        local nt_header = ffi.cast("PIMAGE_NT_HEADERS", ffi.cast("int*", handle) + dos_header.e_lfanew)
        print("Got NT header.\n\tOptional header address: " .. tostring(nt_header.OptionalHeader) .. "\n\tImage size: " .. tostring(ffi.cast("int*", nt_header.OptionalHeader) + 0x50))
        
        local size = tonumber(ffi.cast("uintptr_t", ffi.cast("int*", nt_header.OptionalHeader) + 0x50))
        local start_pointer = tonumber(ffi.cast("uintptr_t", handle))
        
        local buffer = nil -- we're allocating ram for whole file only if it's not cached
        local bytes_count = nil
        if self.bytes[mname] == nil then
            print("Getting module bytes")
            
            bytes_count = ffi.new("int")
            print("Trying to allocate " .. tostring(size) .. " bytes...")
            buffer = ffi.new("BYTE[?]", size / 8)
            
            ffi.C.ReadProcessMemory(self.csgo_handle, ffi.cast("unsigned int*", start_pointer), buffer, size, ffi.cast("int*", bytes_count))
            
            print("Got module bytes.\n\tTotal: " .. tostring(bytes_count))
            
            self.bytes[mname] = {}
            self.bytes[mname]["buffer"] = ffi.string(buffer)
            self.bytes[mname]["count"] = bytes_count
        else
            buffer = self.bytes[mname]["buffer"]
            bytes_count = self.bytes[mname]["count"]
            print("Loaded module bytes in cache")
        end

        bytes_count = tonumber(ffi.cast("int", bytes_count))

        local signature = signature_to_bytes(signature_)
        print("Trying to find signature in " .. mname .. "\n\tModule size: " .. tostring(size) .. "\n\tSignature: " .. signature_ .. " [ " .. table.concat(signature, " ") .. " ]" .. "\n\tSignature length: " .. tostring(#signature) .. "\n\tStart pointer: " .. tostring(start_pointer))

        local addr = nil
        local found = 0
        for i = 0, size do
            if found == #signature then
                addr = start_pointer + i - found
                break
            end
            if signature[found + 1] == -1 or buffer[i] == signature[found + 1] then
                found = found + 1
            else
                found = 0
            end
        end

        if addr == nil then
            error("Can't find signature " .. signature_ .. ". Outdated?")
            return -1
        end
        return addr
    end
end

return pattern_scan