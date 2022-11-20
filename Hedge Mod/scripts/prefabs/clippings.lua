local assets = 
{
	Asset("ANIM", "anim/cut_hedge.zip"),
    Asset("IMAGE", "images/inventoryimages/clippings.tex"),
    Asset("ATLAS", "images/inventoryimages/clippings.xml"),
}

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("cut_hedge")
    inst.AnimState:SetBuild("cut_hedge")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "clippings"    
    inst.components.inventoryitem.atlasname = "images/inventoryimages/clippings.xml"  

    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "VEGGIE"
    inst.components.edible.healthvalue = TUNING.HEALING_TINY
    inst.components.edible.hungervalue = TUNING.CALORIES_TINY/2

    inst:AddComponent("inspectable")
    
	MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL
        
    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("clippings", fn, assets)