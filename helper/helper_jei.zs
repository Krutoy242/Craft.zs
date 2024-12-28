#modloaded jei

#priority -1

#reloadable

/*

Configure your tool, by giving yourself bone with NBT tag.
use command:

/give @p bone 1 0 {style: "tags with spaces between"}

Avaliable style tags:

comment       : Add recipe coment
noPretty      : No spaces in grid
noTrail       : No trailing comma in ingredients map
names         : Add item names in ingredient list (if not dense)
noBucket      : No transforming <forge:bucketfilled> into global Bucket()
dense         : Always pack recipe in one line
5x5           : For big chests (Like Draconium chest) use 5x5 grids
                instead default 3x3. This style working for any number,
                including 7x7 and 9x9

Style tags related to ingredients:

noForceAmount : Disable foce transforming ingredients based on their amount
noOre         : Not replace ingredients with OreDict entries
firstOre      : Only use first OreDict entry if there is many
noTransformers: No `.anyDamage()` or `.withTag({})` if ingredient
                can have damage or have default NBT tags

*/


val toolItem = itemUtils.getItem(scripts.craft.helper.helper.toolItemID);
mods.jei.JEI.addItem(toolItem.withTag({
  style: "comment noPretty noBucket noTrail names noTransformers noOre noForceAmount",

  ench:[{lvl:1,id:0}], // Add enchant glow
  enchantmentColor:16711680, // Random Things can change color with this tag
  display:{Name:"Bone §b(no styles)"},
}));