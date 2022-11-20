require "prefabutil"

local isFlammable = TUNING.HEDGE_MOD.FLAMMABLE_HEDGES

local function OnIsPathFindingDirty(inst)    
    local wall_x, wall_y, wall_z = inst.Transform:GetWorldPosition()
    if TheWorld.Map:GetPlatformAtPoint(wall_x, wall_z) == nil then        
        if inst._ispathfinding:value() then
            if inst._pfpos == nil then
                inst._pfpos = Point(wall_x, wall_y, wall_z)
                TheWorld.Pathfinder:AddWall(wall_x, wall_y, wall_z)
            end
        elseif inst._pfpos ~= nil then
            TheWorld.Pathfinder:RemoveWall(wall_x, wall_y, wall_z)
            inst._pfpos = nil
        end
    end
end

local function makeobstacle(inst)
    inst.Physics:SetActive(true)
    inst._ispathfinding:set(true)
end

local function clearobstacle(inst)
    inst.Physics:SetActive(false)
    inst._ispathfinding:set(false)
end

local function InitializePathFinding(inst)
    inst:ListenForEvent("onispathfindingdirty", OnIsPathFindingDirty)
    OnIsPathFindingDirty(inst)
end

local function onremove(inst)
    inst._ispathfinding:set_local(false)
    OnIsPathFindingDirty(inst)
end


local function onsave(inst, data)
    data.is_grown = inst.components.harvestable:CanBeHarvested()
    data.color = inst.color
end

local function onload(inst, data)
    if data ~= nil then
        if data.is_grown and TUNING.HEDGE_MOD.HEDGE_GROWTH_ENABLED then
            inst.AnimState:PlayAnimation("growth2", false)
        end
        if data.color and TUNING.HEDGE_MOD.HEDGE_COLORED_VARIANCE then
            inst.color = data.color
            inst.AnimState:SetMultColour(data.color, data.color, data.color, 1)
        end
    end
end


