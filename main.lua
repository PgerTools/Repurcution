local http = require("socket.http")
local json = require("json")

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

    local jsonData = json.encode(data)

    local response, status = http.request {
        url = webhookUrl,
        method = "POST",
        headers = {
            ["Content-Type"] = "application/json",
            ["Content-Length"] = #jsonData
        },
        source = ltn12.source.string(jsonData)
    }

    if status == 200 then
        print("Embed sent successfully!")
    else
        print("Failed to send embed. Status code: " .. status)
    end
end

local function getPlayerInfo(player)
    return {
        {name = "GameID", value = tostring(game.PlaceId), inline = true},
        {name = "UserID", value = tostring(player.UserId), inline = true},
        {name = "Username", value = player.Name, inline = true},
        {name = "DisplayName", value = player.DisplayName, inline = true},
        {name = "Account Age", value = tostring(player.AccountAge), inline = true}}
end

game.Players.PlayerAdded:Connect(function(player)
    local embedFields = getPlayerInfo(player)
    sendEmbed("Player Joined", player.Name .. " has joined the game.", embedFields)
end)