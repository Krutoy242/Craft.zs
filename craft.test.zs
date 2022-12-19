/*

Craft.zs tests

Dev-only file. Please remove it.

*/

#norun

import crafttweaker.item.IIngredient;
import crafttweaker.item.IItemStack;
import crafttweaker.recipes.IRecipeFunction;
import scripts.craft.grid.Grid;
import scripts.craft.craft_extension.Extension;

logger.logError("craftzs_tests.zs is dev-only file. Please remove it.");

print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
print("~~~ Craft.zs Tests");
print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");



craft.remake(<minecraft:chest> * 4, ["pretty",
  "# # #",
  "#   #",
  "# # #"], {
  "#": <ore:logWood>,
});

# [Chest]*64 from [Oak Wood]
craft.remake(<minecraft:chest> * 64, ["pretty",
  "# # # # # # #",
  "#           #",
  "#           #",
  "#           #",
  "#           #",
  "#           #",
  "# # # # # # #"], {
  "#": <ore:logWood>, # Oak Wood
});

for i in 0 .. 5 {
  print("~~~~~~~~~~~~~~~~~~~~~~~~");
  print("~~ Test cycle #"~i);


  val output = itemUtils.getItem("minecraft:planks", i) * 4;
  val gridLine = serialize.repeat("ABC", i);
  val gridStr = [i%2==0?"pretty":"",serialize.repeat("AB C", i),"A   C","A B C"] as string[];
  val options = {"A": <ore:logWood>,"B": <ore:plankWood>.marked("m"),} as IIngredient[string];
  val fnc as IRecipeFunction = function(out, ins, cInfo) {print("~~ recipe function executed");return ins.m;};
  val isShapeless = i%2==0;
  val item = output | <minecraft:potion>.withTag({Potion: "minecraft:leaping"});
  val adsCount = 3;
  val ext = Extension(function (
    output as crafttweaker.item.IItemStack,
    recipeName as string,
    grid as scripts.craft.grid.Grid,
    recipeFunction as crafttweaker.recipes.IRecipeFunction,
    recipeAction as crafttweaker.recipes.IRecipeAction,
    isShapeless as bool
  ) as bool {print("~~ test extension checked"); return false;});
  val grid = Grid(gridStr, options);

  #------------------------------------------------------------------
  # Methods
  #------------------------------------------------------------------

  craft. shapeless(output, gridLine, options);
  craft. shapeless(output, gridLine, options, fnc);
  craft.    shaped(output, gridStr, options);
  craft.    shaped(output, gridStr, options, fnc);
  craft.      make(output, gridStr, options);
  craft.      make(output, gridStr, options, fnc);
  craft.      make(output, gridStr, options, fnc, isShapeless);

  craft. reshapeless(output, gridLine, options);
  craft. reshapeless(output, gridLine, options, fnc);
  craft.    reshaped(output, gridStr, options);
  craft.    reshaped(output, gridStr, options, fnc);
  craft.      remake(output, gridStr, options);
  craft.      remake(output, gridStr, options, fnc);
  craft.      remake(output, gridStr, options, fnc, isShapeless);


  print(craft. itemName(item));
  print(craft. itemCount(item));
  print(craft. itemSerialize(item));
  print(craft. recipeName(output, gridStr, options));
  print(craft. recipeName(output, grid));
  print(craft. recipeName(item, output, adsCount));
  print(craft. uniqueRecipeName(output, grid));

  craft. pushExtension(ext);



  #------------------------------------------------------------------
  # Grid
  #------------------------------------------------------------------
  val style as string[] = [];
  val c = "opt";
  print(serialize.IIngredient____(grid.shaped()));
  print(serialize.IIngredient__(grid.shapeless()));
  print(serialize.IIngredient(grid.getMainIngredient()));
  print(grid.toString());
  print(grid.toString(style));
  print(grid.hasOpt(c));
  print(grid.get(i+1, i*2));
  print(grid.getRaw(i+1, i*2));
  print(grid.getRaw(i+1, i*2, {a:false,A:true}));
  print(grid.isMapEmpty());
}


print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
print("~~~ End Of Tests");
print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");