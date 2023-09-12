local tab = ui.tab("Anti Backstab")
local max_distance = ui.slider("Distance", 50, 500)
tab.left:add(max_distance)
tab:register()

local dist_to = function(point1, point2)
    local dx = point2.x - point1.x
    local dy = point2.y - point1.y
    local dz = point2.z - point1.z
    
    return (dx*dx + dy*dy + dz*dz) ^ 0.5
end

math.min = function(a, b) return a < b and a or b end
math.max = function(a, b) return a > b and a or b end

callback.antiaim_setup(function(sts)
    local local_player = entity.me()
    if not local_player then
        return
    end

    local closest_player = {
        ["dist"] = nil,
        ["entity"] = nil
    }
    local local_origin = local_player:get_origin()
    local local_team = local_player:get_prop("DT_BaseEntity", "m_iTeamNum")
    
    entity.get_players(true, false, function(player)
        if player:get_prop("DT_BaseEntity", "m_iTeamNum") ~= local_team then
            local origin = player:get_origin()
            
            if closest_player["dist"] == nil or dist_to(local_origin, origin) < closest_player["dist"] then
                closest_player = {
                    ["dist"] = dist_to(local_origin, origin),
                    ["entity"] = player
                }
            end
        end
    end)

    if closest_player == nil or closest_player["dist"] == nil or closest_player["dist"] > max_distance:get() then
        return
    end

    sts.yaw_add = 180
    sts.align_by_target = 2

    -- safety
    sts.spin = false
    sts.jitter_angle = sts.jitter_angle > 0 and math.min(sts.jitter_angle, 30) or math.max(sts.jitter_angle, -30) -- I believe 30 is enough 
end)


callback.config_save(function(config)
    script.save_all(config.name .. '-backstab1337')
end)

callback.config_load(function(config)
    script.load_all(config.name .. '-backstab1337')
end)