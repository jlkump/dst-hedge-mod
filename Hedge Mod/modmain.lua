local TECH = GLOBAL.TECH
local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS

require("recipes")

Assets = {
	Asset("IMAGE", "images/inventoryimages/hedge_block.tex"),
	Asset("ATLAS", "images/inventoryimages/hedge_block.xml"),

	Asset("IMAGE", "images/inventoryimages/hedge_cone.tex"),
	Asset("ATLAS", "images/inventoryimages/hedge_cone.xml"),

	Asset("IMAGE", "images/inventoryimages/hedge_layered.tex"),
	Asset("ATLAS", "images/inventoryimages/hedge_layered.xml"),
}

PrefabFiles = {
	"clippings",
	"hedge",
}

-- Tunning data
GLOBAL.TUNING.HEDGE_MOD = {
	FLAMMABLE_HEDGES = GetModConfigData("Flammable_Hedges"),
	CLIPPINGS_RATIO = GetModConfigData("Clippings_Ratio"),
	HEDGE_GROWTH_ENABLED = GetModConfigData("Hedge_Growth_Enabled"),
	HEDGE_GROWTH_TIME = TUNING.TOTAL_DAY_TIME/2,
	HEDGE_GROWTH_VARIANCE = TUNING.TOTAL_DAY_TIME,
	HEDGE_COLORED_VARIANCE = GetModConfigData("Hedge_Colored_Variance"),
}

-- Defines the names for items and objects
GLOBAL.STRINGS.NAMES.CLIPPINGS = "Clippings"
GLOBAL.STRINGS.NAMES.HEDGE_BLOCK_ITEM = "Block Hedge"
GLOBAL.STRINGS.NAMES.HEDGE_BLOCK = "Block Hedge Wall"
GLOBAL.STRINGS.NAMES.HEDGE_CONE_ITEM = "Cone Hedge"
GLOBAL.STRINGS.NAMES.HEDGE_CONE = "Cone Hedge Wall"
GLOBAL.STRINGS.NAMES.HEDGE_LAYERED_ITEM = "Layered Hedge"
GLOBAL.STRINGS.NAMES.HEDGE_LAYERED = "Layered Hedge Wall"

-- Default examinations for clippings and hedges
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.CLIPPINGS = "Some hedge clippings."
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.HEDGE_BLOCK_ITEM = "It's a wall of grass."
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.HEDGE_BLOCK = { GENERIC = "A blocky hedge.", BURNING = "Unfortunate.", }
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.HEDGE_CONE_ITEM = "Tip-topiary."
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.HEDGE_CONE = { GENERIC = "A pointy hedge.", BURNING = "Unfortunate.", }
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.HEDGE_LAYERED_ITEM = "Some pocket grass."
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.HEDGE_LAYERED = { GENERIC = "A layered hedge.", BURNING = "Unfortunate.", }

-- Custom examinations for Maxwell since he's my most played character :)
GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.CLIPPINGS = "Just some aesthetic grass."
GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.HEDGE_BLOCK_ITEM = "It's no good carrying this around everywhere."
GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.HEDGE_BLOCK = { GENERIC = "Simple.", BURNING = "I never tire of watching destruction.", }
GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.HEDGE_CONE_ITEM = "Why isn't this in the ground?"
GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.HEDGE_CONE = { GENERIC = "Pointy.", BURNING = "I never tire of watching destruction.", }
GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.HEDGE_LAYERED_ITEM = "Adds a touch of class to a garden."
GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.HEDGE_LAYERED = { GENERIC = "Elegant.", BURNING = "I never tire of watching destruction.", }

-- Since clippings are used as an ingredient for the hedges, 
-- we need to make a iventory item icon so it shows up in the recipie GUI
RegisterInventoryItemAtlas("images/inventoryimages/clippings.xml", "clippings.tex")


-- Recipies added to the game
AddRecipe("clippings", {Ingredient("cutgrass", 1)}, RECIPETABS.REFINE, TECH.SCIENCE_ONE, nil, nil, nil, GLOBAL.TUNING.HEDGE_MOD.CLIPPINGS_RATIO, nil, 
		"images/inventoryimages/clippings.xml","clippings.tex")
GLOBAL.STRINGS.RECIPE_DESC.CLIPPINGS = "Some hedge clippings"

AddRecipe("hedge_block_item", {Ingredient("clippings", 6)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, nil, nil, nil, 3, nil, 
		"images/inventoryimages/hedge_block.xml", "hedge_block.tex")
GLOBAL.STRINGS.RECIPE_DESC.HEDGE_BLOCK_ITEM = "A Hedge Block"

AddRecipe("hedge_cone_item", {Ingredient("clippings", 6)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, nil, nil, nil, 3, nil, 
		"images/inventoryimages/hedge_cone.xml", "hedge_cone.tex")
GLOBAL.STRINGS.RECIPE_DESC.HEDGE_CONE_ITEM = "A Hedge Cone"

AddRecipe("hedge_layered_item", {Ingredient("clippings", 6)}, RECIPETABS.TOWN, TECH.SCIENCE_TWO, nil, nil, nil, 3, nil, 
		"images/inventoryimages/hedge_layered.xml", "hedge_layered.tex")
GLOBAL.STRINGS.RECIPE_DESC.HEDGE_LAYERED_ITEM = "A Hedge with Layers"