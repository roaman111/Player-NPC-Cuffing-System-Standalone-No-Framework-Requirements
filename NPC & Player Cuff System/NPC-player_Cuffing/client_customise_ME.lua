-- client.lua

-- === EDIT ME ===
-- === EDIT ME ===
-- === EDIT ME ===

local CuffDistance = 3.5            -- max distance to cuff someone
local CuffPropModel = `prop_cs_cuffs`  -- handcuff prop model (change if not showing)
local CuffIdleDict = "mp_arresting"
local CuffIdleAnim = "idle"
local CopAnimDict = "mp_arrest_paired"
local CopAnimName = "cop_p2_back_left"
local UncuffAnimDict = "mp_arresting"
local UncuffAnimName = "a_uncuff"
local CopAnimDuration = 3000        -- ms
local UncuffAnimDuration = 2000     -- ms
local CuffAttachBone = 57005        -- bone index for cuffs attachment
local CuffAttachPos = {0.08, 0.0, 0.0}
local CuffAttachRot = {0.0, 90.0, 90.0}
local KeyMapping = "g"              -- key to cuff nearest

-- === DO NOT TOUCH BELOW THIS LINE ===
-- === DO NOT TOUCH BELOW THIS LINE ===
-- === DO NOT TOUCH BELOW THIS LINE ===


local cuffed = false
local cuffs = nil

function loadDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(10) end
end

function putCuffs(p)
    if DoesEntityExist(cuffs) then DeleteEntity(cuffs) end
    local mdl = CuffPropModel
    RequestModel(mdl)
    while not HasModelLoaded(mdl) do Wait(10) end
    local bone = GetPedBoneIndex(p, CuffAttachBone)
    local obj = CreateObject(mdl, 0, 0, 0, true, true, false)
    AttachEntityToEntity(obj, p, bone, table.unpack(CuffAttachPos), table.unpack(CuffAttachRot), true, true, false, true, 1, true)
    cuffs = obj
end

function dropCuffs()
    if DoesEntityExist(cuffs) then
        DeleteEntity(cuffs)
        cuffs = nil
    end
end

function freeze(p, toggle)
    FreezeEntityPosition(p, toggle)
    SetEntityInvincible(p, toggle)
    SetBlockingOfNonTemporaryEvents(p, toggle)
end

function animIdle(p)
    loadDict(CuffIdleDict)
    TaskPlayAnim(p, CuffIdleDict, CuffIdleAnim, 8.0, -8.0, -1, 49, 0, false, false, false)
end

function copAnim(tgt)
    local me = PlayerPedId()
    local offs = GetOffsetFromEntityInWorldCoords(tgt, 0.0, -0.5, 0.0)
    SetEntityCoords(me, offs.x, offs.y, offs.z)
    SetEntityHeading(me, GetEntityHeading(tgt))
    loadDict(CopAnimDict)
    TaskPlayAnim(me, CopAnimDict, CopAnimName, 8.0, -8.0, CopAnimDuration, 0, 0, false, false, false)
end

function uncuffAnim(tgt)
    local me = PlayerPedId()
    local offs = GetOffsetFromEntityInWorldCoords(tgt, 0.0, -0.5, 0.0)
    SetEntityCoords(me, offs.x, offs.y, offs.z)
    SetEntityHeading(me, GetEntityHeading(tgt))
    loadDict(UncuffAnimDict)
    TaskPlayAnim(me, UncuffAnimDict, UncuffAnimName, 8.0, -8.0, UncuffAnimDuration, 0, 0, false, false, false)
end

function closestEnt(rad)
    local me = PlayerPedId()
    local pos = GetEntityCoords(me)
    local near, dist, isP = nil, rad, false
    for _, id in pairs(GetActivePlayers()) do
        local ped = GetPlayerPed(id)
        local d = #(pos - GetEntityCoords(ped))
        if ped ~= me and d < dist then
            near, dist, isP = id, d, true
        end
    end
    local handle, ped = FindFirstPed()
    repeat
        if not IsPedAPlayer(ped) and IsPedHuman(ped) then
            local d = #(pos - GetEntityCoords(ped))
            if d < dist then
                near, dist, isP = ped, d, false
            end
        end
        succ, ped = FindNextPed(handle)
    until not succ
    EndFindPed(handle)
    return near, isP
end

RegisterCommand("cuff", function()
    local tgt, isP = closestEnt(CuffDistance)
    if not tgt then return end

    if isP then
        local ped = GetPlayerPed(tgt)
        if not cuffed then
            copAnim(ped)
        else
            uncuffAnim(ped)
        end
        TriggerServerEvent("cuff:togglePlayer", GetPlayerServerId(tgt))
    else
        local ped = tgt
        if not IsEntityPlayingAnim(ped, CuffIdleDict, CuffIdleAnim, 3) then
            copAnim(ped)
            Wait(1200)
            ClearPedTasksImmediately(ped)
            animIdle(ped)
            TaskStandStill(ped, -1)
            SetBlockingOfNonTemporaryEvents(ped, true)
            freeze(ped, true)
            putCuffs(ped)
        else
            uncuffAnim(ped)
            Wait(1500)
            ClearPedTasksImmediately(ped)
            freeze(ped, false)
            SetBlockingOfNonTemporaryEvents(ped, false)
            dropCuffs()
        end
    end
end)

RegisterKeyMapping("cuff", "Cuff nearest", "keyboard", KeyMapping)

RegisterNetEvent("cuff:toggleOnClient")
AddEventHandler("cuff:toggleOnClient", function()
    local me = PlayerPedId()
    cuffed = not cuffed
    if cuffed then
        ClearPedTasksImmediately(me)
        animIdle(me)
        freeze(me, true)
        putCuffs(me)
    else
        loadDict(UncuffAnimDict)
        TaskPlayAnim(me, UncuffAnimDict, UncuffAnimName, 8.0, -8.0, UncuffAnimDuration, 0, 0, false, false, false)
        Wait(1500)
        ClearPedTasksImmediately(me)
        freeze(me, false)
        dropCuffs()
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        if cuffed then
            DisableControlAction(0, 21, true)
            DisableControlAction(0, 22, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 37, true)
            DisableControlAction(0, 44, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 263, true)
            DisableControlAction(0, 264, true)
            DisableControlAction(0, 257, true)
        else
            Wait(500)
        end
    end
end)
