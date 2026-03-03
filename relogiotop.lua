local monitor = peripheral.wrap("back")
monitor.setTextScale(1) -- Escala 1 é ideal para 4 monitores (2x2)
local w, h = monitor.getSize()

while true do
    local t = os.date("!*t")
    local hora = (t.hour - 3) % 24
    local relogio = string.format("%02d:%02d", hora, t.min)

    monitor.setBackgroundColor(colors.black)
    monitor.clear()

    -- 1. DESENHO CENTRAL (SOL OU LUA)
    local cx = math.floor(w/2)
    if hora >= 6 and hora < 18 then
        monitor.setCursorPos(cx - 1, 2)
        monitor.setBackgroundColor(colors.yellow)
        monitor.write("   ") -- Topo do sol
        monitor.setCursorPos(cx - 2, 3)
        monitor.write("     ") -- Meio do sol
        monitor.setCursorPos(cx - 1, 4)
        monitor.write("   ") -- Base do sol
    else
        monitor.setCursorPos(cx, 2)
        monitor.setBackgroundColor(colors.white)
        monitor.write("  ") -- Lua simples
        monitor.setCursorPos(cx + 1, 3)
        monitor.write(" ")
    end

    -- 2. RELÓGIO GIGANTE EMBAIXO
    monitor.setBackgroundColor(colors.black)
    monitor.setTextColor(colors.lime)
    -- Centraliza o texto baseado na largura (w)
    local x_pos = math.floor((w - #relogio) / 2) + 1
    monitor.setCursorPos(x_pos, h - 1)
    monitor.write(relogio)

    sleep(10)
end
