while game.GameId == 0 do task.wait() end
if game.GameId ~= 1954906532 then return end
local MAX_FOV = 200
local function RejoinSameInstance()
    game:GetService("TeleportService")
        :TeleportToPlaceInstance(game.PlaceId, game.JobId, game:GetService("Players").LocalPlayer)
end
-----------------------
local OldSpawn
local nilfunc = function()
    task.wait(10e3 ^ 2)
end
local function acbp()
    for _, func in pairs(getgc(true)) do
        if type(func) == "function"
        and islclosure(func)
        and not is_synapse_function(func)
        then
            local finfo = debug.getinfo(func)
            if string.match(finfo.short_src, "AntiCheat$") then
                for _, const in pairs(debug.getconstants(func)) do
                    if const == "error in error handling" then
                        hookfunction(func, function() end)
                        break
                    end
                end
            end
        end
    end
end
do
    local old_xpcall
    local function xpcall_hook(...)
        if not checkcaller() and debug.getinfo(4).short_src:match("AntiCheat") then
            return nil
        end
        return old_xpcall(...)
    end
    old_xpcall = hookfunction(getrenv().xpcall, function(...)
        return xpcall_hook(...)
    end)
end
--while task.wait() do end
acbp()
----------------------------------------------------------------
--local success, msg = xpcall(function()
    if __AHLOADED then return end
    if not syn then (messagebox or print)("Your exploit is not supported", "Exploit not supported", 0) end

    local rainbow_color = Color3.new(1, 1, 1)

    local genv = getgenv()

    local o = {} -- options
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kitakuxo/Lab/main/logging.lua"))()
    clear()
    title("Cheat - Loading")
    printwelcome()
    info("Update Undetected")
    ok("+Add More Gun Function")
    info("Loading Cheat...")

    local function WaitForService(serv)
        repeat task.wait() until game:GetService(serv)
        return game:GetService(serv)
    end
    local function WaitForProp(self, prop)
        repeat task.wait() until self[prop] ~= nil
        return self[prop]
    end


    info("Getting ui library")
    local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kitakuxo/Lab/main/ui.lua", true))()
    repeat task.wait() until WaitForProp(WaitForService("Players"), "LocalPlayer")
    info("Getting replicatedstorage")
    local replicatedstorage = WaitForService("ReplicatedStorage")
    info("Getting httpservice")
    local httpservice = WaitForService("HttpService")
    info("Getting players")
    local players = WaitForService("Players")
    info("Getting runservice")
    local runservice = WaitForService("RunService")
    info("Getting lighting")
    local lighting = WaitForService("Lighting")
    info("Getting localplayer")
    local localplayer = WaitForProp(players, "LocalPlayer")

    repeat task.wait() until WaitForProp(players, "MaxPlayers") ~= 0
    local current_camera = workspace.CurrentCamera

    hookfunction(localplayer.Kick, function() end)

    info("Getting characters")
    local function IsTeamMate(plr)
        if plr.Neutral then
            return false
        else
            return plr.Team == localplayer.Team
        end
    end

    title("Cheat - In a game")
    info("You are in a game :3")

    local function WaitForModule(name)
        while true do
            for _, m in pairs(getloadedmodules()) do
                if typeof(m) == "Instance" and m.Name == name then
                    return m
                end
            end
            task.wait()
        end
    end

    local function ShallowCopy(orig)
        local copy
        if type(orig) == "table" then
            copy = {}
            for orig_key, orig_value in pairs(orig) do
                copy[orig_key] = orig_value
            end
        else
            copy = orig
        end
        return copy
    end

    local function XZCompare(v3_1, v3_2)
        return Vector3.new(v3_1.X, 0, v3_1.Z) - Vector3.new(v3_2.X, 0, v3_2.Z)
    end

    local function get_raycast_ignores()
        local ignores = { workspace.CurrentCamera }
        if localplayer.Character then
            table.insert(ignores, localplayer.Character)
        end
        local gameplay = workspace:FindFirstChild("Gameplay")
        if gameplay then
            local map = gameplay:FindFirstChild("Map")
            if workspace.Gameplay:FindFirstChild("Map") then
                table.insert(ignores, map:FindFirstChild("Spawns"))
                table.insert(ignores, map:FindFirstChild("COLLECTED_FOILAGE"))
                local geometry = map:FindFirstChild("Geometry")
                if geometry then
                    table.insert(ignores, geometry:FindFirstChild("Lighting"))
                end
                table.insert(ignores, map:FindFirstChild("Equipment"))
                table.insert(ignores, map:FindFirstChild("DeadMarkers"))
            end
            table.insert(ignores, gameplay:FindFirstChild("Ragdoll"))
            table.insert(ignores, gameplay:FindFirstChild("WeaponRigs"))
        end
        return ignores
    end
    local ray_params = RaycastParams.new()
    ray_params.IgnoreWater = true
    ray_params.FilterType = Enum.RaycastFilterType.Blacklist
    local function vis_check(target, origin)
        origin = origin or workspace.CurrentCamera.CFrame.Position
        ray_params.FilterDescendantsInstances = get_raycast_ignores()
        local direction = CFrame.new(origin, target)
        local ray = workspace:Raycast(direction.Position, direction.LookVector * 5e3, ray_params)
        return ray and ray.Instance and ray.Position and (target - ray.Position).Magnitude < 8, ray.Position
    end
    local function corner_cast(corner_dist_z, corner_dist_y, target, ignore)
        ray_params.FilterDescendantsInstances = get_raycast_ignores()
        local origin = workspace.CurrentCamera.CFrame
        local adjusted = origin + Vector3.new(0, corner_dist_y, corner_dist_z)
        local direction = CFrame.lookAt(adjusted.Position, target)
        local ray = workspace:Raycast(adjusted.Position, direction.LookVector * 1e3)
        return ray and ray.Instance, ray and adjusted
    end
    local corner_offset_amt = 8
    local function get_corner_offset(target, ignore)
        local base, basec = corner_cast(0, 0, target.Position, ignore)
        if base and base:IsDescendantOf(target.Parent) then
            return basec, base
        end
        local c1, ac1 = corner_cast(-corner_offset_amt, 0, target.Position, ignore)
        if c1 and c1:IsDescendantOf(target.Parent) then
            return ac1, c1
        end
        local c2, ac2 = corner_cast(corner_offset_amt, 0, target.Position, ignore)
        if c2 and c2:IsDescendantOf(target.Parent) then
            return ac2, c2
        end
        local c3, ac3 = corner_cast(0, corner_offset_amt, target.Position, ignore)
        if c3 and c3:IsDescendantOf(target.Parent) then
            return ac3, c3
        end
        local c4, ac4 = corner_cast(0, -corner_offset_amt, target.Position, ignore)
        if c4 and c4:IsDescendantOf(target.Parent) then
            return ac4, c4
        end
        return nil
    end

    local bones = {
        "Head",
        "MidSpine",
        "BottomSpine",
        --"LeftHand",
        "LeftArm",
        --"LeftUpperArm",
        --"RightHand",
        "RightArm",
        --"RightUpperArm",
        --"LeftFoot",
        "LeftLeg",
        --"LeftUpperLeg",
        --"RightFoot",
        "RightLeg",
        --"RightUpperLeg"
    }
    local function GetBone(char, bias)
        for _, bone in ipairs(bones) do
            local foundBone = char:FindFirstChild(bone, true)
            if foundBone then
                local success, is_vis = pcall(vis_check, foundBone.WorldPosition)
                if success and is_vis then
                    return foundBone
                end
            end
        end
        return char:FindFirstChild("Head", true)
    end

    local function get_practical_weapon(fprig, equippedOnly)
        for _, weapon in pairs(fprig.weapons) do
            if equippedOnly and weapon.equipped then
                return weapon
            end
            local data = type(weapon) == "table" and rawget(weapon, "weaponData")
            if data and data.magazineAmmunition >= 1 then
                return weapon
            end
        end
    end

    --// Proxy functions/shims
    local framework, shared_modules, wait_for_framework_module, wait_for_shared_module, local_camera do
        info("Loading shims...")
        local current_identity = syn.get_thread_identity()
        syn.set_thread_identity(2) -- localscript
        task.wait()
        -- shim thread
        local function wait_for_gc_function(func_name)
            while true do
                for _, func in pairs(getgc(true)) do
                    if type(func) == "function"
                    and islclosure(func)
                    and not is_synapse_function(func)
                    and debug.getinfo(func).name == func_name
                    then
                        return func
                    end
                end
                task.wait()
            end
        end
        info("Getting framework")
        local function get_framework()
            for _, func in pairs(getgc(true)) do
                if type(func) == "function"
                and islclosure(func)
                and not is_synapse_function(func)
                then
                    for _, up in pairs(debug.getupvalues(func)) do
                        if type(up) == "table" then
                            if rawget(up, "LocalBullets")
                            and rawget(up, "LocalCamera")
                            and rawget(up, "LocalUserSettings")
                            then
                                return up
                            end
                        end
                    end
                end
            end
            task.wait()
            return get_framework()
        end
        framework = get_framework()
        genv.__framework = framework
        function wait_for_framework_module(name)
            while true do
                local mod = rawget(framework, name)
                if mod then
                    return mod
                end
                task.wait()
            end
        end
        function wait_for_shared_module(name)
            while true do
                local mod = rawget(shared_modules, name)
                if mod then
                    return mod
                end
                task.wait()
            end
        end
        ok("Got framework")
        local fprig = wait_for_framework_module("FPRig")
        repeat
            shared_modules = debug.getupvalue(fprig.MeleeDamage, 3)
            task.wait()
        until shared_modules
        genv.__shared = shared_modules
        info("Hooking melee")
        do
            local _ray_param = RaycastParams.new()
            _ray_param.FilterType = Enum.RaycastFilterType.Blacklist
            local oldMelee
            local function MeleeHook(self, ...)
                if o.do_longmelee then
                    local camcf = current_camera.CFrame
                    _ray_param.FilterDescendantsInstances = { workspace.CurrentCamera }
                    local hit_ray = workspace:Raycast(camcf.Position, camcf.LookVector * 15e3, _ray_param)
                    if hit_ray and hit_ray.Position then
                        local origincf = CFrame.lookAt(hit_ray.Position, camcf.LookVector) * CFrame.new(0, 0, -1.6)
                        self = {
                            crouch = false,
                            prone = false,
                            slide = false,
                            root = {
                                Position = origincf.Position,
                                CFrame = origincf
                            }
                        }
                    end
                    if typeof(target) == "Instance" and target:IsA("Player") and shared_modules.Damage then
                        task.defer(shared_modules.Damage.ThrowableHit, {
                            playerName = target.Name,
                            limbName = "Head",
                            weaponName = "KNIFE",
                            multiplier = 1,
                            crouch = false,
                            prone = false,
                            slide = false
                        })
                    end
                end
                return oldMelee(self, ...)
            end
            oldMelee = hookfunction(fprig.MeleeDamage, function(...)
                return MeleeHook(...)
            end)
        end
        ok("Hooked")
        info("Hooking bullet")
        do
            local bullets = wait_for_framework_module("LocalBullets")
            local oldNewBullet
            local function NewBulletHook(self, bullet, ...)
                --[[
                    ["direction"] = <Vector3>0.9817682504653931, -0.08441184461116791, 0.17031069099903107
                    ["accuracy"] = <number>0.2
                    ["slide"] = <boolean>false
                    ["equipIndex"] = <number>1
                    ["prone"] = <boolean>false
                    ["dropAcceleration"] = <number>8
                    ["position"] = <Vector3>106.44196319580078, 16.844804763793945, 79.00308227539062
                    ["speed"] = <number>2100
                    ["crouch"] = <boolean>false
                    ["ads"] = <boolean>true
                    ["consecutiveSpreadMultiplier"] = <number>1
                ]]
                target = silentTarget or target
                if o.do_silentaim then
                    if target and target.Character then
                        local bone = GetBone(target.Character)
                        if bone then
                            local origincf = CFrame.lookAt(current_camera.CFrame.Position, bone.WorldPosition)
                            bullet.direction = origincf.LookVector
                            bullet.accuracy = 0
                            bullet.ads = true
                            bullet.dropAcceleration = 0
                            bullet.speed = 999999
                        end
                        if framework.LocalFPRig then
                            task.spawn(shared_modules.Damage.ThrowableHit, {
                                playerName = target.Name,
                                limbName = bone.Name,
                                weaponName = get_practical_weapon(framework.LocalFPRig, true).weaponID,
                                multiplier = 1,
                                crouch = false,
                                prone = false,
                                slide = false
                            })
                        end
                    end
                end
                silentTarget = nil
                if o.bullet_multiplier > 1 then
                    for _ = 1, o.bullet_multiplier do
                        coroutine.wrap(oldNewBullet)(self, bullet, ...)
                    end
                end
                return oldNewBullet(self, bullet, ...)
            end
            oldNewBullet = hookfunction(getmetatable(bullets).Instantiate, function(...)
                return NewBulletHook(...)
            end)
        end
        ok("Hooked")
        info("Hooking camera")
        local_camera = wait_for_framework_module("LocalCamera")
        ok("Hooked")
        info("Hooking chat")
        do
            local function getRainbowText(text)
                local str = ""
                local i_max = string.len(text)
                for i = 1, i_max do
                    local color = Color3.fromHSV(i / i_max, 1, 1)
                    str = str
                        .. "<font color=\"" .. string.format("#%02X%02X%02X",
                            color.R * 0xFF, color.G * 0xFF, color.B * 0xFF
                        ) .. "\">" .. string.sub(text, i, i) .. "</font>"
                end
                return str
            end
            local default_colors = {
                White = "#c3c3c3",
                ["Br. yellowish orange"] = "#e29b40",
                ["Steel blue"] = "#5f94d4",
                ["Bright green"] = "#4b974b",
                ["Bright violet"] = "#b353cf",
                ["Bright yellow"] = "#f5cd30",
                ["Carnation pink"] = "#ff98dc"
            }
            local server_chat = wait_for_shared_module("ServerChat")
            local oldReceiveMessage = server_chat.ReceiveMessage
            server_chat.ReceiveMessage = function(msg, ...)
                if not msg.internal then
                    local msg_txt = o.do_rainbowchat and getRainbowText(msg.text) or msg.text
                    msg.prefix = "<font color=\"" .. default_colors[tostring(localplayer.TeamColor or "White")] .. "\"><b>"
                                .. (o.spoofed_name ~= "" and tostring(o.spoofed_name) or localplayer.Name)
                                .. "</b></font>: " .. msg_txt .. "\0"
                    msg.rawPrefix = ""
                    msg.text = ""
                end
                return oldReceiveMessage(msg, ...)
            end
        end
        ok("Hooked")
        -- zero pullout delay !
        do
            local oldCanFire
            local weapon
            while true do
                for _, tbl in pairs(getgc(true)) do
                    if type(tbl) == "table" then
                        oldCanFire = rawget(tbl, "isWeaponReadyForFire")
                        weapon = tbl
                        if type(oldCanFire) == "function" and type(weapon) == "table" then
                            break
                        end
                    end
                end
                if type(oldCanFire) == "function" and type(weapon) == "table" then
                    break
                end
                task.wait()
            end
            rawset(weapon, "isWeaponReadyForFire", function(...)
                return o.do_zeropullout or oldCanFire(...)
            end)
        end
        syn.set_thread_identity(current_identity) -- core script
        task.wait()
    end

    o.do_outlines = false
    o.esp_3dbox = false
    o.esp_bomb = false
    o.esp_bombcolor = Color3.new(1, 0, 1)
    o.esp_highlighttarget = false
    o.esp_highlightcolor = Color3.new(1, 1, 0)
    o.esp_teamcolor = Color3.new(0, 1, 0)
    o.esp_enemycolor = Color3.new(1, 0, 0)
    o.do_thirdperson = false
    o.do_noarms = false
    o.do_rainbowgun = false
    o.do_glow = false
    o.glow_teamcolor = Color3.new(0, 1, 0)
    o.glow_enemycolor = Color3.new(1, 0, 0)

    o.do_teamcheck = false
    o.do_silentaim = false
    o.silentfov = 70
    o.fovcolor = Color3.new(1, 1, 1)
    o.usefov = false
    o.visibleonly = false
    o.do_cornershoot = false
    o.do_autoshoot = false
    o.do_killall = false
    o.do_autoknife = false
    o.autoshoot_mode = "Regular"
    o.autoshoot_delay = 250
    o.do_autoreload = false

    o.do_antiaim = false
    o.antiaim_pitch = "Default"
    o.antiaim_yaw = "Default"
    o.antiaim_target = "View Angle"

    o.do_autofarmkills = false
    o.do_chatspam = false
    o.chatspam_msg = "Hi"
    o.speed_modifier = 1 -- max = 6x / set MovementSpeedMultiplier of currentWeapon
    --o.jumppower = 30
    o.do_longmelee = false
    o.do_rainbowchat = false

    o.viewmodel_offset = 0
    o.viewmodel_fov = 0
    o.fov = 0

    o.bullet_caliber = "Default"
    o.do_infiniteammo = false -- set Bullets, MaxBullets, ReserveAmmo = math.huge
    o.fire_rate = 0 -- set FireRate
    o.fire_mode = "Default" -- set FireType (Default, Automatic, Burst, Single)
    o.bullet_multiplier = 1 -- set Pellets = X
    o.do_nospread = false
    o.do_norecoil = false -- set RecoilResetTime to 0 / set Kickback = {} / set Recoil - {}
    o.do_rainbowsky = false
    o.do_zeropullout = false
    o.spoofed_name = ""

    o.skin_overrides = {}

    local defaults = o

    info("Getting config")

    local fn = "settings.rf.json"
    function saveOptions()
        local str = httpservice:JSONEncode(o)
        local suc, err = pcall(writefile, fn, str)
        if not suc then
            messagebox(tostring(err), "An error ocurred", 0)
        end
    end
    do -- load settings
        local suc, err = pcall(function()
            local _o = httpservice:JSONDecode(readfile(fn))
            o = _o
            for key, value in pairs(defaults) do
                if o[key] == nil then
                    o[key] = value
                end
            end
        end)
        if not suc then
            --messagebox(tostring(err), "Failed to load config", 0)
        end
    end

    local check_kill_cooldown do
        local last_kill = tick()
        function check_kill_cooldown()
            
        end
    end

    local function force_shoot(plr)
        local fprig = framework.LocalFPRig
        if type(fprig) ~= "table" then
            return
        end
        local weapon = get_practical_weapon(fprig, o.autoshoot_mode ~= "Forced")
        if type(weapon) ~= "table" then
            return
        end
        silentTarget = plr
        if o.autoshoot_mode == "Forced" then
            weapon:Fire()
        elseif o.autoshoot_mode == "Regular" then
            weapon:PullTrigger()
        elseif o.autoshoot_mode == "Ghost" and shared_modules.Damage then
            pcall(weapon.ReleaseShell, weapon)
            pcall(weapon.MuzzleFlash, weapon)
            plr = plr or target
            if typeof(plr) ~= "Instance" or not plr:IsA("Player") then
                return
            end
            local char = plr.Character
            if typeof(char) ~= "Instance" or not char:IsA("Model") then
                return
            end
            local bone = GetBone(char)
            if not bone then
                return
            end
            for _ = 1, o.bullet_multiplier do
                pcall(shared_modules.Damage.ThrowableHit, {
                    playerName = plr.Name,
                    limbName = bone.Name,
                    weaponName = weapon.weaponID,
                    multiplier = 1,
                    crouch = false,
                    prone = false,
                    slide = false
                })
            end
        end
    end

    -- silent target
    do
        local circle = Drawing.new('Circle') do
            circle.Visible = o.usefov
            circle.Color = o.fovcolor
            circle.Thickness = 1
            circle.Transparency = 1
        end

        local lastAutoShoot, lastAutoKnife = tick(), tick()
        task.spawn(function()
            while runservice.Heartbeat:Wait() do
                local vps = workspace.CurrentCamera.ViewportSize
                local origin = Vector2.new(vps.X / 2, vps.Y / 2)

                circle.Position = origin
                circle.Color = o.fovcolor
                circle.Radius = o.silentfov
                circle.Visible = o.usefov and localplayer.Character ~= nil

                local targets = {}
                local cCharacter = localplayer.Character

                if (not cCharacter) then
                    continue
                end

                if o.do_autofarmkills then
                    pcall(shared_modules.Damage.ThrowableHit, {
                        playerName = localplayer.Name,
                        limbName = "Head",
                        weaponName = nil,
                        multiplier = 1,
                        crouch = false,
                        prone = false,
                        slide = false
                    })
                    pcall(shared_modules.ServerPlayer.PromptDeploy)
                    continue
                end

                local camcf = workspace.CurrentCamera.CFrame

                for _, plr in pairs(players:GetPlayers()) do
                    if plr == localplayer then
                        continue
                    end
                    local character = plr and plr.Character
                    if not character then
                        continue
                    end


                    local humanoid = (character and character:FindFirstChildWhichIsA('Humanoid', true))
                    local hrp = (character and character.primaryPart or character:FindFirstChild("HumanoidRootPart"))

                    local closest_bone = { dist = math.huge, inst = nil }
                    for _, part in pairs(character:GetDescendants()) do
                        if part:IsA("Bone") then
                            local dist = (workspace.CurrentCamera.CFrame.Position - part.WorldPosition).Magnitude
                            if dist < closest_bone.dist then
                                closest_bone.inst = part
                                closest_bone.dist = dist
                            end
                        end
                    end

                    if not hrp then
                        continue
                    end

                    if (not humanoid) or (humanoid.Health <= 0) then
                        continue
                    end

                    if o.do_teamcheck and IsTeamMate(plr) then
                        continue
                    end

                    if o.do_killall then
                        shared_modules.Damage.ThrowableHit({
                            playerName = plr.Name,
                            limbName = closest_bone.inst.Name,
                            weaponName = "Cheat'd",
                            multiplier = 1,
                            crouch = false,
                            prone = false,
                            slide = false
                        })
                        shared_modules.ServerPlayer.PromptDeploy()
                    elseif o.do_autoknife and tick() - lastAutoKnife >= 0.05 and closest_bone.dist <= 32 and closest_bone.inst then
                        shared_modules.Damage.MeleeHit({
                            playerName = plr.Name,
                            limbName = closest_bone.inst.Name,
                            weaponName = "KNIFE",
                            multiplier = 1,
                            crouch = false,
                            prone = false,
                            slide = false
                        })
                        lastAutoKnife = tick()
                    end

                    if o.do_autoshoot and tick() - lastAutoShoot >= o.autoshoot_delay / 1000 then
                        if hrp then
                            local target = hrp.Position
                            local success, is_vis = pcall(vis_check, target, camcf.Position)
                            if success and is_vis then
                                pcall(force_shoot, plr)
                                lastAutoShoot = tick()
                            end
                        end
                    end

                    local vector, visible = current_camera:WorldToViewportPoint(hrp.Position)
                    if o.usefov and (not visible) then
                        continue
                    end

                    vector = Vector2.new(vector.X, vector.Y)
                    local distance = math.floor((vector - origin).Magnitude)

                    if o.usefov then
                        if distance > o.silentfov then
                            continue
                        end
                    end

                    if o.visibleonly then
                        local suc, is_vis = pcall(vis_check, hrp.Position)
                        if not suc or not is_vis then
                            continue
                        end
                    end

                    targets[#targets + 1] = { plr, distance }
                end

                table.sort(targets, function(a, b) return a[2] < b[2] end)

                local _target = targets[1]
                if _target then
                    target = _target[1]
                else
                    target = nil
                end
            end
        end)
    end

    local function GetESPColor(plr)
        local char = plr and plr.Character
        if char then
            local isSameTeam = IsTeamMate(plr)
            if (o.esp_highlighttarget and plr == target) then
                return o.esp_highlightcolor
            end
            return (isSameTeam and o.esp_teamcolor or o.esp_enemycolor)
        end
        return o.esp_enemycolor
    end
    local function GetGlowColor(plr)
        local char = plr and plr.Character
        if char then
            local isSameTeam = IsTeamMate(plr)
            return (isSameTeam and o.glow_teamcolor or o.glow_enemycolor)
        end
        return o.glow_enemycolor
    end

    local update_chams do
        local coregui_parent = game:GetService("CoreGui"):WaitForChild("RobloxGui")
        local boundsMaxInt = 16
        local function getModelBounds3d(model)
            local cf, size = model:GetBoundingBox()
            if size.X > boundsMaxInt then size = Vector3.new(boundsMaxInt, size.Y, size.Z) end
            if size.Y > boundsMaxInt then size = Vector3.new(size.X, boundsMaxInt, size.Z) end
            if size.Z > boundsMaxInt then size = Vector3.new(size.X, size.Y, boundsMaxInt) end
            local corners               = {}
            local frontFaceCenter       = cf                     + cf.LookVector                      * size.Z / 2
            local backFaceCenter        = cf                     - cf.LookVector                      * size.Z / 2
            local topFrontEdgeCenter    = frontFaceCenter        + frontFaceCenter.UpVector           * size.Y / 2
            local bottomFrontEdgeCenter = frontFaceCenter        - frontFaceCenter.UpVector           * size.Y / 2
            local topBackEdgeCenter     = backFaceCenter         + backFaceCenter.UpVector            * size.Y / 2
            local bottomBackEdgeCenter  = backFaceCenter         - backFaceCenter.UpVector            * size.Y / 2
            corners.topFrontRight       = (topFrontEdgeCenter    + topFrontEdgeCenter.RightVector     * size.X / 2).Position
            corners.topFrontLeft        = (topFrontEdgeCenter    - topFrontEdgeCenter.RightVector     * size.X / 2).Position
            corners.bottomFrontRight    = (bottomFrontEdgeCenter + bottomFrontEdgeCenter.RightVector  * size.X / 2).Position
            corners.bottomFrontLeft     = (bottomFrontEdgeCenter - bottomFrontEdgeCenter.RightVector  * size.X / 2).Position
            corners.topBackRight        = (topBackEdgeCenter     + topBackEdgeCenter.RightVector      * size.X / 2).Position
            corners.topBackLeft         = (topBackEdgeCenter     - topBackEdgeCenter.RightVector      * size.X / 2).Position
            corners.bottomBackRight     = (bottomBackEdgeCenter  + bottomBackEdgeCenter.RightVector   * size.X / 2).Position
            corners.bottomBackLeft      = (bottomBackEdgeCenter  - bottomBackEdgeCenter.RightVector   * size.X / 2).Position
            corners.rawSize             = size
            return corners
        end
        local function drawLineFrom3d(v3_1, v3_2, v3_3, v3_4, line, color)
            local camera = workspace.CurrentCamera
            if camera then
                if (camera.CFrame.Position - v3_1).Magnitude > 8 then
                    local a = camera:WorldToViewportPoint(v3_1)
                    local b = camera:WorldToViewportPoint(v3_2)
                    local c = camera:WorldToViewportPoint(v3_3)
                    local d = camera:WorldToViewportPoint(v3_4)
                    line.PointA = Vector2.new(a.X, a.Y)
                    line.PointB = Vector2.new(b.X, b.Y)
                    line.PointC = Vector2.new(c.X, c.Y)
                    line.PointD = Vector2.new(d.X, d.Y)
                    line.Color = color
                    line.Visible = o.esp_3dbox
                end
            end
        end
        local function add_esp_thread(char)
            local polygons = {}
            for i = 1, 6 do
                local square = Drawing.new("Quad")
                square.Thickness = 1
                square.Filled = false
                polygons[i] = square
            end
            local conn = runservice.RenderStepped:Connect(function()
                local camera = workspace.CurrentCamera
                if typeof(char) == "Instance" and char:IsA("Model") then
                    if camera then
                        local color = GetESPColor(char)
                        local bounds = getModelBounds3d(char)
                        drawLineFrom3d(bounds.topFrontLeft, bounds.topFrontRight, bounds.bottomFrontRight, bounds.bottomFrontLeft, polygons[1], color)
                        drawLineFrom3d(bounds.topBackLeft, bounds.topBackRight, bounds.bottomBackRight, bounds.bottomBackLeft, polygons[2], color)
                        drawLineFrom3d(bounds.topBackRight, bounds.topFrontRight, bounds.bottomFrontRight, bounds.bottomBackRight, polygons[3], color)
                        drawLineFrom3d(bounds.topBackLeft, bounds.topFrontLeft, bounds.bottomFrontLeft, bounds.bottomBackLeft, polygons[4], color)
                        drawLineFrom3d(bounds.topFrontRight, bounds.topFrontLeft, bounds.topBackLeft, bounds.topBackRight, polygons[5], color)
                        drawLineFrom3d(bounds.bottomBackLeft, bounds.bottomBackRight, bounds.bottomFrontRight, bounds.bottomFrontLeft, polygons[6], color)
                    end
                end
            end)
            char.AncestryChanged:Connect(function()
                conn:Disconnect()
                for _, line in pairs(polygons) do
                    task.spawn(pcall, function()
                        line.Visible = false
                        line:Remove()
                    end)
                end
            end)
        end
        --local entity_outlines = {}
        --local function add_entity_outline(char)
        --    local team = char:FindFirstChild("Team")
        --    local localteam = localplayer:FindFirstChild("SelectedTeam")
        --    if team and localteam and char ~= localplayer.Character then
        --        local outline = char:FindFirstChildWhichIsA("Highlight") or Instance.new("Highlight")
        --        outline.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        --        outline.OutlineColor = GetESPColor(char)
        --        outline.OutlineTransparency = o.do_outlines and 0 or 1
        --        outline.Adornee = char
        --        outline.FillTransparency = 1
        --        outline.Parent = coregui_parent
        --        entity_outlines[char] = outline
        --    end
        --end
        --for _, c in pairs(characters:GetChildren()) do
        --    add_entity_outline(c)
        --end
        --characters.ChildAdded:Connect(add_entity_outline)
        --characters.ChildRemoved:Connect(function(char)
        --    if typeof(entity_outlines[char]) == "Instance" then
        --        pcall(game.Destroy, entity_outlines[char])
        --    end
        --    entity_outlines[char] = nil
        --end)
        -- CHAMS!!!!! (glow)
        local function update_cham(char, plr)
            local glow_color = GetGlowColor(plr)
            for _, texture in pairs(char:GetDescendants()) do
                if texture:IsA("Texture") then
                    texture.Color3 = glow_color
                    texture.Transparency = o.do_glow and ((100 - (o.glow_intensity or 100)) / 100) or 1
                    texture.ZIndex = 8
                end
            end
        end
        function update_chams()
            for _, plr in pairs(players:GetPlayers()) do
                if plr and plr.Character then
                    update_cham(plr.Character, plr)
                end
            end
        end
        -- outlines
        local outlines = {}
        local function update_outlines()
            for player, outline in pairs(outlines) do
                outline.OutlineColor = GetESPColor(player)
                outline.OutlineTransparency = o.do_outlines and 0 or 1
                if not player or not player.Character then
                    pcall(game.Destroy, outline)
                    outlines[player] = nil
                end
            end
        end
        task.spawn(function()
            while task.wait() do
                update_outlines()
            end
        end)
        local function add_outline(character, player)
            if not player then return end
            local outline = Instance.new("Highlight")
            outline.FillTransparency = 1
            outline.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            outline.Adornee = character
            outline.Parent = coregui_parent
            outlines[player] = outline
            local humanoid = character:FindFirstChildWhichIsA("Humanoid")
            if humanoid then
                humanoid.Died:Connect(function()
                    pcall(game.Destroy, outline)
                    outlines[player] = nil
                end)
            end
            -- chams
            for _, mesh in pairs(character:GetDescendants()) do
                if mesh:IsA("MeshPart") then
                    for _, face in pairs(Enum.NormalId:GetEnumItems()) do
                        local texture = Instance.new("Texture")
                        texture.Texture = "rbxassetid://6888586040"
                        texture.Transparency = 1
                        texture.Face = face
                        texture.Parent = mesh
                    end
                end
            end
        end
        local function remove_outline(plr)
            if plr and outlines[plr] then
                pcall(game.Destroy, outlines[plr])
                outlines[plr] = nil
            end
        end
        local function init_plr(plr)
            if plr.Character then
                add_outline(plr.Character, plr)
            end
            plr.CharacterAdded:Connect(function(char)
                add_outline(char, plr)
            end)
            plr.CharacterRemoving:Connect(function()
                remove_outline(plr)
            end)
        end
        players.PlayerAdded:Connect(init_plr)
        players.PlayerRemoving:Connect(function(plr)
            remove_outline(plr)
        end)
        for _, plr in pairs(players:GetPlayers()) do
            if plr == localplayer then continue end
            init_plr(plr)
        end
    end

    local RemoteEventOverrides = {}
    --// RemoteEvent overrides
    info("Hooking global __namecall")
    local IsA = game.IsA
    OldNameCall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        if not checkcaller() then
            local Args = { ... }
            local EventName = Args[1]
            local Method = getnamecallmethod()
            if IsA(self, "RemoteEvent") and Method == "FireServer" then
                local Handler = RemoteEventOverrides[EventName]
                if type(Handler) == "function" then
                    return OldNameCall(self, Handler(...))
                end
            elseif self == localplayer and string.lower(Method) == "kick" then
                return nil
            elseif string.match(debug.getinfo(3).short_src, "AntiCheat$") then
                return task.wait(10e5)
            end
            --task.spawn(info, "{FROM", tostring(debug.getinfo(3).short_src) .. "} " .. tostring(self) .. ":" .. Method .. "(" .. string.sub(table.concat(Args, ", "), 1, -1) .. ")")
        end
        return OldNameCall(self, ...)
    end))
    ok("Hooked")

    info("Initializing ui")
    do --// ui
        local ui = library:CreateWindow("Cheat")

        local aim = ui:AddFolder("Aim")
        --local anti_aim = ui:AddFolder("Anti Aim")
        local gun = ui:AddFolder("Gun")
        local esp = ui:AddFolder("ESP")

        aim:AddToggle({
            text = "Silent Aim",
            state = o.do_silentaim,
            callback = function(v) o.do_silentaim = v end
        })
        aim:AddToggle({
            text = "Use FOV",
            state = o.usefov,
            callback = function(v) o.usefov = v end
        })
        aim:AddSlider({
            text = "FOV",
            value = o.silentfov,
            min = 0,
            max = 300,
            callback = function(v) o.silentfov = v end
        })
        aim:AddToggle({
            text = "Visible Only",
            state = o.visibleonly,
            callback = function(v) o.visibleonly = v end
        })
        --aim:AddToggle({
        --    text = "Shoot \"Around Corners\"",
        --    state = o.do_cornershoot,
        --    callback = function(v) o.do_cornershoot = v end
        --})
        --aim:AddToggle({
        --    text = "Infinite Wallbang",
        --    state = o.do_infwallbang,
        --    callback = function(v) o.do_infwallbang = v end
        --})

        --aim:AddToggle({
        --    text = "Auto Reload",
        --    state = o.do_autoreload,
        --    callback = function(v) o.do_autoreload = v end
        --})
        aim:AddSlider({
            text = "Auto Shoot Delay",
            value = o.autoshoot_delay,
            min = 0,
            max = 1000,
            callback = function(v) o.autoshoot_delay = v end
        })
        aim:AddList({
            text = "Auto Shoot Mode",
            value = o.autoshoot_mode,
            values = { "Forced", "Regular", "Ghost" },
            callback = function(v) o.autoshoot_mode = v end
        })
        aim:AddBind({
            text = "Force Shoot",
            key = "Z",
            hold = true,
            callback = force_shoot
        })

        --anti_aim:AddToggle({
        --    text = "Enable",
        --    state = o.do_antiaim,
        --    callback = function(v) o.do_antiaim = v end
        --})
        --anti_aim:AddList({
        --    text = "Pitch",
        --    value = o.antiaim_pitch,
        --    values = { "Default", "Up", "Down", "Random" },
        --    callback = function(v) o.antiaim_pitch = v end
        --})
        --anti_aim:AddList({
        --    text = "Yaw",
        --    value = o.antiaim_yaw,
        --    values = { "Default", "Spin", "Backwards", "Backwards Jitter" },
        --    callback = function(v) o.antiaim_yaw = v end
        --})
        --anti_aim:AddList({
        --    text = "Face Towards",
        --    value = o.antiaim_target,
        --    values = { "View Angle", "Target" },
        --    callback = function(v) o.antiaim_target = v end
        --})
        --anti_aim:AddToggle({
        --    text = "No Leg Movement",
        --    state = o.antiaim_noleg,
        --    callback = function(v) o.antiaim_noleg = v end
        --})

        gun:AddSlider({
            text = "Bullet Multiplier",
            value = o.bullet_multiplier,
            min = 1,
            max = 100,
            callback = function(v) o.bullet_multiplier = v end
        })

        esp:AddToggle({
            text = "Outlines",
            state = o.do_outlines,
            callback = function(v) o.do_outlines = v end
        })
        --esp:AddToggle({
        --    text = "Player 3D Box",
        --    state = o.esp_3dbox,
        --    callback = function(v) o.esp_3dbox = v end
        --})
        esp:AddColor({
            text = "Enemy Outline Color",
            color = { o.esp_enemycolor.r, o.esp_enemycolor.g, o.esp_enemycolor.b },
            callback = function(v) o.esp_enemycolor = v end
        })
        esp:AddColor({
            text = "Team Outline Color",
            color = { o.esp_teamcolor.r, o.esp_teamcolor.g, o.esp_teamcolor.b },
            callback = function(v) o.esp_teamcolor = v end
        })
        esp:AddToggle({
            text = "Highlight Target",
            state = o.esp_highlighttarget,
            callback = function(v) o.esp_highlighttarget = v end
        })
        esp:AddColor({
            text = "Highlight Color",
            color = {  o.esp_highlightcolor.r, o.esp_highlightcolor.g, o.esp_highlightcolor.b },
            callback = function(v) o.esp_highlightcolor = v end
        })


        do--[[
            local weapons = {}
            for weapon, _ in pairs(weaponInfo) do
                table.insert(weapons, weapon)
            end
            misc:AddList({
                text = "Spam Buy Weapon",
                value = o.spambuy_weapon,
                values = weapons,
                callback = function(v) o.spambuy_weapon = v end
            })--]]
        end
       
        --#region skin changer
        do
            --local weapons = replicatedstorage:WaitForChild("Assets"):WaitForChild("Weapons")
            --local ignore_weapons = {
            --    "Zyla Brain", "Combat Turret", "Flashbang",
            --    "Humbug", "Zyla Powerup", "Medic Gun",
            --    "Bomb", "Molotov", "Grenade", "Smoke Grenade",
            --    "Edira Powerup"
            --}
            --local skins = {}
            --for _, weapon in pairs(weapons:GetChildren()) do
            --    if table.find(ignore_weapons, weapon.Name) then continue end
            --    local weapon_skins = {}
            --    for _, skin in pairs(weapon:GetChildren()) do
            --        table.insert(weapon_skins, skin.Name)
            --    end
            --    skins[weapon.Name] = weapon_skins
            --end
            ----
            --for weapon_name, available_skins in pairs(skins) do
            --    skin_changer:AddList({
            --        text = weapon_name,
            --        values = available_skins,
            --        value = o.skin_overrides[weapon_name] or "Default",
            --        callback = function(v)
            --            o.skin_overrides[weapon_name] = v
            --        end
            --    })
            --end
        end
        --#endregion

        ui:AddButton({
            text = "Save Options",
            callback = saveOptions
        })
        ui:AddButton({
            text = "Join Discord",
            callback = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kitakuxo/Lab/main/discord.lua"))()
        })
        ui:AddButton({
            text = "Rejoin",
            callback = RejoinSameInstance
        })
    end

    local function localCharAdded(char)
        local viewmodel = char:WaitForChild("FirstPersonRig")
        local weapon = viewmodel:WaitForChild("Weapon")
        for _, mesh in pairs(weapon:GetDescendants()) do
            if mesh:IsA("MeshPart") then
                for _, face in pairs(Enum.NormalId:GetEnumItems()) do
                    local texture = Instance.new("Texture")
                    texture.Texture = "rbxassetid://6888586040"
                    texture.Transparency = 1
                    texture.Face = face
                    texture.Parent = mesh
                end
            end
        end
    end
    localplayer.CharacterAdded:Connect(localCharAdded)
    if localplayer.Character then
        localCharAdded(localplayer.Character)
    end

    task.spawn(function()
        while true do
            for i=0,1,0.001 do
                rainbow_color = Color3.fromHSV(i, 1, 1)
                task.wait()
                if o.do_rainbowsky then
                    for _, sky in ipairs(lighting:GetChildren()) do
                        if sky:IsA("Sky") then
                            sky.SkyboxBk = "rbxassetid://8694485972"
                            sky.SkyboxDn = "rbxassetid://8694485972"
                            sky.SkyboxFt = "rbxassetid://8694485972"
                            sky.SkyboxLf = "rbxassetid://8694485972"
                            sky.SkyboxRt = "rbxassetid://8694485972"
                            sky.SkyboxUp = "rbxassetid://8694485972"
                            sky.CelestialBodiesShown = false
                            sky.StarCount = 0
                        end
                    end
                    lighting.Ambient = rainbow_color
                    lighting.ColorShift_Top = rainbow_color
                end
            end
        end
    end)
    task.spawn(function()
        while task.wait(.25) do
            -- gun mods herererereeeeeeeeee
            local fprig = framework.LocalFPRig
            local equipped_weapon = fprig and get_practical_weapon(fprig, true)
            local weapon_data = type(equipped_weapon) == "table" and equipped_weapon.weaponData
            if type(weapon_data) == "table" then
                if o.fire_rate > 0 then
                    weapon_data.fireRate = o.fire_rate
                end
                if o.do_infiniteammo then
                    weapon_data.magazineAmmunition = math.huge
                    weapon_data.magazineSize = math.huge
                    weapon_data.maxAmmunition = math.huge
                end
                if o.do_nospread then
                    weapon_data.hipSread = 0
                    weapon_data.aimedSpread = 0
                    weapon_data.accuracy = 0
                end
                if o.do_norecoil then
                    weapon_data.recoil = 0
                    weapon_data.kickback = 0
                    weapon_data.torque = 0
                end
                if o.bullet_caliber ~= "Default" then
                    weapon_data.type = string.upper(o.bullet_caliber)
                end
                if o.fire_mode ~= "Default" then
                    weapon_data.firingMode = string.upper(o.fire_mode)
                end
            end
        end
    end)--]]
    local viewmodel
    task.spawn(function()
        local frame = 0
        while runservice.RenderStepped:Wait() do
            frame += 1
            current_camera = workspace.CurrentCamera
            if localplayer.Character then
                viewmodel = localplayer.Character:FindFirstChild("FirstPersonRig")
                if viewmodel then
                    for _, texture in pairs(viewmodel:GetDescendants()) do
                        if texture:IsA("Texture") then
                            if o.do_rainbowgun then
                                texture.Color3 = rainbow_color
                                texture.ZIndex = 9
                                texture.Transparency = 0
                            else
                                texture.ZIndex = 0
                                texture.Transparency = 1
                            end
                        end
                    end
                    local arm_rig = viewmodel:FindFirstChild("ArmsRig")
                    local arms = arm_rig and arm_rig:FindFirstChild("Arms")
                    if arm_rig and arms then
                        if o.do_noarms then
                            arms.Transparency = 1
                        else
                            arms.Transparency = 0
                        end
                    end
                end
                local humanoid = localplayer.Character:FindFirstChildWhichIsA("Humanoid")
                if framework then
                    local local_character = framework.LocalCharacter
                    if local_character then
                        if o.speed_modifier > 1 then
                            pcall(local_character.SetWalkSpeedMultiplier, local_character, o.speed_modifier / 10)
                        end
                    end
                end
                if o.do_chatspam and frame % 15 == 0 then
                    pcall(shared_modules.ServerChat.ReceiveMessage, { internal = true, prefix = o.chatspam_msg .. "\0", text = "", rawPrefix = "" })
                end
            end
        end
    end)
    OldIndex = hookmetamethod(game, "__index", newcclosure(function(self, idx)
        if not checkcaller() then
            if self == localplayer then
                if idx == "Name" or idx == "DisplayName" then
                    --local f = debug.getinfo(3)
                    if o.spoofed_name ~= ""
                    --and not string.match(f.source, "SpectateManager$")
                    then
                        return o.spoofed_name
                    end
                end
            elseif IsA(self, "LocalScript") then
                if idx == "Disabled" then
                    return false
                end
            end
        end
        return OldIndex(self, idx)
    end))--]]
    local userinputservice = WaitForService("UserInputService")
    local lastPrimaryPosition = Vector3.zero
    local lastPrimaryRotOffset = Vector3.zero
    local prevDoGhosting = false
    local aa_spin_value = 0
    local aa_jitter_value = 1
    local aa_neck_value = 1
    runservice:BindToRenderStep("MouseLock",Enum.RenderPriority.Character.Value + 5, function()
        local char = localplayer.Character
        local camera = workspace.CurrentCamera
        if char and camera then
            local cameraCFrame = camera.CFrame
            local cameraLookVector = cameraCFrame.LookVector.Unit
            local primaryPart = char.PrimaryPart
            local head = char:FindFirstChild("Head")
            local lowerTorso = char:FindFirstChild("LowerTorso")
            local neck = head and head:FindFirstChild("Neck")
            local root = lowerTorso and lowerTorso:FindFirstChild("Root")
            local t_char = target and target.Character
            local t_primaryPart = t_char and t_char.PrimaryPart
            if o.do_antiaim and neck and root then
                if o.antiaim_pitch == "Down" then
                    neck.C0 = CFrame.new(neck.C0.Position) * CFrame.fromEulerAnglesXYZ(math.rad(-55), 0, 0)
                elseif o.antiaim_pitch == "Up" then
                    neck.C0 = CFrame.new(neck.C0.Position) * CFrame.fromEulerAnglesXYZ(math.rad(55), 0, 0)
                elseif o.antiaim_pitch == "Random" then
                    aa_neck_value = (aa_neck_value + 1) % 2
                    neck.C0 = CFrame.new(neck.C0.Position) * CFrame.fromEulerAnglesXYZ(math.rad(aa_neck_value == 0 and -55 or 55), 0, 0)
                else
                    neck.C0 = CFrame.new(neck.C0.Position)
                end
                local root_initial = CFrame.new(root.C0.Position)
                local root_offset = CFrame.identity
                if o.antiaim_yaw == "Backwards" then
                    root_offset = CFrame.fromEulerAnglesXYZ(0, math.rad(180), 0)
                elseif o.antiaim_yaw == "Backwards Jitter" then
                    aa_jitter_value = (aa_jitter_value + 1) % 2
                    root_offset = CFrame.fromEulerAnglesXYZ(0, math.rad(aa_jitter_value == 0 and 175 or 185), 0)
                elseif o.antiaim_yaw == "Spin" then
                    aa_spin_value = (aa_spin_value + 47) % 360
                    root_offset = CFrame.fromEulerAnglesXYZ(0, math.rad(aa_spin_value), 0)
                end
                if o.antiaim_target == "Target" and target then
                    if t_char and t_primaryPart then
                        root_initial = CFrame.lookAt(
                            root.C0.Position,
                            Vector3.new(t_primaryPart.Position.X,
                                root.C0.Position.Y,
                                t_primaryPart.Position.Z
                            )
                        )
                    end
                end
                root.C0 = root_initial * root_offset
            elseif root and neck then
                neck.C0 = CFrame.new(neck.C0.Position)
                root.C0 = CFrame.new(root.C0.Position)
            end
            if char and primaryPart then
                local primaryPosition = primaryPart.Position
                local primaryRotOffset = primaryPosition + Vector3.new(cameraLookVector.X, 0, cameraLookVector.Z)
                if o.do_thirdperson then
                    userinputservice.MouseBehavior = Enum.MouseBehavior.LockCenter
                    char:PivotTo(CFrame.lookAt(primaryPosition, primaryRotOffset))
                end
                if doGhosting then
                    if not prevDoGhosting then
                        lastPrimaryPosition = primaryPosition
                        lastPrimaryRotOffset = primaryRotOffset
                    end
                    local primaryPositionDelta = XZCompare(lastPrimaryPosition, primaryPosition).Magnitude
                    if primaryPositionDelta > 2.5 then
                        char:PivotTo(CFrame.lookAt(lastPrimaryPosition, lastPrimaryRotOffset))
                    end
                end
            end
        end
        prevDoGhosting = doGhosting
    end)--]]

    library:Init()
    getgenv(0).__AHLOADED = true
    ok("Cheat ready :D")
    WaitForService("StarterGui"):SetCore("SendNotification", { Title = "Welcome to Barboss steak", Text = "Made by Kitaku", Image = "rbxassetid://7091101767" })
    --
--[[end, debug.traceback)
if not success then
    local genv = getgenv(0)
    local tb = string.split(msg, "\n")
    msg = tb[1]
    tb = select(2, tb)
    --genv.rconsoleclear()
    genv.rconsoleprint("@@YELLOW@@")
    genv.rconsoleprint("Cheat did not initialize properly\n")
    genv.rconsoleprint("@@LIGHT_RED@@")
    genv.rconsoleprint(tostring(msg) .. "\n")
    genv.rconsoleprint("@@LIGHT_BLUE@@")
    genv.rconsoleprint("  Stack Begin\n")
    if type(tb) == "table" and #tb >= 1 then
        for _, c in ipairs(tb) do
            genv.rconsoleprint("  " .. tostring(c) .. "\n")
        end
    end
    genv.rconsoleprint("  Stack End\n")
    genv.messagebox(tostring(msg):gsub("^%w+%:", "Line "), "Uncaught Exception", 0)
    game:GetService("TeleportService"):Teleport(game.GameId, game:GetService("Players").LocalPlayer)
    error
    while task.wait() do genv.rconsoleinput() end
end--]]
