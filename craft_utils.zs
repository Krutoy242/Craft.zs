#priority 4000

#loader crafttweaker reloadable

import crafttweaker.item.IItemStack;

function sortInt(list as int[]) as int[] {
  if(isNull(list)) return null;
  if(list.length == 1) return [0];

  var sorted = [] as int[];
  for i in 0 to list.length {
    var g_v = 0;
    var g_i = i;
    for j in 0 to list.length {
      if(list[j] >= g_v && !(sorted has j)) {
        g_v = list[j];
        g_i = j;
      }
    }
    sorted += g_i;
  }
  return sorted;
}

# ########################
# Gets a Bucket Item from a Liquid String
# ########################
global Bucket as function(string)IItemStack = function (name as string) as IItemStack {
	//Unique Buckets
	if (isNull(name)) return <minecraft:bucket>;
	if (name == "lava")  return <minecraft:lava_bucket>;
	if (name == "water") return <minecraft:water_bucket>;
	if (name == "milk")  return <minecraft:milk_bucket>;

	return <forge:bucketfilled>.withTag({FluidName: name, Amount: 1000});
};

# ########################
# Gets a Book Item from a enchantment
# ########################
global Book as function(crafttweaker.enchantments.IEnchantmentDefinition)IItemStack =
function (ench as crafttweaker.enchantments.IEnchantmentDefinition) as IItemStack {
	return <minecraft:enchanted_book>.withTag({StoredEnchantments: [{lvl: 1 as short, id: ench.id as short}]});
};

# Apply tag to bucket (in case we use TE potions or such)
global BucketTag as function(string,crafttweaker.data.IData)IItemStack = function (name as string, tag as crafttweaker.data.IData) as IItemStack {
	val b = Bucket(name as string);
	if (!isNull(b) && !isNull(tag)) { return b.updateTag({Tag: tag}); }
	return b;
};

# ########################
# Get mob soul by its name
# ########################
global Soul as function(string)IItemStack = function (name as string) as IItemStack {
  val soul = itemUtils.getItem("draconicevolution:mob_soul");
  if (isNull(soul)) return <minecraft:spawn_egg>.withTag({EntityTag: {id: name}});
  return soul.withTag({EntityName: name});
};


# ########################
# Fluid Cell is like bucket, but stackable
# ########################
global FluidCell as function(string)IItemStack = function (name as string) as IItemStack {
	val cell = itemUtils.getItem('ic2:fluid_cell');
	if(isNull(cell)) return Bucket(name);
	return cell.withTag({Fluid: {FluidName: name, Amount: 1000}});
};