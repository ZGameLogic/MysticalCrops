-- Resets screen
function resetScreen()
    mainScreen.setTextColor(0x1)
    for i=3,24 do
        mainScreen.setCursorPos(1, i)
        mainScreen.write("                                ")
    end
    mainScreen.setCursorPos(1,1)
end

-- Prints a line to the monitor
function mPrint(line)
    mainScreen.write(line)
    x,y = mainScreen.getCursorPos()
    mainScreen.setCursorPos(1,y+1)
end

-- Replaces a line to the monitor
function mReplace(y, item, count)
    mainScreen.setCursorPos(1,y)
    mainScreen.write("                                ")
    mainScreen.setCursorPos(1,y)
    printItem(item, count)
end

-- Draw delta to the screen
function drawDelta()
    -- Clear current Delta
    for i=4,10 do
        mainScreen.setCursorPos(34, i)
        mainScreen.write("                ")
    end

    -- Draw new delta
    mainScreen.setTextColor(0x1)
    mainScreen.setCursorPos(34, 4)
    mainScreen.write("________________")
    mainScreen.setCursorPos(34, 5)
    mainScreen.write("|    Delta     |")
    mainScreen.setCursorPos(34, 6)
    mainScreen.write("================")
    mainScreen.setCursorPos(34, 7)
    mainScreen.write("|"..strings.ensure_width(delta.."",14).."|")
    mainScreen.setCursorPos(34, 8)
    mainScreen.write("================")
    mainScreen.setCursorPos(34, 9)
    mainScreen.write("| /10  |  *10  |")
    mainScreen.setCursorPos(34, 10)
    mainScreen.write("================")
end

-- Prints item name and count
function printItem(item, count)
    if item == OItem then
        mainScreen.setTextColor(0x2000)
    else
        x,y = mainScreen.getCursorPos()
        if y%2==0 then
            mainScreen.setTextColor(0x1)
        else
            mainScreen.setTextColor(colors.combine(0x1, 0x100))
        end
    end
    mainScreen.write(strings.ensure_width(item, 18))
    x,y = mainScreen.getCursorPos()
        if y%2==0 then
            mainScreen.setTextColor(0x1)
        else
            mainScreen.setTextColor(colors.combine(0x1, 0x100))
        end
    mainScreen.write("|"..strings.ensure_width(shrinkNumber(count).."", 9).."|+-|")
    mainScreen.setCursorPos(1,y+1)
end

-- Shrinks large numbers
function shrinkNumber(number)
    if number > 1000000 then
        return string.format("%.3fM", number/1000000)
    end
    return number
end

-- Draw screen
function drawScreen()
    resetScreen()
    mPrint(strings.ensure_width("Resource page:" .. page,18).."|Threshold|  |")
    mPrint("================================")
    min = (page - 1) * LINES
    max = page * LINES
    for index,item in ipairs(barrel.list()) do
       if index%2 == 1 and (index+1)/2 > min and (index+1)/2 <= max then
           meItem = getItem(item.name)
           barrelItem = barrel.getItemDetail(index)
           itemCount = getCount(barrelItem.name)
           printItem(barrelItem.displayName, itemCount)
       end
    end
    if #barrel.list() > LINES then
        mainScreen.setTextColor(0x100)
	mainScreen.setCursorPos(1,24)
	mPrint("          < page >        ")
    end
    drawDelta()
end

return {resetScreen=resetScreen, mPrint=mPrint, mReplace=mReplace, drawDelta=drawDelta, printItem=printItem, shrinkNumber=shrinkNumber, drawScreen=drawScreen}