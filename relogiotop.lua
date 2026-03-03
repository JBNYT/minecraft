local monitor = peripheral.wrap("back")
monitor.setTextScale(0.5)
local w, h = monitor.getSize()

while true do
    local t = os.date("!*t")
    local hora = (t.hour - 3) % 24
    local relogio = string.format("%02d:%02d", hora, t.min)

    monitor.setBackgroundColor(colors.black)
    monitor.clear()

    local cx, cy = math.floor(w/2), 8
    if hora >= 6 and hora < 18 then
        -- SOL GIGANTE (Desenho com blocos)
        monitor.setBackgroundColor(colors.yellow)
        for dx = -2, 2 do
            for dy = -1, 1 do
                monitor.setCursorPos(cx + dx, cy + dy)
                monitor.write(" ")
            end
        end
    else
        -- LUA GIGANTE + ESTRELAS
        monitor.setBackgroundColor(colors.white)
        monitor.setCursorPos(cx-1, cy)
        monitor.write("    ") -- Corpo da lua
        -- Estrelas aleatórias
        monitor.setBackgroundColor(colors.black)
        monitor.setTextColor(colors.lightGray)
        for i=1, 5 do
            monitor.setCursorPos(math.random(2, w-2), math.random(2, 10))
            monitor.write(".")
        end
    end

    -- RELÓGIO GIGANTE (Escala 1 ou 2 para ocupar a largura)
    monitor.setBackgroundColor(colors.black)
    monitor.setTextScale(1.5) -- Aumenta aqui para o horário ficar enorme
    monitor.setTextColor(colors.lime)
    
    local w_g, h_g = monitor.getSize()
    monitor.setCursorPos(math.floor((w_g - #relogio)/2) + 1, h_g - 2)
    monitor.write(relogio)

    monitor.setTextScale(0.5) -- Volta para os desenhos
    sleep(15)
end
