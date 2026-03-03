local monitor = peripheral.wrap("back")
monitor.setTextScale(0.5)
local w, h = monitor.getSize()

while true do
    local t = os.date("!*t")
    local hora = (t.hour - 3) % 24
    local relogio = string.format("%02d:%02d", hora, t.min)

    monitor.setBackgroundColor(colors.black)
    monitor.clear()

    local cx, cy = math.floor(w/2), 6
    if hora >= 6 and hora < 18 then
        -- Desenha Sol Amarelo Sólido
        monitor.setBackgroundColor(colors.yellow)
        for dx = -1, 1 do
            for dy = -1, 1 do
                monitor.setCursorPos(cx + dx, cy + dy)
                monitor.write(" ")
            end
        end
    else
        -- Desenha Lua Branca
        monitor.setBackgroundColor(colors.white)
        monitor.setCursorPos(cx, cy)
        monitor.write("  ")
    end

    -- Relógio Verde Gamer (Escala maior)
    monitor.setBackgroundColor(colors.black)
    monitor.setTextColor(colors.lime)
    monitor.setCursorPos(math.floor((w - #relogio)/2) + 1, h - 3)
    monitor.write(relogio)

    sleep(10)
end