-- ==================================================
-- Class CreditCardData
-- ==================================================
CreditCardData = {}
CreditCardData.__index = CreditCardData

-- Constructor
function CreditCardData:new(item)
    local o = {}
    setmetatable(o, self)
    o.item = item

    -- clé unique pour cette carte (itemName + itemID)
    local key = item:getID() or tostring(item:getName())

    -- vérifier si modData contient déjà les infos
    local data = item:getModData().CreditCardData or {}
    if data[key] then
        -- charger les données existantes
        o.firstname         = data[key].firstname
        o.lastname          = data[key].lastname
        o.cardNumber     = data[key].cardNumber
        o.expireDate        = data[key].expireDate
        o.securityNumber    = data[key].securityNumber
        o.signatureTexture  = data[key].signatureTexture
    else
        -- générer de nouvelles données
        o.firstname         = CreditCardData:getNames(item)
        o.lastname          = select(2, CreditCardData:getNames(item))
        o.cardNumber     = CreditCardData:getcardNumber()
        o.expireDate        = CreditCardData:getExpireDate()
        o.signatureTexture  = CreditCardData:getSignatureTexture(o.lastname)

        -- enregistrer dans modData
        if not item:getModData().CreditCardData then
            item:getModData().CreditCardData = {}
        end
        item:getModData().CreditCardData[key] = {
            firstname        = o.firstname,
            lastname         = o.lastname,
            cardNumber    = o.cardNumber,
            expireDate       = o.expireDate,
            signatureTexture = o.signatureTexture,
        }
    end

    return o
end


function CreditCardData:getNames(item)
    local itemname = item:getName()
    local firstname, lastname = string.match(itemname, ": (%w+)%s+(%w+)")
    return firstname or "John", lastname or "Doe"
end

function CreditCardData:getcardNumber()
    local prefixes = {"KY", "KX"}
    local prefix = prefixes[ZombRand(#prefixes) + 1]

    -- format : XXX-XXXX (3 chiffres - 4 chiffres)
    local part1 = string.format("%03d", ZombRand(0, 999))
    local part2 = string.format("%04d", ZombRand(0, 9999))

    return prefix .. "-" .. part1 .. "-" .. part2
end

--___________________________________SIGNATURE_______________________________________

function CreditCardData:getSignatureTexture(lastname)
    local basePath = "media/textures/signatures/"
    local lname = string.lower(lastname)

    -- Take the first surname letter
    local firstLetter = string.sub(lname, 1, 1)

    -- Building the path: A/Anderson.png, B/Brown.png etc.
    local fileName = lname .. ".png"
    local fullPath = basePath .. firstLetter .. "/" .. fileName

    -- Check if texture exists)
    if getTexture(fullPath) then
        return fullPath
    else
        return basePath .. "default.png"
    end
end
-----------------------RANDOM DATA-------------------------

local function randomAppliedDate()
    local months = {"JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"}
    local month = months[ZombRand(#months) + 1]
    local year = ZombRand(84, 94) -- 1990 à 1994 inclus
    return month, year
end

function CreditCardData:getDateApplied()
    local month, year = randomAppliedDate()
    self._appliedMonth = month
    self._appliedYear = year
    return month .. "-" .. string.format("%02d", year % 100)
end

function CreditCardData:getExpireDate()
    local month = self._appliedMonth or "JAN"
    local year = (self._appliedYear or 93) + 10 -- +10 ans
    return month .. "-" .. string.format("%02d", year % 100)
end

-- ==================================================
-- Fonction générale : retourne toutes les infos
-- ==================================================
function CreditCardData:getAll()
    return {
        firstname     = self.firstname,
        lastname      = self.lastname,
        cardNumber = self.cardNumber,
        expireDate    = self.expireDate,
    }
end
