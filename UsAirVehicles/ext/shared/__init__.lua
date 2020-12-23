class 'USAirVehiclesMod'


function USAirVehiclesMod:__init()
	print("Initializing USAirVehiclesMod")
	self:RegisterVars()
	self:RegisterEvents()
end


function USAirVehiclesMod:RegisterVars()
	self.f18SpawnGuids = nil
	self.havocSpawnGuids = nil
end


function USAirVehiclesMod:RegisterEvents()
  self.levelLoadResourcesEvent = Events:Subscribe('Level:LoadResources', self, self.OnLevelLoadResources)
end


function USAirVehiclesMod:OnLevelLoadResources()
  local viperGuids = { instanceGuid = Guid('758E3DE0-1726-4383-B7DA-D575013B5424'), partitionGuid = Guid('643135EA-6CA7-11DF-B6FA-F715AA601362') }
  local havocSpawnGuids = { instanceGuid = Guid('5A7D83DF-903A-4369-9F1B-B14E7CE7AF22'), partitionGuid = Guid('2EF3E7CB-F7E7-43B6-9275-3BE5BA1DA865') }
  self:WaitForInstances({viperGuids, havocSpawnGuids}, self.changeHavocBlueprint)
  local f18Guids = { instanceGuid = Guid('C81F8757-E6D2-DF2D-1CFE-B72B4F74FE98'), partitionGuid = Guid('3EABB4EF-4003-11E0-8ACA-C41D37DB421C') }
  local flankerSpawnGuids = { instanceGuid = Guid('0FC5971B-0564-4934-9BFE-7EB34CC014C6'), partitionGuid = Guid('383EB43B-4E32-4B6C-87FC-957B1A5E10EC') }
  self:WaitForInstances({f18Guids, flankerSpawnGuids}, self.changeFlankerBlueprint)
end


function USAirVehiclesMod:changeHavocBlueprint(instance)
  local vd = VehicleSpawnReferenceObjectData(ResourceManager:SearchForInstanceByGuid(Guid('5A7D83DF-903A-4369-9F1B-B14E7CE7AF22')))
  vd:MakeWritable()
  vd.blueprint = VehicleBlueprint(ResourceManager:SearchForDataContainer("Vehicles/AH1Z/AH1Z"))
end


function USAirVehiclesMod:changeFlankerBlueprint(instance)
  local vd = VehicleSpawnReferenceObjectData(ResourceManager:SearchForInstanceByGuid(Guid('0FC5971B-0564-4934-9BFE-7EB34CC014C6')))
  vd:MakeWritable()
  vd.blueprint = VehicleBlueprint(ResourceManager:SearchForDataContainer("Vehicles/F18-F/F18"))
end


-- Credit Janssent for this function (and all the help in general)
function USAirVehiclesMod:WaitForInstances(guidTable, loadHandler)
  local instances = {}
  for index, guids in ipairs(guidTable) do
      ResourceManager:RegisterInstanceLoadHandlerOnce(guids.partitionGuid, guids.instanceGuid, function(instance)
          instances[index] = instance
          for i = 1, #guidTable do
              instances[i] = instances[i] or ResourceManager:FindInstanceByGuid(guidTable[i].partitionGuid, guidTable[i].instanceGuid)
              if instances[i] == nil then
                  return
              end
          end
          loadHandler(table.unpack(instances))
      end)
  end
end

USAirVehiclesMod()