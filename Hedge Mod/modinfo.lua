name = "Hedge Mod"
version = "3.1"

description = "This mod ports the hedges from DS Hamlet to DST. Hedges can be crafted, will grow overtime, and can be sheared or picked."
author = "jkump1"

api_version = 10

dst_compatible = true

all_clients_require_mod = true
client_only_mod = false

server_filter_tags = {"hedges", "decorations","walls","wall","hedge", "grass", "victorian", "Hamlet"}

icon_atlas = "modicon.xml"
icon = "modicon.tex"

configuration_options = {
    {
        name = "Flammable_Hedges",
        label = "Flammable Hedges",
        hover = "Enable or disable flammable hedges",
        options = {
            {description = "Enabled", data = true},
            {description = "Disabled", data = false},
        },
        default = true,
    },
    {
        name = "Clippings_Ratio",
        label = "Clippings Crafting Ratio",
        hover = "Ratio of grass to clippings.",
        options = {
            {description = "1:1", data = 1},
            {description = "1:2", data = 2},
            {description = "1:3", data = 3},
            {description = "1:4", data = 4},
        },
        default = 2,
    },
    {
        name = "Hedge_Growth_Enabled",
        label = "Enable Hedge Growth",
        hover = "Set to true for hedge growth",
        options = {
            {description = "Enabled", data = true},
            {description = "Disabled", data = false},
        },
        default = true,
    },
    {
        name = "Hedge_Colored_Variance",
        label = "Enable Hedges Colors",
        hover = "Set to true for varied colored hedges",
        options = {
            {description = "Enabled", data = true},
            {description = "Disabled", data = false},
        },
        default = false,
    },
}