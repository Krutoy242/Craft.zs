#priority 5

#reloadable

#modloaded astralsorcery

import crafttweaker.item.IIngredient;
import crafttweaker.item.IItemStack;
import scripts.craft.helper.styler.styler;
import scripts.craft.grid.Grid;
import scripts.craft.helper.template.com.extractFluids;
import scripts.craft.helper.template.com.extractByTag;
import scripts.craft.helper.template.com.getOutputStrAnyAmount;

val fnc as function(IItemStack,Grid,string[])string = function(output as IItemStack, _grid as Grid, style as string[]) as string {
  if(!(
       style has 'astralsorcery:blockaltar'
    || style has 'astralsorcery:blockaltar:1'
    || style has 'astralsorcery:blockaltar:2'
    || style has 'astralsorcery:blockaltar:3'
  )) return null;

  val output_s_anyAmount = getOutputStrAnyAmount(output);

  val removedRecipeNames = styler.get(style, {
    removeByRecipeName: 'mods.astralsorcery.Altar.removeAltarRecipe("astralsorcery:insert_recipe_name_here");\n',
    }
  );

  var calledMethod = styler.get(style, {
    'astralsorcery:blockaltar'  : "mods.astralsorcery.Altar.addDiscoveryAltarRecipe",
    'astralsorcery:blockaltar:1': "mods.astralsorcery.Altar.addAttunementAltarRecipe",
    'astralsorcery:blockaltar:2': "mods.astralsorcery.Altar.addConstellationAltarRecipe",
    'astralsorcery:blockaltar:3': "mods.astralsorcery.Altar.addTraitAltarRecipe",
  });

  // Make shapeless
  var shapelessMap = '';
  for y, row in _grid.map {
    shapelessMap += row;
  }
  
  // [9,13,21,14,10,15,0,1,2,16,22,3,4,5,23,17,6,7,8,18,11,19,24,20,12]
  val rearrange = [6,7,8,11,12,13,16,17,18,0,4,20,24,1,3,5,9,15,19,21,23,2,10,14,22] as int[];
  var newMap = [] as string[];
  for y in 0 to 5 {
    var s = '';
    for x in 0 to 5 {
      val k = rearrange[y*5+x];
      if(shapelessMap.length > k)
        s += shapelessMap.substring(k, k+1);
    }
    newMap += s;
  }
  val grid = Grid(newMap, _grid.opts);

  val block = serializeAltair(style, output, grid, style has 'astralsorcery:blockaltar:3');

  return removedRecipeNames
    ~ calledMethod
    ~ "(" ~ block ~ ");";
};

styler.registerTemplate(fnc);


function serializeAltair(style as string[], output as IItemStack, grid as Grid, havConstellation as string) as string {
  val fluidAmount = extractFluids(grid, '1500').replaceAll('^[^:]+:(\\d+).*', '$1');
  val constellation = havConstellation ? ', "'~extractByTag(grid, 'astralsorcery.constellationName')~'"' : '';

  // Remove Pretty tag
  return  '\n'~
      '  "'~craft.uniqueRecipeName(output, grid)~'",\n'~
      '  '~serialize.IIngredient(output)~',\n'~
      '  '~fluidAmount~' /*Starlight*/, '~(fluidAmount as int)/10~' /*CraftTickTime*/,\n'~
      '  Grid('~grid.trim().toString(style + 'noPretty')
      
      // Shenanigans to make shapeless list
      .replaceAll(
        '"(.....)",\n\\s*"(.....)",\n\\s*"(.....)",\n\\s*"(.....)",\n\\s*"(.....)"',
        '"$1$2$3$4$5"'
      ).replaceAll(
        '"(...)(...)(...)(....)(........)(....)"',
        '"$1"+\n  "$2"+\n  "$3"+\n  "$4"+\n  "$5"+\n  "$6"'
      )~').shapeless(true)'~

      constellation;
}
