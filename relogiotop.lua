local monitor = peripheral.wrap("back")
if not monitor then
    print("Monitor nao encontrado!")
    return
end

monitor.setTextScale(1)

-- Matrizes para os desenhos (Pixel Art)
-- Y = Amarelo, W = Branco, L = Cinza Claro, Espaço = Fundo
local sol = {
    "  YYY  ",
    " YYYYY ",
    " YYYYY ",
    "  YYY  "
}

local lua = {
    "  LLL ",
    " LL   ",
    " LL   ",
    "  LLL "
}

local nuvem = {
    "  WW  ",
    " WWWW "
}

-- Função que lê a matriz e pinta os blocos na tela
local function drawArt(startX, startY, artData, bgBase)
    for y, row in ipairs(artData) do
        monitor.setCursorPos(startX, startY + y - 1)
        for x = 1, #row do
            local char = row:sub(x, x)
            if char == "Y" then monitor.setBackgroundColor(colors.yellow)
            elseif char == "W" then monitor.setBackgroundColor(colors.white)
            elseif char == "L" then monitor.setBackgroundColor(colors.lightGray)
            else monitor.setBackgroundColor(bgBase) end
            
            monitor.write(" ") -- Pinta 1 caractere de espaço com a cor de fundo
        end
    end
end

while true do
    local w, h = monitor.getSize()
    local t = os.date("!*t")
    local hora = (t.hour - 3) % 24 -- Fuso horário BRT (UTC-3)
    local relogio = string.format("%02d:%02d", hora, t.min)

    local isDay = hora >= 6 and hora < 18
    local bgBase = isDay and colors.lightBlue or colors.black

    -- Limpa a tela inteira com a cor base (Céu Azul ou Noite Preta)
    monitor.setBackgroundColor(bgBase)
    monitor.clear()

    local x_centro = math.floor(w / 2)
    local y_centro = math.floor(h / 2)

    -- Desenha o cenário dependendo do horário
    if isDay then
        -- Desenha Sol centralizado e Nuvens nos cantos
        drawArt(x_centro - 3, y_centro - 6, sol, bgBase)
        drawArt(3, 2, nuvem, bgBase)
        drawArt(w - 7, y_centro - 2, nuvem, bgBase)
    else
        -- Desenha Lua centralizada
        drawArt(x_centro - 2, y_centro - 6, lua, bgBase)
        
        -- Desenha algumas estrelas no fundo
        monitor.setBackgroundColor(colors.black)
        monitor.setTextColor(colors.yellow)
        monitor.setCursorPos(4, 3) monitor.write("*")
        monitor.setCursorPos(w - 5, 2) monitor.write("+")
        monitor.setCursorPos(w - 3, y_centro) monitor.write(".")
        monitor.setCursorPos(6, h - 3) monitor.write(".")
    end

    -- Relógio Verde / Branco no centro
    monitor.setBackgroundColor(bgBase)
    if isDay then
        monitor.setTextColor(colors.white)
    else
        monitor.setTextColor(colors.lime)
    end

    local x_relogio = math.floor((w - #relogio) / 2) + 1
    monitor.setCursorPos(x_relogio, y_centro + 1)
    monitor.write(relogio)

    -- Saudação para preencher a parte de baixo da tela
    local saudacao = ""
    if hora >= 6 and hora < 12 then saudacao = "BOM DIA!"
    elseif hora >= 12 and hora < 18 then saudacao = "BOA TARDE!"
    else saudacao = "BOA NOITE!" end

    local x_saudacao = math.floor((w - #saudacao) / 2) + 1
    monitor.setCursorPos(x_saudacao, y_centro + 3)
    
    if isDay then
        monitor.setTextColor(colors.yellow)
    else
        monitor.setTextColor(colors.lightGray)
    end
    monitor.write(saudacao)

    sleep(10)
end
