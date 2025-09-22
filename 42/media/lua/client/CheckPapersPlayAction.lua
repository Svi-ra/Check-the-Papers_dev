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

    local now = getTimestampMs()
    if not self.lastTick then self.lastTick = now end

    if now - self.lastTick >= 5000 then
        self.lastTick = now

        local bodyDamage = self.character:getBodyDamage()
        local stats = self.character:getStats()

        bodyDamage:setBoredomLevel(math.max(0, bodyDamage:getBoredomLevel() - 0.2))
        bodyDamage:setUnhappynessLevel(math.max(0, bodyDamage:getUnhappynessLevel() - 0.5))
        stats:setStress(math.max(0, stats:getStress() - 0.02))
    end
end

function CheckPaperPlayAction:start()
    self.oldPrimary = self.character:getPrimaryHandItem()
    self.oldSecondary = self.character:getSecondaryHandItem()
    self.character:playSound("OpenWallet")

    self:setActionAnim("Read")
    self:setAnimVariable("ReadType", "newspaper")
    -- ouvre l’UI

    
    local sex
    
    if self.item:getFullType() == "Base.IDcard_Female" then
        sex = "F"
    elseif self.item:getFullType() == "Base.IDcard_Male" then
        sex = "M"
    elseif self.item:getFullType() == "Base.IDcard" then
        sex = getPlayer():getDescriptor():isFemale() and "F" or "M"
    end

    self.paperUI = ShowPaperUI(self.item, sex)
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

    self.character:playSound("CloseWallet")
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