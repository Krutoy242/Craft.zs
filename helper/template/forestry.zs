#priority 5

#loader crafttweaker reloadable

#modloaded thaumcraft

import crafttweaker.item.IItemStack;
import scripts.craft.helper.styler.styler;
import scripts.craft.grid.Grid;
import scripts.craft.helper.template.com.extractItem;
import scripts.craft.helper.template.com.extractFluids;

// server.commandManager.executeCommand(server, '/say '~catl~' '~name);

val fnc as function(IItemStack,Grid,string[])string = function(output as IItemStack, grid as Grid, style as string[]) as string {
  val classMap = {
    "forestry:fabricator": "ThermionicFabricator",
    "forestry:carpenter": "Carpenter",
    // "forestry:centrifuge": "Centrifuge",
    // "forestry:fermenter": "Fermenter",
    // "forestry:squeezer": "Squeezer",
  } as string[string];

  var className as string = null;
  for catl, name in classMap {
    if(style has catl) {
      className = name;
      break;
    }
  }
  if(isNull(className)) return null;

  val output_s_one = isNull(output) ? "null" : serialize.IIngredient(output.anyAmount());
  val removed = "mods.forestry."~className~".removeRecipe("~output_s_one~");\n";

  var calledMethod = "mods.forestry." ~ className ~ (
    style has "forestry:fabricator" ? ".addCast" : ".addRecipe"
  );

  val output_s = serialize.IIngredient(output);
  val executionTime = extractItem(grid, 'minecraft:clock', 4) * 10;
  val fluid = extractFluids(grid, style has "forestry:carpenter" ? 'water:1000' : 'glass:1000');
  val block = output_s
    ~ ', Grid('~grid.trim().toString(style)~').shaped()'
    ~ (style has "forestry:carpenter" ? ', ' ~ executionTime : '')
    ~ ', ' ~ fluid.replaceAll('^([^:]+):(\\d+).*', '<fluid:$1> * $2')
    ~ (style has "forestry:wax_cast" ? ', <forestry:wax_cast:*>' : '')
  ;

  return removed ~ calledMethod ~ "(" ~ block ~ ");";
};

styler.registerTemplate(fnc);
