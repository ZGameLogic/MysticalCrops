local function formatNumber(number)
    if(number > 1000000000000) then
        return string.format("%.1fT", number/1000000000000)
    elseif(number > 1000000000) then
        return string.format("%.1fB", number/1000000000)
    elseif(number > 1000000) then
        return string.format("%.1fM", number/1000000)
    else
        return string.format("%d", number)
    end
end

local number = 12

print(formatNumber(number))
print(number)