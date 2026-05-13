/*

Some common functions used in Craft.zs Helpers Templates

*/
#priority 9

#reloadable

import crafttweaker.item.IItemStack;
import scripts.craft.grid.Grid;
import crafttweaker.item.IIngredient;

function extractItem(grid as Grid, id as string, default as int = 0) as int {
  val extractFnc as function(IItemStack,IIngredient)string
    = function (item as IItemStack, ingr as IIngredient) as string {
      return item.definition.id == id ? ingr.amount ~ ' ' : null;
    };
  val extracted = grid.extract(extractFnc);
  return extracted == ''
    ? default
    : extracted.replaceAll(' .*', '') as int;
}

function extractByTag(grid as Grid, keyAccessor as function(IItemStack)string, valueAccessor as function(IItemStack)int = null) as string {
  val valueAccessorExist = !isNull(valueAccessor);
  val extractFnc as function(IItemStack,IIngredient)string
    = function (item as IItemStack, ingr as IIngredient) as string {
    val key = keyAccessor(item);
      if (key.length == 0) return null;
      if (!valueAccessorExist) return key ~ ' ';

      val amount = valueAccessor(item);
      if (amount == -1) return null;
      return key ~ ':' ~ (ingr.amount * amount) ~ ' ';
    };
  return grid.extract(extractFnc).trim();
}

function extractFluids(grid as Grid, default as string) as string {
  // Helper accessors for fluid data
  val getFluidName = function (item as IItemStack) as string {
    return item.tag?.FluidName?.asString() ?? item.tag?.Fluid?.FluidName?.asString() ?? '';
  };
  val getAmount = function (item as IItemStack) as int {
    val amount = item.tag?.Amount?.asInt() ?? item.tag?.Fluid?.Amount?.asInt();
    return isNull(amount) ? -1 : amount;
  };

  val result = extractByTag(grid, getFluidName, getAmount);
  return result == '' ? default : result;
}

function getOutputStrAnyAmount(output as IItemStack) as string {
  return isNull(output) ? 'null' : serialize.IIngredient(output.anyAmount());
}
