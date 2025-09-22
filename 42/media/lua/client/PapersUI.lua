require "ISUI/ISCollapsableWindow"

PaperUI = ISCollapsableWindow:derive("PaperUI")

function PaperUI:new(x, y, width, height, item, sex)

    local o = ISCollapsableWindow.new(self, x, y, width, height)
    o.title = ""
    o.resizable = false
    o.texturePath = "media/textures/card.png" -- chemin par défaut
    o.backgroundColor = {r=0, g=0, b=0, a=0} 
    o.borderColor = {r=0, g=0, b=0, a=0} 
    o.drawFrame = false

    local itemname = item:getName()
    o.firstname, o.lastname = string.match(itemname, ": (%w+)%s+(%w+)")

    --loading IDCardData
    o.data = IDCardData:new(item, sex)

    --loading HeadTexture
    o.headTexture = getTexture(o.data.headTexture)

    -- loading signatureTexture
    if o.data.signatureTexture then
        o.signatureTexture = getTexture(o.data.signatureTexture)
    end

    return o
end

function PaperUI:close()
    self.quitting = true
    ISCollapsableWindow.close(self)
end

function PaperUI:render()
    ISCollapsableWindow.render(self)
    self:renderBackground()

    local xFirstName = 66
    local yFirstLine = 60
    local font = UIFont.Title

    self:drawText(string.upper(self.firstname), xFirstName, yFirstLine, 0, 0, 0, 1, font)
    self:drawText(string.upper(self.lastname), 595, yFirstLine, 0, 0, 0, 1, font)

     --County
     self:drawText(tostring(self.data.county),
         620, 120, 0, 0, 0, 1, font)

    -- Coordonnées de départ pour les infos
    local xLabel = 16
    local yStart = 220
    local lineSpacing = 89

        -- Ligne 1 : Licence Number
        self:drawText(tostring(self.data.licenseNumber),
            xLabel, yStart, 0, 0, 0, 1, font)

        -- Ligne 2 : Expire date + Licence type
        self:drawText(tostring(self.data.expireDate),
            xLabel, yStart + lineSpacing, 0, 0, 0, 1, font)
        self:drawText(tostring(self.data.licenseType),
            xLabel + 180, yStart + lineSpacing, 0, 0, 0, 1, font)

        -- Ligne 3 : Date of Birth + Social Security
        self:drawText(tostring(self.data.dateOfBirth),
            xLabel, yStart + (lineSpacing * 2), 0, 0, 0, 1, font)
        self:drawText(tostring(self.data.securityNumber),
            xLabel + 250, yStart + (lineSpacing * 2), 0, 0, 0, 1, font)

        -- Ligne 4 : Restrictions + Date Applied + Sex + Height
        self:drawText(tostring(self.data.restrictions),
            xLabel, yStart + (lineSpacing * 3), 0, 0, 0, 1, font)
        self:drawText(tostring(self.data.dateApplied),
            xLabel + 130, yStart + (lineSpacing * 3), 0, 0, 0, 1, font)
        self:drawText(tostring(self.data.sex),
            xLabel + 355, yStart + (lineSpacing * 3), 0, 0, 0, 1, font)
        self:drawText(tostring(self.data.height),
            xLabel + 430, yStart + (lineSpacing * 3), 0, 0, 0, 1, font)

    -- Signature
    if self.signatureTexture then
        local x = 55
        local y = 510
        local width = 421
        local height = 122
        self:drawTextureScaled(self.signatureTexture, x, y, width, height, 1.0)
    end

    if self.headTexture then
        local x = 562
        local y = 185
        local width = 460
        local height = 458
        self:drawTextureScaled(self.headTexture, x, y, width, height, 1.0)
    end
end

function PaperUI:renderBackground()
    local tex = getTexture(self.texturePath)
    if tex then
        self:drawTexture(tex, 0, 0, 1.0)
    end
end

function ShowPaperUI(item, sex)

    local w, h = 1024, 660
    local ui = PaperUI:new(
        (getCore():getScreenWidth() - w) / 2,
        (getCore():getScreenHeight() - h) / 2,
        w, h, item, sex
    )
    ui:initialise()
    ui:addToUIManager()
    ui:setVisible(true)
    return ui
end
