local localCounter = 0
local functionCounter = 0

-- Xuablu style header ekleyen fonksiyon
local function xuabluStyle(sourceCode)
    local header = "-- Decompiled with the Xuablu Luau decompiler.\n\n"
    return header .. sourceCode
end

-- Local ve function isimlerini düzenleyen fonksiyon
local function renameLocalsAndFunctions(sourceCode)
    sourceCode = sourceCode:gsub("local%s+([%w_]+)", function(varName)
        localCounter = localCounter + 1
        return "local l__" .. varName .. "__" .. localCounter
    end)

    sourceCode = sourceCode:gsub("function%s+([%w_]+)", function(funcName)
        functionCounter = functionCounter + 1
        return "function u" .. functionCounter
    end)

    return sourceCode
end

-- -- yorumları temizleyen fonksiyon (Xuablu header hariç)
local function removeComments(sourceCode)
    local cleanedLines = {}
    local headerAdded = false

    for line in sourceCode:gmatch("[^\r\n]+") do
        if line:find("-- Decompiled with the Xuablu Luau decompiler") then
            table.insert(cleanedLines, line)
            headerAdded = true
        elseif not line:find("^%s*%-%-") then
            table.insert(cleanedLines, line)
        end
    end

    return table.concat(cleanedLines, "\n")
end

-- Bytecode'u alacak fonksiyon (Kendi bytecode'umuzu yazıyoruz)
function getscriptbytecode(script)
    local bytecode = ""
    
    -- Bytecode'u oluşturacak mantık
    -- Bu örnekte, her karakteri byte olarak alıyoruz (daha karmaşık olabilir)
    for i = 1, #script.Source do
        bytecode = bytecode .. string.char(script.Source:byte(i))
    end
    
    return bytecode
end

-- Bytecode çözümleme fonksiyonu
function decompile(bytecode)
    local source = ""
    
    -- Bytecode'u çözme mantığı (sadece bir örnek)
    for i = 1, #bytecode do
        source = source .. string.char(bytecode:byte(i))
    end
    
    return source
end

-- Global decompile fonksiyonu
getgenv().decompile = function(script)
    local bytecode = getscriptbytecode(script)
    local source = decompile(bytecode)

    -- Xuablu style formatına ekleme
    source = renameLocalsAndFunctions(source)
    source = xuabluStyle(source)
    source = removeComments(source)

    return source
end

