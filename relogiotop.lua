local monitor = peripheral.wrap("back")
monitor.setTextScale(1) -- Escala segura para 4 monitores
local w, h = monitor.getSize()

while true do
    local t = os.date("!*t")
    local hora = (t.hour - 3) % 24
    local relogio = string.format("%02d:%02d", hora, t.min)

    monitor.setBackgroundColor(colors.black)
    monitor.clear()

    -- Centraliza tudo automaticamente
    local x_centro = math.floor(w / 2)
    local y_centro = math.floor(h / 2)

    -- DESENHO (SOL OU LUA) NO MEIO
    if hora >= 6 and hora < 18 then
        monitor.setCursorPos(x_centro - 1, y_centro - 2)
        monitor.setBackgroundColor(colors.yellow)
        monitor.write("   ") -- Um bloco amarelo
    else
        monitor.setCursorPos(x_centro, y_centro - 2)
        monitor.setBackgroundColor(colors.white)
        monitor.write("  ") -- Um bloco branco
    end

    -- RELÓGIO VERDE LOGO ABAIXO
    monitor.setBackgroundColor(colors.black)
    monitor.setTextColor(colors.lime)
    monitor.setCursorPos(math.floor((w - #relogio) / 2) + 1, y_centro + 1)
    monitor.write(relogio)

    sleep(10)
end
