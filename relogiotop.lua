local monitor = peripheral.wrap("back")
if not monitor then
    print("Monitor nao encontrado!")
    return
end

monitor.setTextScale(1)

-- Matrizes para os desenhos
local sol = {
    "  YYY  ",
    " YYYYY ",
    " YYYYY ",
    "  YYY  "
}

-- Formato de Lua ajustado (Crescente/Minguante fina)
local lua = {
    "  WW  ",
    " W    ",
    " W    ",
    "  WW  "
}

local nuvem = {
    "  WW  ",
    " WWWW "
}

local frases = {
    {"Menos foco,", "mais ansiedade"},
    {"Sabe onde sua", "ex ta agora?"},
    "oq sobra?", -- Frases curtas podem ficar em uma linha só
    {"durma enquanto", "eles trabalham."},
    {"se ta dificil pra vc,", "ta facil pra alguem."},
    "vamos dar um tempo.",
    "Eu tenteii...",
    {"ela nunca foi sua,", "so tava na sua vez"}
}

local function drawArt(startX, startY, artData, bgBase)
    for y, row in ipairs(artData) do
        monitor.setCursorPos(startX, startY + y - 1)
        for x = 1, #row do
            local char = row:sub(x, x)
            if char == "Y" then monitor.setBackgroundColor(colors.yellow)
            elseif char == "W" then monitor.setBackgroundColor(colors.white)
            elseif char == "L" then monitor.setBackgroundColor(colors.lightGray)
            else monitor.setBackgroundColor(bgBase) end
            
            monitor.write(" ")
        end
    end
end

local tick = 0

while true do
    local w, h = monitor.getSize()
    local t = os.date("!*t")
    local hora = (t.hour - 3) % 24
    local relogio = string.format("%02d:%02d", hora, t.min)

    local isDay = hora >= 6 and hora < 18
    
    -- Mudei para 'colors.blue' para não estourar a luz do shader
    local bgBase = isDay and colors.blue or colors.black

    monitor.setBackgroundColor(bgBase)
    monitor.clear()

    local x_centro = math.floor(w / 2)
    local y_centro = math.floor(h / 2)

    if isDay then
        drawArt(x_centro - 3, y_centro - 6, sol, bgBase)
        drawArt(3, 2, nuvem, bgBase)
        drawArt(w - 7, y_centro - 2, nuvem, bgBase)
    else
        drawArt(x_centro - 2, y_centro - 6, lua, bgBase)
        
        monitor.setBackgroundColor(colors.black)
        monitor.setTextColor(colors.yellow)
        monitor.setCursorPos(4, 3) monitor.write("*")
        monitor.setCursorPos(w - 5, 2) monitor.write("+")
        monitor.setCursorPos(w - 3, y_centro) monitor.write(".")
        monitor.setCursorPos(6, h - 3) monitor.write(".")
    end

    monitor.setBackgroundColor(bgBase)
    
    -- Texto preto de dia para dar leitura com o shader, verde à noite
    if isDay then
        monitor.setTextColor(colors.black)
    else
        monitor.setTextColor(colors.lime)
    end

    local x_relogio = math.floor((w - #relogio) / 2) + 1
    monitor.setCursorPos(x_relogio, y_centro + 1)
    monitor.write(relogio)

    local texto_linha1 = ""
    local texto_linha2 = ""
    
    if tick % 2 == 0 then
        if hora >= 6 and hora < 12 then texto_linha1 = "BOM DIA!"
        elseif hora >= 12 and hora < 18 then texto_linha1 = "BOA TARDE!"
        else texto_linha1 = "BOA NOITE!" end
    else
        math.randomseed(os.time() + tick)
        local index = math.random(1, #frases)
        local frase_escolhida = frases[index]
        
        if type(frase_escolhida) == "table" then
            texto_linha1 = frase_escolhida[1]
            texto_linha2 = frase_escolhida[2]
        else
            texto_linha1 = frase_escolhida
        end
    end

    local x_texto1 = math.floor((w - #texto_linha1) / 2) + 1
    monitor.setCursorPos(x_texto1, y_centro + 3)
    
    -- Texto preto de dia para dar leitura
    if isDay then
        monitor.setTextColor(colors.black)
    else
        monitor.setTextColor(colors.lightGray)
    end
    monitor.write(texto_linha1)

    if texto_linha2 ~= "" then
        local x_texto2 = math.floor((w - #texto_linha2) / 2) + 1
        monitor.setCursorPos(x_texto2, y_centro + 4)
        monitor.write(texto_linha2)
    end

    tick = tick + 1
    sleep(10)
end
