-- Resets screen
function resetScreen()
    mainScreen.setTextColor(0x1)
    for i=3,24 do
        mainScreen.setCursorPos(1, i)
        mainScreen.write("                                ")
    end
    mainScreen.setCursorPos(1,1)
end

return {resetScreen=resetScreen}