require "ISUI/ISCollapsableWindow"

CreditCardUI = ISCollapsableWindow:derive("CreditCardUI")

function CreditCardUI:new(x, y, width, height, item)

    local o = ISCollapsableWindow.new(self, x, y, width, height)
    o.title = ""
    o.resizable = false
    o.texturePath = "media/textures/card.png" -- chemin par défaut
    o.backgroundColor = {r=0, g=0, b=0, a=0} 
    o.borderColor = {r=0, g=0, b=0, a=0} 
    o.drawFrame = false

    local itemname = item:getName()
    o.firstname, o.lastname = string.match(itemname, ": (%w+)%s+(%w+)")

    --loading CreditCardData
    o.data = CreditCardData:new(item)

    -- loading signatureTexture
    if o.data.signatureTexture then
        o.signatureTexture = getTexture(o.data.signatureTexture)
    end

    return o
end

function CreditCardUI:close()
    self.quitting = true
    ISCollapsableWindow.close(self)
end


------------------DRAWING CUSTOM TEXT AS IMAGES-------------

function CreditCardUI:drawTextAsImages(text, x, y, scale)
    if not text then return end
    scale = scale or 1.0

    local xOffset = x
    text = tostring(text):lower()

    for i = 1, #text do
        local char = string.sub(text, i, i)
        if char == " " then
            xOffset = xOffset + 10 * scale
        else
            local texturePath = "media/textures/font/" .. char .. ".png"
            local tex = getTexture(texturePath)
            if tex then
                local w, h = tex:getWidth() * scale, tex:getHeight() * scale
                self:drawTextureScaled(tex, xOffset, y, w, h, 1.0)
                xOffset = xOffset + w + 2
            else
                print("[DEBUG] Нет текстуры для символа: " .. char)
                xOffset = xOffset + 8 * scale
            end
        end
    end
end



function CreditCardUI:render()
    ISCollapsableWindow.render(self)
    self:renderBackground()

    local xFirstName = 66
    local yFirstLine = 60
    local font = UIFont.Title

    self:drawTextAsImages(self.firstname, xFirstName, yFirstLine, 0, 0, 0, 1)
    self:drawTextAsImages(self.lastname, 595, yFirstLine, 0, 0, 0, 1)

    -- Coordonnées de départ pour les infos
    local xLabel = 16
    local yStart = 220
    local lineSpacing = 89

        -- Ligne 1 : Licence Number
        self:drawTextAsImages(self.data.cardNumber, xLabel, yStart, 0.6)

        -- Ligne 2 : Expire date + Licence type
        self:drawTextAsImages(self.data.expireDate, xLabel, yStart + lineSpacing, 0.6)

    -- Signature
    if self.signatureTexture then
    local x, y, width, height = 55, 510, 421, 122
    self:drawTextureScaled(self.signatureTexture, x, y, width, height, 1.0)
    end
end


function CreditCardUI:renderBackground()
    local tex = getTexture(self.texturePath)
    if tex then
        self:drawTexture(tex, 0, 0, 1.0)
    end
end


function ShowPaperUI(item, sex)

    local w, h = 1024, 660
    local ui = CreditCardUI:new(
        (getCore():getScreenWidth() - w) / 2,
        (getCore():getScreenHeight() - h) / 2,
        w, h, item, sex
    )
    ui:initialise()
    ui:addToUIManager()
    ui:setVisible(true)
    return ui
end
