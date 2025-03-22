repeat task.wait() until game:GetService("StarterPlayer"):FindFirstChild("StarterPlayerScripts")

local plrservice = game:GetService("Players")
local me = plrservice.LocalPlayer

getgenv().FSScriptDumperLW = {}

local noobworkspace = game:GetService("Workspace"):GetDescendants()
local noobreplicatedstorage = game:GetService("ReplicatedStorage"):GetDescendants()
local noobreplicatedfirst = game:GetService("ReplicatedFirst"):GetDescendants()
local noobstarterplayer = game:GetService("StarterPlayer").StarterPlayerScripts:GetDescendants()
local nobostartercharacter = game:GetService("StarterPlayer").StarterCharacterScripts:GetDescendants()
local noobstartergui = game:GetService("StarterGui"):GetDescendants()
local noobnilinstances = getnilinstances()

local DecompileStartTime = os.time()
local ScriptsFailedToDecompile = 0
local ScriptsSuccesfullyDecompiled = 0
local ScriptDumpingCompleted = false 


local ScriptDumperDirFolderName = tostring(game.PlaceId)

if not isfolder(ScriptDumperDirFolderName) then
makefolder(ScriptDumperDirFolderName)
end


local ServicesCrap = {
["Nil_Instances"] = {DecompileState=false,Path=noobnilinstances},
["StarterPlayerScripts"] = {DecompileState=false,Path=noobstarterplayer},
["StarterCharacterScripts"] = {DecompileState=false,Path=nobostartercharacter},
["ReplicatedStorage"] = {DecompileState=false,Path=noobreplicatedstorage},
["ReplicatedFirst"] = {DecompileState=false,Path=noobreplicatedfirst},
["StarterGui"] = {DecompileState=false,Path=noobstartergui}
}


local function DecompileScriptGrr(ScriptToDecompile)
    local Success, ReturnedData
    local DecompiledOutput
    local ScriptByteCode

    Success, ReturnedData =
        pcall(function()
            ScriptByteCode = getscriptbytecode(ScriptToDecompile)
            if ScriptByteCode then
                DecompiledOutput = decompile(ScriptToDecompile)
            end
        end)
    return {
        ["Success"] = Success,
        ["Output"] = DecompiledOutput or "Unknown Bytecode"
    }
end

FSScriptDumperLW.RegisterService = function(ServicesData)
    for i,v in pairs(ServicesData) do 
      ServicesCrap[i].DecompileState = v.DecompileState
    end
end 

FSScriptDumperLW.StartDumping = function()
    task.spawn(function()
        for i, v in pairs(ServicesCrap) do
            if v.DecompileState == true then
                makefolder(ScriptDumperDirFolderName .. "/" .. i)
                for i2, v2 in pairs(v.Path) do
                    if v2:IsA("ModuleScript") or v2:IsA("LocalScript") then
                        local ScriptDecompiled = DecompileScriptGrr(v2)
                        if ScriptDecompiled.Success and ScriptDecompiled.Output~="Unknown Bytecode" then
                            ScriptsSuccesfullyDecompiled = ScriptsSuccesfullyDecompiled+1
                            writefile(ScriptDumperDirFolderName .. "/" .. i .. "/" .. v2.Name .. "_" .. tostring(i2) .. ".lua",ScriptDecompiled.Output)
                        else
                            ScriptsFailedToDecompile = ScriptsFailedToDecompile + 1
                        end
                    end
                end
            end
          end
        
          ScriptDumpingCompleted = true 
        end)
        
        repeat task.wait() until ScriptDumpingCompleted == true 
        
        local DecompileEndTimeStamp = os.time()-DecompileStartTime
        
        print("Decompiling Finished in : "..DecompileEndTimeStamp.." Seconds")
        print("Folder dir name: "..ScriptDumperDirFolderName)
        print("Scripts failed to decompile : "..tostring(ScriptsFailedToDecompile))
        print("Scripts decompiled : "..tostring(ScriptsSuccesfullyDecompiled))
end 
