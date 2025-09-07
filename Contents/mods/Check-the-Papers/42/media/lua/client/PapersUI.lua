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

    o.data = IDCardData:new(item, sex)
    o.headTexture = getTexture(o.data.headTexture)

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
    local yFirstLine = 100
    local font = UIFont.Title

    self:drawText(string.upper(self.firstname), xFirstName, yFirstLine, 0, 0, 0, 1, font)
    self:drawText(string.upper(self.lastname), 595, yFirstLine, 0, 0, 0, 1, font)

    -- Coordonnées de départ pour les infos
    local xLabel = 16
    local yStart = 250
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
            xLabel + 400, yStart + (lineSpacing * 3), 0, 0, 0, 1, font)


    if self.headTexture then
        local x = 565
        local y = 215
        local width = 450
        local height = 450
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

    local w, h = 1024, 700
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
