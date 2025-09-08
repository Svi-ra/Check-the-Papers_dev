-- ==================================================
-- Classe IDCardData : gère les infos de la carte
-- ==================================================
IDCardData = {}
IDCardData.__index = IDCardData

-- Constructeur
function IDCardData:new(item, sex)
    local o = {}
    setmetatable(o, self)
    o.item = item

    -- clé unique pour cette carte (itemName + itemID)
    local key = item:getID() or tostring(item:getName())

    -- vérifier si modData contient déjà les infos
    local data = item:getModData().IDCardData or {}
    if data[key] then
        -- charger les données existantes
        o.firstname       = data[key].firstname
        o.lastname        = data[key].lastname
        o.licenseNumber   = data[key].licenseNumber
        o.county          = data[key].county
        o.dateApplied     = data[key].dateApplied
        o.expireDate      = data[key].expireDate
        o.licenseType     = data[key].licenseType
        o.dateOfBirth     = data[key].dateOfBirth
        o.securityNumber  = data[key].securityNumber
        o.restrictions    = data[key].restrictions
        o.sex             = data[key].sex or sex
        o.height          = data[key].height
        o.headTexture     = data[key].headTexture
    else
        -- générer de nouvelles données
        o.firstname       = IDCardData:getNames(item)
        o.lastname        = select(2, IDCardData:getNames(item))
        o.licenseNumber   = IDCardData:getLicenseNumber()
        o.county          = IDCardData:getCounty()
        o.dateApplied     = IDCardData:getDateApplied()
        o.expireDate      = IDCardData:getExpireDate()
        o.licenseType     = IDCardData:getLicenseType()
        o.dateOfBirth     = IDCardData:getDateOfBirth()
        o.securityNumber  = IDCardData:getSecurityNumber()
        o.restrictions    = IDCardData:getRestrictions()
        o.sex             = sex
        o.height          = IDCardData:getHeight()
        o.headTexture = IDCardData:getHeadTexture(sex)

        -- enregistrer dans modData
        if not item:getModData().IDCardData then
            item:getModData().IDCardData = {}
        end
        item:getModData().IDCardData[key] = {
            firstname       = o.firstname,
            lastname        = o.lastname,
            licenseNumber   = o.licenseNumber,
            county          = o.county,
            dateApplied     = o.dateApplied,
            expireDate      = o.expireDate,
            licenseType     = o.licenseType,
            dateOfBirth     = o.dateOfBirth,
            securityNumber  = o.securityNumber,
            restrictions    = o.restrictions,
            sex             = o.sex,
            height          = o.height,
            headTexture     = o.headTexture,
        }
    end

    return o
end


function IDCardData:getHeadTexture(sex)
    local path = "media/textures/photos/"
    local fileName = ""

    if sex == "F" then
        -- Female-1.png à Female-3.png
        local index = ZombRand(1, 6) -- 1 à 3 inclus
        fileName = "Female-" .. index .. ".png"
        path = path .. "female/"
    else
        -- Male-1.png à Male-4.png
        local index = ZombRand(1, 5) -- 1 à 4 inclus
        fileName = "Male-" .. index .. ".png"
        path = path .. "male/"
    end

    return path .. fileName
end

function IDCardData:getNames(item)
    local itemname = item:getName()
    local firstname, lastname = string.match(itemname, ": (%w+)%s+(%w+)")
    return firstname or "John", lastname or "Doe"
end

function IDCardData:getLicenseNumber()
    local prefixes = {"KY", "KX"}
    local prefix = prefixes[ZombRand(#prefixes) + 1]

    -- format : XXX-XXXX (3 chiffres - 4 chiffres)
    local part1 = string.format("%03d", ZombRand(0, 999))
    local part2 = string.format("%04d", ZombRand(0, 9999))

    return prefix .. "-" .. part1 .. "-" .. part2
end
--___________________________________KOUNTY_______________________________________

local function randomCounty()
    -- 5 closest counties to Knox County, KY
    local counties = {"CLAY", "BELL", "WHITLEY", "LAUREL", "ROCKCASTLE", "KNOX","KNOX","KNOX","KNOX"}
    local county = counties[ZombRand(#counties) + 1]
    return county
end

function IDCardData:getCounty()
    local county = randomCounty()
    --self._County = county
    print("County is ".. county)
    return county
end

function IDCardData:getDateOfBirth()
    local year = ZombRand(1944, 1977) -- 18 à 70 ans en 1994
    local month = ZombRand(1, 13)     -- 1 à 12
    local day = ZombRand(1, 29)       -- 1 à 28 pour simplifier les mois

    return string.format("%02d-%02d-%02d", day, month, year)
end

local function randomAppliedDate()
    local months = {"JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"}
    local month = months[ZombRand(#months) + 1]
    local year = ZombRand(84, 94) -- 1990 à 1994 inclus
    return month, year
end

function IDCardData:getDateApplied()
    local month, year = randomAppliedDate()
    self._appliedMonth = month
    self._appliedYear = year
    return month .. "-" .. string.format("%02d", year % 100)
end

function IDCardData:getExpireDate()
    local month = self._appliedMonth or "JAN"
    local year = (self._appliedYear or 93) + 10 -- +10 ans
    return month .. "-" .. string.format("%02d", year % 100)
end

local function randomLicenseType()
    local licensetypes = {"OPERATORS","CHAUFFEUR","MOTORCYCLE"}
    local licensetype = licensetypes[ZombRand(#licensetypes) + 1]
    return licensetype
end

function IDCardData:getLicenseType()
    local licensetype = randomLicenseType()
    --self._LicenseType = licensetype
    return licensetype
end

function IDCardData:getSecurityNumber()
    local part1 = string.format("%03d", ZombRand(0, 1000))  -- 000-999
    local part2 = string.format("%02d", ZombRand(0, 100))   -- 00-99
    local part3 = string.format("%04d", ZombRand(0, 10000)) -- 0000-9999

    return part1 .. "-" .. part2 .. "-" .. part3
end

local function randomRestrictions()
    local restrictions = {"NONE","C/L","H/A"}
    local restriction = restrictions[ZombRand(#restrictions) + 1]
    return restriction
end

function IDCardData:getRestrictions()
    local restriction = randomRestrictions()
    --self._RestrictionType = restriction
    return restriction
end

function IDCardData:getHeight()
    local minInches = 60
    local maxInches = 77

    -- Tirage aléatoire
    local randomInches = ZombRand(minInches, maxInches + 1)

    -- Conversion en pieds/pouces
    local feet = math.floor(randomInches / 12)
    local inches = randomInches % 12

    -- Retourne une string du type "5'11"
    return string.format("%d-%02d", feet, inches)
end

-- ==================================================
-- Fonction générale : retourne toutes les infos
-- ==================================================
function IDCardData:getAll()
    return {
        firstname     = self.firstname,
        lastname      = self.lastname,
        licenseNumber = self.licenseNumber,
        county        = self.county,
        expireDate    = self.expireDate,
        licenseType   = self.licenseType,
        dateOfBirth   = self.dateOfBirth,
        securityNumber = self.securityNumber,
        restrictions  = self.restrictions,
        dateApplied   = self.dateApplied,
        sex           = self.sex,
        height        = self.height,
    }
end
