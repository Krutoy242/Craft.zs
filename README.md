# Craft.zs
A [ZenScript](https://docs.blamejared.com/) scripts for fancy working with Crafting Table recipes.

<img src="https://i.imgur.com/yhmRZTM.gif">


<br>
<br>


> ## Installation

Drop content of [scripts/](scripts/) into your Minecraft 1.12 `scripts/` folder.


### Installation details

1. Change scripts `#priority` if needed
2. Some scripts creating global variables. You should manually handle this if your scripts have globals with same name
   * global `serialize` - [serialize.zs](scripts/serialize.zs)
   * global `utils` - [utils.zs](scripts/utils.zs)
   * global `craft` - [craft.zs](scripts/craft/craft.zs)
3. [craft.zs](scripts/craft/craft.zs) have predefined code for mod `ExtendedCrafting`. If you haven't it, follow instructions in this file.


> ## Usage

1. In MC lay out your crafting recipe in an block inventory
2. Put recipe output in 1st player's inventory slot
3. Right-Click inventory with Feather
4. Generated code can be found in `crafttweaker.log` file

<img src="https://i.imgur.com/ImRljJB.png" height=170>
<img src="https://i.imgur.com/XrMUVis.png" height=170>

```zs
// [Piston*2] from [Iron_Plate][+3]
craft.remake(<minecraft:piston> * 2, ["pretty",
  "# # #",
  "░ I ░",
  "░ ♥ ░"], {
  "░": <ore:compressed1xCobblestone>, # Compressed Cobblestone
  "#": <ore:plankTreatedWood>,        # Treated Wood Planks
  "♥": <ore:dustRedstone>,            # Redstone
  "I": <ore:plateIron>                # Iron Plate
});
```


## Usage Details

### Lay out recipes
To lay out recipes you can use **any 3x3 inventory** (like Crafting Station from Tinker's Construct), or table of any tier from **Extended Crafting**:

<img src="https://i.imgur.com/wI9vrn8.png">


Also, you can lay out several recipes at once in Chest / Crate from other mods, imaginary devide GUI grid by 4x3 rectarangles.  
List of valid inventories can be found in [recipeInventory.zs](scripts/craft/helper/recipeInventory.zs)

<img src="https://i.imgur.com/WtiocV5.png" width="340">


### Feather right-click
You must be in creative `/gamemode 1` to use **Feather**.

Alternatively, you could use **Bone** or **Stick** to create recipes.

**Bone** would not include comments with item names
```zs
"▬": <extendedcrafting:material:36> # Ender Ingot
```
**Stick** would not add spaces between letters
```zs
# Feather:
"I ♥ Y"
"i F F"

# Stick:
"I♥Y"
"iFF"
```
<sub><sup>Note that spaced variant have `"pretty"` keyword as first element of string grid</sup></sub>


**Shift+RightClick** will merge inventory together, so they would use same items in recipes

```zs
val ingrs = {
  "p": <ore:pattern>,
  "≠": <ore:logWood>,
  "≢": <ore:stickWood>,
  "#": <ore:plankWood>,
  "w": <ore:workbench>
} as IIngredient[string];
  
craft.remake(<tconstruct:pattern> * 4, ["#≢", "≢#"], ingrs);
craft.remake(<tconstruct:tooltables:4>, ["###", "#p#", "###"], ingrs);
craft.remake(<thermalfoundation:upgrade:3>, ["## ", "##w"], ingrs);
craft.remake(<tconstruct:tooltables:1>, [" p", " #"], ingrs);
craft.remake(<conarm:armorstation>, [" p ", "pwp", " p "], ingrs);
craft.remake(<tconstruct:tooltables:2>, [" p", " ≠"], ingrs);
craft.remake(<tconstruct:tooltables>, ["w"], ingrs);
```

<br>

---

<br>

> ##  Methods

Using Feather to make recipes is just "helper". Some functions you can use manually in code.



### `craft.make`

> craft.make(output as `IItemStack`, gridStr as `string[]`, options as `IIngredient[string]`, [fnc as `IRecipeFunction`])

**Alias:** `craft.shaped`

Create new Crafting Table shaped recipe. 

Unique recipe name generated automatically.

This and all functions of `craft` is stable for any kind of wrong arguments. If you did a mistake, warning will be outputted in `crafttweaker.log` without an exception error.

**Parameters**
* `output` - Item that used as output
* `gridStr` - String array with letters represents ingredients. See rules and tricks at [Grid](#Grid) section.
* `options` - Map, where keys is letters from `gridStr` and values as input ingredients.
* `fnc` *optional* - Recipe Function that would be just transfered into vanilla `recipes.addShaped()` function

**Examples**
```zs
// Remove vanilla chest and add custom shaped recipe
recipes.remove(<minecraft:chest>);
craft.make(<minecraft:chest> * 2, [
  "uwu",
  "wBw",
  "uwu"], {
  "w": <ore:plankTreatedWood>,
  "B": <minecraft:stone_button>,
  "u": <ore:logWood>
});
```


### `craft.shapeless`

> craft.shapeless(output as `IItemStack`, gridStr as `string`, options as `IIngredient[string]`, [fnc as `IRecipeFunction`])

Same as `craft.make`, but shapeless

**Parameters**
* `gridStr` - `string` (!) instead of `string[]` unlike in `craft.make()`. Also can't use `"pretty"` keyword (See more: [Grid](#Grid))


**Examples**
```zs
craft.shapeless(<gendustry:pollen_kit> * 4, "AC-DC", {
	A: <forestry:crafting_material:2>,
	C: <gendustry:labware>,
	D: <ore:dustEmerald>
});
// Note that "-" character is not defined in options. It would be just omitted in resulting recipe
```



### `craft.remake`

> craft.remake(output as `IItemStack`, gridStr as `string[]`, options as `IIngredient[string]`, [fnc as `IRecipeFunction`])

**Alias:** `craft.reshaped`

Same as `craft.make`, but would remove old recipe first by calling
```zs
recipes.remove(output);
```

If `options` argument have field with key `"remove"`, value of this field would be removed instead.  
This is handy when you have different amount of items in vanilla recipe and new recipe. Or when output have different NBT.


**Examples**
```zs
# [Piston*2] from [Iron_Plate][+3]
craft.remake(<minecraft:piston> * 2, ["pretty",
  "# # #",
  "1 I 1",
  "1 ♥ 1"], {
  "1": <ore:compressed1xCobblestone>, # Compressed Cobblestone
  "#": <ore:plankTreatedWood>,        # Treated Wood Planks
  "♥": <ore:dustRedstone>,            # Redstone
  "I": <ore:plateIron>,               # Iron Plate
  remove: <minecraft:piston>
});
```


### `craft.reshapeless`

> craft.reshapeless(output as `IItemStack`, gridStr as `string`, options as `IIngredient[string]`, [fnc as `IRecipeFunction`])

Same as `craft.remake`, but shapeless

**Examples**
```zs
# Lesser blaze powder
craft.reshapeless(<minecraft:blaze_powder>, "A", { 
  A: <minecraft:blaze_rod>, 
  remove: <minecraft:blaze_powder> * 2
});
```













---

# Grid

**Grid** class - is where cool stuff happens.

Its receive an 2d list of string with 1 char keys and
map of key-Ingredient pairs.

Then it parsing input to generate `IIngredient[][]` array that can be used in vanilla `recipes.addShaped()` or modded crafting grids (like Astral Sorcery Altairs).

`Grid` is not a global so you should import it first
```zs
import scripts.craft.grid.Grid;
```




<br>

###  Constructor

> `Grid`(gridStr as `string[]`, options as `IIngredient[string]`)

Providing instance of `Grid` class. 

`gridStr` can be any size, not just 3x3.

Each string can be vary size too.

```zs
var grid = Grid([
  "-===-",
  "",
  "-===-"
], ingrs);
```

If the first element of `gridStr` is `"pretty"`, each even character would be ignored. This exists to make big grids looks prettier.  
Shortand for `"pretty"` is `"𝓹"`

```zs
var a = Grid([
  "𝓹",
  "* * *",
  "* * *"
], ingrs);

var b = Grid([
  "pretty",
  "*-*-*-",
  "*-*-*-"
], ingrs);

// ^ Both equal to >
var c = Grid([
  "***",
  "***"
], ingrs);
```





<br>

> ##  Grid Instance Fields



### `grid.error`

Type: `string`

Return error string if something wrong (for example if grid options have no keys listed in grid string array)

```zs
val grid = Grid([], {});

# Would print "Grid string have no elements"
if (!isNull(grid.error)) print(grid.error);
```


### `grid.X`
### `grid.Y`

Type: `int`

Maximum grid sizes by X (width) and Y (height).

<br>

> ##  Grid Instance Methods

<br>

### `grid.shaped`

> grid.shaped() as `IIngredient[][]`

Create an 2d array to use in shaped recipes.

If `gridStr` had spaces `" "`, they would be replaced to `null`s.

```zs
# Forestry's Carpenters accept this kind of array
mods.forestry.Carpenter.addRecipe(<forestry:letters>, Grid([
  "AAA",
  "AAA"], {
  A: <thermalfoundation:material:800>
}).shaped(), 40, <liquid:water> * 250);
```

```zs
# Can be used in Vanilla recipes too
recipes.addShaped(output, grid.shaped());
```


### `grid.shapeless`

> grid.shapeless() as `IIngredient[]`

Create an 1d array to use in shapeless recipes.

All spaces `" "` and wrong ingredients would be ignored, so resulted array never has `null`s.

```zs
recipes.addShapeless(output, grid.shapeless());
```

### `grid.getMainIngredient`

> grid.getMainIngredient() as `IIngredient`

Returns `IIngredient` that grid think most important in craft. Usually, its less used item, closest to center of grid.

```zs
# Returns ingrs.I
Grid(["###",
      "-I-",
      "-#-"
], ingrs).getMainIngredient();

# Returns ingrs.B
Grid(["AA",
      "AB"
], ingrs).getMainIngredient();
```

### `grid.toString`

> grid.toString([style as `string[]`]) as `string`

Return string representation of grid.


**Parameters**

`style` *optional* - array of keywords that control additional features:  
  - `"pretty"` - Would generate spaces between characters in grid string and adds `"pretty"` keyword. Ignored with `"dense"`
  - `"dense"` - No new lines would be added
  - `"fancy"` - Would add item names. Ignored with `"no_map"`
  - `"no_map"` - Instead of stringify both `gridStr` and `options`, only `gridStr` would be outputted


**Examples**

Note how command characters `╲` and `.` substituted into normal ingredient letters.  
More about command characters below.

```zs
val grid = Grid([
  "ABA",
  "╲C."], {
  A: <ore:logWood>,   # Oak Log
  B: <ore:plankWood>, # Oak Wood Planks
  C: <ore:ingotIron>  # Iron Ingot
});

grid.toString(["pretty", "fancy"]);
/* Outputs:
["pretty",
  "A B A",
  "B C B"], {
  "A": <ore:logWood>,   # Oak Log
  "B": <ore:plankWood>, # Oak Wood Planks
  "C": <ore:ingotIron>  # Iron Ingot
}
*/
```



<br>

> ## Advanced usage

String array can contain special characters that mirror ingredients in different axes.  
This can help when you building huge recipes manually and won't insert same letter 4 times for each side.

Remember: if command character would be used as key in `options`, it functionality would be ignored and would be used as regular character key.

- `" "` in string array means `null`
- `"."` try to find ingredients by mirroring, in order:
  1. By vertical axis **`←→`**  
      ```zs
      "   "    "   "
      "A ." => "A A"
      "   "    "   "
      ```
  2. By horisontal axis **`↕`**  
      ```zs
      " A "    " A "
      "   " => "   "
      " . "    " A "
      ```
  3. Both axis **`⮤⮧`**
      ```zs
      " A  "    " A  "
      "B   " => "B   "
      "   ."    "   B"
      "  . "    "  A "
      ```
- `"╲"` or `","` try to find ingredients by mirroring around `x=y` axis **`🡕🡗`**
  ```zs
  " A "    " A "
  "╲ ╲" => "A B"
  " B "    " B "
  ```

Real example from [Enigmatica2: Expert - Extended](https://github.com/Krutoy242/Enigmatica2Expert-Extended/blob/0c2cedfd20025fb6bf1b71fd26b8a7c4d215aa6a/scripts/Creative.zs#L455-L466):

<sub><sup>(some characters was replaced because i use "Fira Code" and github using "SFMono-Regular")</sup></sub>

```zs
# Mekanism Creative Energy
var creativeCube = <mekanism:energycube>.withTag({tier:4,mekData:{energyStored:1.7976931348623157E308}});
craft.make(creativeCube, ["pretty",
	"◘ ◘ ◙ ◙ τ . . . .",
	"◘ ◊ V □ □ . . . .",
	"Ψ V W ◽ ⁵ . . . .",
	"Ψ ⌂ ◽ ■ ☻ . . . .",
	"κ ⌂ ⁵ ⫲ X . . . .",
	". . . . . . . . .",
	". . . . . . . . .",
	". . . . . . . . .",
	". . . . . . . . ."], list);
```
<img src="https://i.imgur.com/ID1wbzO.gif" height=240>
