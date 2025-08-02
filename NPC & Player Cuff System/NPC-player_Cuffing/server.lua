RegisterNetEvent("cuff:togglePlayer")
AddEventHandler("cuff:togglePlayer", function(targetId)
    TriggerClientEvent("cuff:toggleOnClient", targetId)
end)
