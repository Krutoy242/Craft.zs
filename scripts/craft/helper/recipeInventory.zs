import crafttweaker.item.IIngredient;
import crafttweaker.data.IData;
import scripts.craft.helper.gridRecipe.GridRecipe;
#priority 1


zenClass RecipeInventory {
  # Two values in array means recipes should be
  #   considering as bunch of recipes in one invernoty
  # String is RegExp. trailing ":0" is optional
  static blockSizes as int[][string] = {
    "extendedcrafting:table_advanced":            [5],
    "extendedcrafting:table_elite":               [7],
    "extendedcrafting:table_ultimate":            [9],
    "ironchest:iron_chest":                       [ 9, 6],
    "ironchest:iron_chest:1":                     [ 9, 9],
    "ironchest:iron_chest:(2|5|6)":               [12, 9],
    "draconicevolution:draconium_chest":          [26,10],
    "minecraft:chest.*":                          [ 9, 3],
    "rustic:vase.*":                              [ 9, 3],
    "rustic:cabinet.*":                           [ 9, 3],
    "bibliocraft:framedchest.*":                  [ 9, 3],
    "extrautils2:largishchest:3":                 [ 9, 3],
    "actuallyadditions:block_giant_chest":        [13, 9],
    "actuallyadditions:block_giant_chest_medium": [13,18],
    "actuallyadditions:block_giant_chest_large":  [13,27],
  } as int[][string];

  var W as int = 3;
  var H as int = 0;
  var gridRecipes as GridRecipe[] = [];

  zenConstructor(id as string, itemsList as IData) {
    # Find chest
    var sizeWH as int[] = null;
    for name, arr in blockSizes {
      if(id.matches(name ~ "(:0)?")) {
        sizeWH = arr;
        break;
      }
    }

    if(!isNull(sizeWH)) {
      W = sizeWH[0];
      if(sizeWH.length > 1) {
        # Init complex inventory with multiple recipes
        H = sizeWH[1];
        val netW = (W/4) as int;
        val netH = (H/3) as int;
        if(netW * netH > 1) {
          for j in 0 to (netW * netH) {
            addRecipe();
          }
        }
      }
    }
    addRecipe();

    for i, it in itemsList.asList() {
      processInventoryItem(i, it);
    }
  }

  function addRecipe() {
    val rg = GridRecipe();
    gridRecipes = gridRecipes + rg;
  }

  function processInventoryItem(index as int, it as IData) as void {
    if(isNull(it.asMap()) || isNull(it.id)) return;
    val slot = isNull(it.Slot) ? index : it.Slot.asInt();
    val slotData = getSlotData(slot);
    if(isNull(slotData)) return;

    val id     = it.id.asString();
    val count  = isNull(it.Count) ? 1 : it.Count.asInt();
    val damage = isNull(it.Damage) ? 0 : it.Damage.asInt();

    var itemStack = itemUtils.getItem(id, damage);
    if(isNull(itemStack)) return;
    itemStack = itemStack * count;
    if(!isNull(it.tag)) itemStack = itemStack.withTag(it.tag);

    val gridIndex = isNull(slotData.gridIndex) ? 0 : slotData.gridIndex.asInt();
    if(!isNull(slotData.isOutput)) {
      gridRecipes[gridIndex].setOutput(itemStack);
    } else {
      gridRecipes[gridIndex].gridBuilder.insert(
        itemStack, 
        isNull(slotData.slot) ? slot : slotData.slot.asInt(), 
        H>0?3:W);
    }
  }

  # Return type of this slot
  function getSlotData(slot as int) as IData {
    if(H==0) return {};

    val _x = slot % W;
    val gridWidth = (W / 4) as int;
    if(_x >= W - (W%4)) return null;

    val _y = (slot / W) as int;
    val netX = (_x/4) as int;
    val netY = (_y/3) as int;
    val gridIndex = netY * gridWidth + netX;

    val x = _x % 4;
    val y = _y % 3;
    if(x == 3) {
      if(y == 1) return {isOutput:true, gridIndex: gridIndex};
      else return null; # This item is out of "grid", invalid
    }
    return {gridIndex: gridIndex, slot: y*3+x};
  }

  function countActualRecipes() as int {
    var n = 0;
    for gridRecipe in gridRecipes {
      if(gridRecipe.haveData()) n += 1;
    }
    return n;
  }

  function toString(style as string[]) as string {
    var str as string[] = [];
    for gridRecipe in gridRecipes {
      val s = gridRecipe.toString(style);
      if(!isNull(s)) str += s;
    }

    return utils.join(str, style has "noFancy" ? "\n" : "\n\n");
  }
}
