Config = {}

Config.DropChance = 100

Config.MinDrops = 1 -- min/max amount of items dropped around the ped
Config.MaxDrops = 3

Config.DropRadius = 1.2 -- how far around the body props can spawn

Config.PropDespawnTime = 30000 -- despawn props after this time in miliseconds if not collected (set false to disable)

Config.PedBlacklist = {
    "a_c_boar",
    "a_c_cat_01",
    "a_c_chimp",
    "a_c_chop",
    "a_c_chop_02",
    "a_c_cormorant",
    "a_c_cow",
    "a_c_coyote",
    "a_c_crow",
    "a_c_deer",
    "a_c_dolphin",
    "a_c_fish",
    "a_c_hen",
    "a_c_humpback",
    "a_c_husky",
    "a_c_killerwhale",
    "a_c_mtlion",
    "a_c_pig",
    "a_c_pigeon",
    "a_c_poodle",
    "a_c_pug",
    "a_c_rabbit_01",
    "a_c_rat",
    "a_c_retriever",
    "a_c_rhesus",
    "a_c_rottweiler",
    "a_c_seagull",
    "a_c_sharkhammer",
    "a_c_sharktiger",
    "a_c_shepherd",
    "a_c_stingray",
    "a_c_westy"
    -- add more as needed

}

Config.Drops = {
    {
        prop = 'prop_cash_pile_02',
        label = 'Money',
        item = 'money',
        amount = {min = 10, max = 75}
    },
    {
        prop = 'prop_ld_health_pack',
        label = 'Med Kit',
        item = 'bandage',
        amount = {min = 1, max = 2}
    },
    {
        prop = 'hei_prop_heist_gold_bar',
        label = 'Gold',
        item = 'goldbar',
        amount = {min = 1, max = 3}
    }
}
