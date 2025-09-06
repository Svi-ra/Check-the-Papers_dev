require "ISUI/ISCollapsableWindow"

PaperUI = ISCollapsableWindow:derive("PaperUI")

function PaperUI:new(x, y, width, height)
    local o = ISCollapsableWindow.new(self, x, y, width, height)
    o.title = ""
    o.resizable = false
    o.texturePath = "media/textures/card.png" -- chemin par défaut
    o.backgroundColor = {r=0, g=0, b=0, a=0} 
    o.borderColor = {r=0, g=0, b=0, a=0} 
    o.drawFrame = false
    return o
end

function PaperUI:close()
    self.quitting = true
    ISCollapsableWindow.close(self)
end

function PaperUI:render()
    ISCollapsableWindow.render(self)
    self:renderBackground()
end

function PaperUI:renderBackground()
    local tex = getTexture(self.texturePath)
    if tex then
        self:drawTexture(tex, 0, 0, 1.0)
    end
end

function ShowPaperUI()
    local w, h = 1024, 700
    local ui = PaperUI:new(
        (getCore():getScreenWidth() - w) / 2,
        (getCore():getScreenHeight() - h) / 2,
        w, h
    )
    ui:initialise()
    ui:addToUIManager()
    ui:setVisible(true)
    return ui
end
