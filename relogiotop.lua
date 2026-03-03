local monitor = peripheral.wrap("back")
monitor.setTextScale(0.5)
local w, h = monitor.getSize()

while true do
    local t = os.date("!*t")
    local hora = (t.hour - 3) % 24
    local relogio = string.format("%02d:%02d", hora, t.min)

    monitor.setBackgroundColor(colors.black)
    monitor.clear()

    local cx = math.floor(w/2)

    -- 1. DESENHO COLORIDO (Topo)
    if hora >= 6 and hora < 18 then
        monitor.setBackgroundColor(colors.yellow)
        -- Sol 3x3 pixels
        for dx = -1, 1 do
            for dy = 2, 4 do
                monitor.setCursorPos(cx + dx, dy)
                monitor.write(" ")
            end
        end
    else
        monitor.setBackgroundColor(colors.white)
        -- Lua 2x2 pixels
        monitor.setCursorPos(cx, 3)
        monitor.write("  ")
        monitor.setCursorPos(cx, 4)
        monitor.write("  ")
    end

    -- 2. RELÓGIO GIGANTE (Base)
    monitor.setBackgroundColor(colors.black)
    monitor.setTextColor(colors.lime)
    monitor.setTextScale(2) -- ESCALA 2 DEIXA O HORÁRIO ENORME
    
    local w2, h2 = monitor.getSize()
    local x_pos = math.floor((w2 - #relogio) / 2) + 1
    monitor.setCursorPos(x_pos, h2 - 1)
    monitor.write(relogio)

    monitor.setTextScale(0.5) -- Volta para escala do desenho
    sleep(10)
end
