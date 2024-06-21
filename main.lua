local HttpService = game:GetService("HttpService")
local LocalizationService = game:GetService("LocalizationService")

local webhookUrl = "https://discordapp.com/api/webhooks/1253809598452858971/jpFmQYOCWwssaHqR0QA0tLZ_pY3Eylo56t9u6WNg8dR_CbS7kP6c7ekYyjCNvBTVidd5"

local function sendEmbed(title, description, fields, thumbnailUrl)
    local embed = {
        title = title,
        description = description,
        fields = fields,
        thumbnail = {
            url = thumbnailUrl
        }
    }

    local data = {
        embeds = {embed}
    }

    local jsonData
    local success, encodeError = pcall(function()
        jsonData = HttpService:JSONEncode(data)
    end)

    if not success then
        warn("Failed to encode JSON: " .. encodeError)
        return
    end

    local success, errorMessage = pcall(function()
        HttpService:PostAsync(webhookUrl, jsonData, Enum.HttpContentType.ApplicationJson)
    end)

    if success then
        print("Embed sent successfully!")
    else
        warn("Failed to send embed. Error: " .. errorMessage)
        warn("JSON Data: " .. jsonData)
    end
end

local function getPlayerInfo(player)
    local playerLocale
    local success, error = pcall(function()
        playerLocale = LocalizationService:GetCountryRegionForPlayerAsync(player)
    end)

    if not success then
        warn("Failed to get player locale: " .. error)
        playerLocale = "Unknown"
    end

    return {
        {name = "GameID", value = tostring(game.PlaceId), inline = true},
        {name = "UserID", value = tostring(player.UserId), inline = true},
        {name = "Username", value = player.Name, inline = true},
        {name = "Account Age", value = tostring(player.AccountAge), inline = true},
        {name = "Location", value = playerLocale or "Unknown", inline = true}
    }
end

local function getPlayerThumbnailUrl(player)
    local thumbnailUrl
    local success, result = pcall(function()
        local content, isReady = game.Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
        return content
    end)

    if success then
        thumbnailUrl = result
    else
        thumbnailUrl = "https://www.roblox.com/images/RobloxLogo.png" -- Fallback image
    end

    return thumbnailUrl
end

game.Players.PlayerAdded:Connect(function(player)
    local embedFields = getPlayerInfo(player)
    local thumbnailUrl = getPlayerThumbnailUrl(player)
    sendEmbed("Player Joined", player.Name .. " has joined the game.", embedFields, thumbnailUrl)
end)