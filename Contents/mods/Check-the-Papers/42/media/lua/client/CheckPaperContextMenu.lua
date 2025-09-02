require "ISUI/ISContextMenu"

local function onFillInventoryObjectContextMenu(player, context, items)
    if not items then return end
    if #items == 1 and items[1].items then
        items = items[1].items
    end

    for _, item in ipairs(items) do
        if not instanceof(item, "InventoryItem") then
            item = item.items[1]
        end
        if item:getFullType() == "Base.IDcard" then
            context:addOption("Show ID card", item, function(_, itemRef)
                local playerObj = getSpecificPlayer(player)
                CheckPaperPlayAction.transferIfNeeded(playerObj, item)
                ISTimedActionQueue.add(CheckPaperPlayAction:new(playerObj, item))
            end)
            break
        end
    end
end

Events.OnPreFillInventoryObjectContextMenu.Add(onFillInventoryObjectContextMenu)
