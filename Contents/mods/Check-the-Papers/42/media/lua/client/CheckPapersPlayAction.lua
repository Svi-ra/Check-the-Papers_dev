require "TimedActions/ISBaseTimedAction"

CheckPaperPlayAction = ISBaseTimedAction:derive("CheckPaperPlayAction")

function CheckPaperPlayAction:isValid()
    return true
end

function CheckPaperPlayAction:waitToStart()
    self.character:faceThisObject(self.worldItem)
    return self.character:shouldBeTurning()
end

function CheckPaperPlayAction:update()
    if self.paperUI and self.paperUI.quitting then
        self:forceStop()
    end
end

function CheckPaperPlayAction:start()
    self.oldPrimary = self.character:getPrimaryHandItem()
    self.oldSecondary = self.character:getSecondaryHandItem()
    self.character:playSound("OpenMagazine")

    self:setActionAnim("Read")
    self:setAnimVariable("ReadType", "newspaper")
    -- ouvre l’UI
    self.paperUI = ShowPaperUI(self.item)
    self:setOverrideHandModels(nil, self.item)
end

function CheckPaperPlayAction.transferIfNeeded(playerObj, item)
    if instanceof(item, "InventoryItem") then
        if luautils.haveToBeTransfered(playerObj, item) then
            ISTimedActionQueue.add(ISInventoryTransferAction:new(
                playerObj, 
                item, 
                item:getContainer(), 
                playerObj:getInventory()
            ))
        end
    elseif instanceof(item, "ArrayList") then
        local items = item
        for i=1,items:size() do
            local it = items:get(i-1)
            if luautils.haveToBeTransfered(playerObj, it) then
                ISTimedActionQueue.add(ISInventoryTransferAction:new(
                    playerObj, 
                    it, 
                    it:getContainer(), 
                    playerObj:getInventory()
                ))
            end
        end
    end
end

function CheckPaperPlayAction:stop()
    if self.paperUI then
        self.paperUI:close()
        self.paperUI = nil
    end

    self.character:setPrimaryHandItem(self.oldPrimary)
    self.character:setSecondaryHandItem(self.oldSecondary)

    self.character:playSound("CloseMagazine")
    ISBaseTimedAction.stop(self)
end


function CheckPaperPlayAction:perform()
    self.character:setPrimaryHandItem(self.oldPrimary)
    self.character:setSecondaryHandItem(self.oldSecondary)

    ISBaseTimedAction.perform(self)
end


function CheckPaperPlayAction:new(character, item, worldItem)
    local o = ISBaseTimedAction.new(self, character)
    o.item = item
    o.character = character
    o.worldItem = worldItem
    o.stopOnWalk = true
    o.stopOnRun  = true
    o.maxTime    = 1000000
    return o
end