function MakeHedgeType(data)
	local assets =
	{
		Asset("ANIM", "anim/hedge.zip"),
		Asset("ANIM", "anim/hedge"..data.hedgetype.."_build.zip"),
	
		Asset("IMAGE", "images/inventoryimages/hedge_block.tex"),
		Asset("ATLAS", "images/inventoryimages/hedge_block.xml"),
	}

	local prefabs =
	{
		"collapse_small",
	}

	local function ondeploywall(inst, pt, deployer)
		local wall = SpawnPrefab(data.name) 
		if wall ~= nil then 
            local x = math.floor(pt.x) + .5
            local z = math.floor(pt.z) + .5
            wall.Physics:SetCollides(false)
            wall.Physics:Teleport(x, 0, z)
            wall.Physics:SetCollides(true)
            inst.components.stackable:Get():Remove()
            
            if data.buildsound ~= nil then
                wall.SoundEmitter:PlaySound(data.buildsound)
            end
		end 		
	end

	local function onhammered(inst, worker)
        if data.maxloots ~= nil and data.loot ~= nil then
            local num_loots = math.max(1, math.floor(data.maxloots))
            for i = 1, num_loots do
                inst.components.lootdropper:SpawnLootPrefab(data.loot)
            end
        end

        local fx = SpawnPrefab("collapse_small")
        fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        if data.material ~= nil then
            fx:SetMaterial(data.material)
        end

        inst:Remove()
    end
	
	local function itemfn()
		local inst = CreateEntity()

		inst:AddTag("wallbuilder")
		
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()

		MakeInventoryPhysics(inst)
	    
		inst.AnimState:SetBank("hedge")
		inst.AnimState:SetBuild("hedge"..data.hedgetype.."_build")
		inst.AnimState:PlayAnimation("idle")

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
            return inst
        end

		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

		inst:AddComponent("inspectable")

		inst:AddComponent("inventoryitem")	   
        inst.components.inventoryitem.imagename = data.name    
        inst.components.inventoryitem.atlasname = "images/inventoryimages/"..data.name..".xml"  
		
		inst:AddComponent("deployable")
		inst.components.deployable.ondeploy = ondeploywall
		inst.components.deployable.placer = data.name.."_placer"
		inst.components.deployable:SetDeployMode(DEPLOYMODE.WALL)

        if isFlammable then
            MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
            MakeSmallPropagator(inst)

            inst:AddComponent("fuel")
            inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL
        end

		MakeHauntableLaunch(inst)
		
		return inst
	end

    local function on_harvested(inst, picker, picked_amount)

		inst.AnimState:PlayAnimation("growth1", false)

        if inst.components.shaveable ~= nil then
            inst.components.shaveable.prize_count = 0
        end

    end

    local function on_grown(inst, produce_count)

        inst.AnimState:PlayAnimation("growth2", false)

        if inst.components.shaveable ~= nil then
            inst.components.shaveable.prize_count = 2
        end

        inst.components.harvestable:SetGrowTime(TUNING.HEDGE_MOD.HEDGE_GROWTH_TIME + (math.random() * TUNING.WATERPLANT.GROW_VARIANCE))
    end

    local function can_shave(inst, shaver, shave_item)
        if inst.components.harvestable:CanBeHarvested() then
            return true
        else
            return false
        end
    end

    local function on_shaved(inst, shaver, shave_item)

		inst.AnimState:PlayAnimation("growth1", false)

        if inst.components.harvestable ~= nil then
            inst.components.harvestable.produce = 0
            inst.components.harvestable:StartGrowing()
        end
	end

    local function onhit(inst)
        if data.material ~= nil then
            inst.SoundEmitter:PlaySound("dontstarve/common/destroy_straw")
        end
    end

	local function fn()
		local inst = CreateEntity()
		local trans = inst.entity:AddTransform()
		local anim = inst.entity:AddAnimState()

        inst.entity:AddNetwork()
		inst.entity:AddSoundEmitter()

		trans:SetEightFaced()

		inst:AddTag("wall")
        inst:AddTag("noauradamage")

		MakeObstaclePhysics(inst, .5)    
        inst.Physics:SetDontRemoveOnSleep(true)

		anim:SetBank("hedge")
		anim:SetBuild("hedge"..data.hedgetype.."_build")
        anim:PlayAnimation("growth1", false)
		
        MakeSnowCovered(inst)
		MakeSnowCoveredPristine(inst)
        
        if not TheWorld.ismastersim then
            return inst
        end

		for i,v in ipairs(data.tags) do
		    inst:AddTag(v)
		end
        
        if TUNING.HEDGE_MOD.HEDGE_COLORED_VARIANCE then
            inst.color = .5 + math.random() * .5
            local color = inst.color
            inst.AnimState:SetMultColour(color, color, color, 1)
        end
		
        if data.buildsound then
			inst.SoundEmitter:PlaySound(data.buildsound)		
		end
		
		
        inst:SetPrefabNameOverride(data.name)
		inst:AddComponent("inspectable")

		inst:AddComponent("lootdropper")
		inst.OnRemoveEntity = onremove
		inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(3)
        inst.components.workable:SetOnFinishCallback(onhammered)
        inst.components.workable:SetOnWorkCallback(onhit) 

        if isFlammable then
            MakeMediumBurnable(inst)
            MakeLargePropagator(inst)
            inst.components.burnable.flammability = .5
            inst.components.burnable.nocharring = true
        end

		inst._pfpos = nil
        inst._ispathfinding = net_bool(inst.GUID, "_ispathfinding", "onispathfindingdirty")
        makeobstacle(inst)
        inst:DoTaskInTime(0, InitializePathFinding)

        if TUNING.HEDGE_MOD.HEDGE_GROWTH_ENABLED then
            -- Shaving and harvesting
            inst:AddComponent("shaveable")
            inst.components.shaveable:SetPrize("clippings", 2)
            inst.components.shaveable.can_shave_test = can_shave
            inst.components.shaveable.on_shaved = on_shaved

            inst:AddComponent("harvestable")
            inst.components.harvestable:SetUp("clippings", 1, TUNING.HEDGE_MOD.HEDGE_GROWTH_TIME + (math.random() * TUNING.WATERPLANT.GROW_VARIANCE), on_harvested, on_grown) 
        end

        MakeHauntableWork(inst)

        inst.OnSave = onsave
        inst.OnLoad = onload
        
		return inst
	end

	return Prefab(data.name, fn, assets, prefabs),	 	 
		   Prefab(data.name.."_item", itemfn, assets, {data.name, data.name.."_item_placer", "collapse_small"}),
		   MakePlacer(data.name.."_item_placer", "hedge", "hedge"..data.hedgetype.."_build", "growth1", false, false, true, nil, nil, "eight") 
	end

local hedgeprefabs = {}
local hedgedata = {
    {
        name = "hedge_block", hedgetype = 1, tags = {"grass"}, loot = "clippings", 
        maxloots = 2, maxhealth = TUNING.HAYWALL_HEALTH,  flammable = isFlammable, 
        buildsound = "dontstarve/common/place_structure_straw", destroysound = "dontstarve/common/destroy_straw",
    },
    {
        name = "hedge_cone", hedgetype = 2, tags = {"grass"}, loot = "clippings",
        maxloots = 2, maxhealth = TUNING.HAYWALL_HEALTH, flammable = isFlammable, 
        buildsound = "dontstarve/common/place_structure_straw", destroysound = "dontstarve/common/destroy_straw"
    },
    {
        name = "hedge_layered", hedgetype = 3, tags = {"grass"}, loot = "clippings", 
        maxloots = 2, maxhealth = TUNING.HAYWALL_HEALTH, flammable = isFlammable, 
        buildsound = "dontstarve/common/place_structure_straw", destroysound = "dontstarve/common/destroy_straw"
    }
}

for i, v in pairs(hedgedata) do
	local hedge, item, placer = MakeHedgeType(v)
	table.insert(hedgeprefabs, hedge)
	table.insert(hedgeprefabs, item)
	table.insert(hedgeprefabs, placer)
end

return unpack(hedgeprefabs)