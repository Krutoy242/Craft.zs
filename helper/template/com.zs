/*

Some common functions used in Craft.zs Helpers Templates

*/
#priority 9

#loader crafttweaker reloadable

import crafttweaker.item.IItemStack;
import crafttweaker.liquid.ILiquidStack;
import crafttweaker.data.IData;
import scripts.craft.grid.Grid;
import crafttweaker.item.IIngredient;

// Function taken from
// https://github.com/Krutoy242/D.zs
static getD as function(IData,string,IData)IData= 
function(d as IData, path as string, def as IData = null) as IData {
  if (isNull(path) || path == "" || isNull(d)) return def;

  var descend as IData = null;
  for tag in path.split("[\\.\\[\\]]") {
    if (tag == "") continue;
    if(isNull(descend)) descend = d;

    var member as IData = null;
    if (tag.matches("\\d+")) {
      var num = tag as int;
      if (descend.length > num) member = descend[num];
    } else if(!isNull(descend.asMap())) {
      member = descend.memberGet(tag);
    }
    if (!isNull(member)) descend = member;
    else return def;
  }
  return descend;
};

function extractItem(grid as Grid, id as string, default as int = 0) as int {
  val extractFnc as function(IItemStack,IIngredient)string =
  function(item as IItemStack, ingr as IIngredient) as string {
    return item.definition.id == id ? ingr.amount~' ' : null;
  };
  val extracted = grid.extract(extractFnc);
  return extracted == ''
    ? default
    : extracted.replaceAll(' .*', '') as int;
}

function extractByTag(grid as Grid, keyPath as string, valuePath as string) as string {
  val extractFnc as function(IItemStack,IIngredient)string =
  function(item as IItemStack, ingr as IIngredient) as string {
    val key = getD(item.tag, keyPath, '').asString();
    if(key.length == 0) return null;
    val amount = getD(item.tag, valuePath, -1).asInt();
    if(amount == -1) return null;
    return key~':'~(ingr.amount * amount)~' ';
  };
  return grid.extract(extractFnc).trim();
}

function extractFluids(grid as Grid, default as string) as string {
  var result
    = extractByTag(grid, 'FluidName', 'Amount');
  if(result=='') result
    = extractByTag(grid, 'Fluid.FluidName', 'Fluid.Amount');

  return result=='' ? default : result;
}