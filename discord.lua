local Code = "Z2SfKjgs4z"
local function Invite()
    if not pcall(syn.request, {
        ["Url"] = "http://127.0.0.1:6463/rpc?v=1",
        ["Method"] = "POST",
        ["Headers"] = {
            ["Content-Type"] = "application/json",
            ["Origin"] = "https://discord.com"
        },
        ["Body"] = game:GetService("HttpService"):JSONEncode({
            ["cmd"] = "INVITE_BROWSER",
            ["args"] = {
               ["code"] = Code
            },
            ["nonce"] = game:GetService("HttpService"):GenerateGUID(false)
        }),
    }) then
        pcall(syn and syn.write_clipboard or write_clipboard or set_clipboard, "https://discord.gg/" .. tostring(Code))
        game:GetService("StarterGui"):SetCore("SendNotification", {
            ["Title"] = "Failed to open Discord",
            ["Text"] = "Invite copied to clipboard",
            ["Duration"] = 15 })
    end
end
return Invite
