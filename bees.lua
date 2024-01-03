--Bees by Ben
mainScreen = peripheral.wrap("monitor_0")
strings = require("cc.strings")
require("../BeesPrintingLib")

barrel = peripheral.wrap("metalbarrels:diamond_tile_0")
network = peripheral.wrap("right")
dataFilePath = "/data.txt"

-- Item lists for AE and Barrel
vItems = {}
iItems = {}

LINES = 20
page = 1
currentSize = 0

-- Overwrite item
OItem = ""
OItemName = ""
OItemIndex = 0

-- Increment/Decrement item
delta = 1000

mainScreen.setTextScale(1.25)

-- Updates item list
function updateItems()
    vItems = network.listItems()
    file = io.open(dataFilePath, "r")
    io.input(file)
    iItems = textutils.unserialize(io.read("a"))
end

-- Gets an item from the ME system
function getItem(itemName)
    for index,item in pairs(vItems) do
        if item.name == itemName then
            return item
        end
    end
end

-- Handles touch event
function handleTouch(x, y)
    -- Selecting resource
    if x<18 and y<23 and y>2 then
        index = (page-1)*2*LINES+((y-2)*2)-1
        newItem = barrel.getItemDetail(index).displayName
        if newItem == OItem then
            oldItem = OItem
            oldItemName = OItemName		
            OItem = ""
            OItemName = ""
            OItemIndex = 0
            mReplace(y, oldItem, getCount(oldItemName))
        elseif OItem == "" then
            OItem = newItem
            OItemName = barrel.getItemDetail(index).name
            OItemIndex = (page-1)*LINES+y-2
            mReplace(y, OItem, getCount(OItemName))
        else
            oldItem = OItem
            oldItemName = OItemName
            oldItemIndex = OItemIndex
            OItem = newItem
            OItemName = barrel.getItemDetail(index).name
            OItemIndex = (page-1)*LINES+y-2
            if oldItemIndex > (page-1)*LINES and oldItemIndex <= page*LINES then
                mReplace(oldItemIndex+2, oldItem, getCount(oldItemName))
            end
            mReplace(y, OItem, getCount(OItemName))
        end
    end

    -- Page turn
    if x<28 and y==24 then
        if x<14 then
            if page-1>0 then
                page = page - 1
                drawScreen()
            end
	else
            if (page+1)*LINES<#barrel.list() then
                page = page + 1
		drawScreen()
            end
	end
    end

    -- Increment/Decrement 30:+ 31:-
    if x==31 or x==30 and y>2 and y<23 then
        index = (page-1)*2*LINES+((y-2)*2)-1
        itemName = barrel.getItemDetail(index).name
        itemCount = getCount(itemName)
        if x==30 then
            newCount = itemCount + delta
        else
            newCount = itemCount - delta
        end
        if newCount < 0 then newCount = 0 end
        updateCount(itemName, newCount)
        updateItems()
        mReplace(y, barrel.getItemDetail(index).displayName, getCount(itemName))
    end

    -- Change delta
    if y==9 and x>34 and x<49 then
        if x>41 and delta~=10000000000000 then
            delta = delta*10
            drawDelta()
        elseif delta~=1 then
            delta = delta/10
            drawDelta()
        end
    end
end

-- Gets the count for an item
function getCount(itemName)
    if iItems ~= nil and iItems[itemName] ~= nil then
        return iItems[itemName]
    end
    updateCount(itemName, 1000)
    updateItems()
    return 1000
end

-- Updates the current file with a new count
function updateCount(itemName, count)
    -- Edit data
    if iItems == nil then
        iItems = {}
    end
    iItems[itemName] = count
    -- Write data
    file = io.open(dataFilePath, "w")
    io.output(file)
    io.write(textutils.serialise(iItems))
    io.flush()
end

-- Listens for touch event
function listenTouch()
    while true do
        event, size, xPos, yPos = os.pullEvent("monitor_touch")
        handleTouch(xPos, yPos)
    end
end

-- Works through the exporting of honeycomb
function listenTime()
    while true do
        updateItems()
	if OItemName ~= "" then
            -- place into buffer
            honeyComb = barrel.getItemDetail(OItemIndex*2).name
            HCItem = getItem(honeyComb)
            if HCItem ~= nil then
                HCCount = HCItem.count
                if HCCount > 64 then
                    HCCount = 64
                end
                network.exportItem({name=honeyComb, count=HCCount},"UP")
            end
        end
        if #barrel.list() ~= currentSize then
            drawScreen()
            currentSize = #barrel.list()
        end
        if #barrel.list()%2==0 then
            for slot,item in pairs(barrel.list()) do
                if slot % 2 == 1 then
                    count = getCount(item.name)
                    --check if count in ME system is good
                    meItem = getItem(item.name)
                    if meItem == nil or count > meItem.count then
                        -- place into buffer
                        honeyComb = barrel.getItemDetail(slot+1).name
                        HCItem = getItem(honeyComb)
                        if HCItem ~= nil then
                            HCCount = HCItem.count
                            if HCCount > 64 then
                                HCCount = 64
                            end
                            network.exportItem({name=honeyComb, count=HCCount},"UP")
                        end
                    end                
                end
            end
        end
        sleep(1)
    end    
end

updateItems()
parallel.waitForAll(listenTouch, listenTime)
