local monitor = peripheral.wrap("back")
if not monitor then
    print("Monitor nao encontrado!")
    return
end

monitor.setTextScale(1)

-- Matrizes para os desenhos (Pixel Art)
local sol = {
    "  YYY  ",
    " YYYYY ",
    " YYYYY ",
    "  YYY  "
}

-- Lua em formato minguante/crescente natural
local lua = {
    "  WW  ",
    " WWW  ",
    " WWW  ",
    "  WW  "
}

local nuvem = {
    "  WW  ",
    " WWWW "
}

-- Lista de frases (curtas para caber no monitor 2x2)
local frases = {
    "O tempo ensina.",
    "Respire fundo.",
    "Um passo por vez.",
    "A jornada importa.",
    "Foco no processo.",
    "Tudo e licao.",
    "A mente cria.",
    "Aproveite o agora."
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

local tick = 0 -- Variável para controlar a alternância do texto

while true do
    local w, h = monitor.getSize()
    local t = os.date("!*t")
    local hora = (t.hour - 3) % 24 -- Fuso horário BRT (UTC-3)
    local relogio = string.format("%02d:%02d", hora, t.min)

    local isDay = hora >= 6 and hora < 18
    local bgBase = isDay and colors.lightBlue or colors.black

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
    if isDay then
        monitor.setTextColor(colors.white)
    else
        monitor.setTextColor(colors.lime)
    end

    local x_relogio = math.floor((w - #relogio) / 2) + 1
    monitor.setCursorPos(x_relogio, y_centro + 1)
    monitor.write(relogio)

    -- Lógica de alternância de texto
    local texto_inferior = ""
    
    if tick % 2 == 0 then
        -- Mostra a saudação a cada 10s
        if hora >= 6 and hora < 12 then texto_inferior = "BOM DIA, WINGZ!"
        elseif hora >= 12 and hora < 18 then texto_inferior = "BOA TARDE, WINGZ!"
        else texto_inferior = "BOA NOITE, WINGZ!" end
    else
        -- Mostra uma frase filosófica aleatória nos outros 10s
        math.randomseed(os.time() + tick)
        local index = math.random(1, #frases)
        texto_inferior = frases[index]
    end

    local x_texto = math.floor((w - #texto_inferior) / 2) + 1
    monitor.setCursorPos(x_texto, y_centro + 3)
    
    if isDay then
        monitor.setTextColor(colors.yellow)
    else
        monitor.setTextColor(colors.lightGray)
    end
    monitor.write(texto_inferior)

    tick = tick + 1 -- Aumenta o contador para a próxima rodada
    sleep(10)
end
