# Craft.zs

A [ZenScript](https://docs.blamejared.com/) auxiliary scripts for quick recipe making.

<img src="https://i.imgur.com/yhmRZTM.gif">


---

- [Craft.zs](#craftzs)
  - [Installation](#installation)
  - [Usage](#usage)
  - [Usage Details](#usage-details)
    - [Lay out recipes](#lay-out-recipes)
    - [Bone right-click](#bone-right-click)
    - [Advanced Ingredients](#advanced-ingredients)
      - [Amount](#amount)
      - [Catalysts](#catalysts)
  - [Additional Support](#additional-support)
  - [API](#api)

---

## Installation

Drop content of this repo into your Minecraft 1.12 `scripts/craft/` folder.

**Extended Crafting** mod optional.


## Usage

1. Lay out your crafting recipes in an block inventory (![](https://git.io/Jsw8h "Draconium Chest") for example).
2. 3x3 for intup, output on the right.
3. Right-Click inventory with ![](https://is.gd/2E2P6L "Bone").
4. Code generated in `crafttweaker.log`.

<img src="https://i.imgur.com/e1hhHZc.png">

```zs
# [Piston] from [Copper Gear][+3]
craft.remake(<minecraft:piston> * 4, ["pretty",
  "# # #",
  "░ ¤ ░",
  "░ ♥ ░"], {
  "#": <ore:plankWood>,    # Oak Wood Planks
  "░": <ore:cobblestone>,  # Cobblestone
  "¤": <ore:gearCopper>,   # Copper Gear
  "♥": <ore:dustRedstone>, # Redstone
});

# [Chest]*2 from [Oak Wood]
craft.remake(<minecraft:chest> * 2, ["pretty",
  "# # #",
  "#   #",
  "# # #"], {
  "#": <ore:logWood>, # Oak Wood
});
```


## Usage Details

### Lay out recipes
To lay out recipes you can use **any 3x3 inventory** (like Crafting Station from Tinker's Construct), or table of any tier from **Extended Crafting**:

<img src="https://i.imgur.com/wI9vrn8.png">

In this case, put *output* in first player's slot.  
You can lay out several recipes at once in Chest / Crate from other mods, imaginary devide GUI grid by 4x3 rectarangles.  
List of valid inventories can be found in [recipeInventory.zs](helper/recipeInventory.zs).

<img src="https://i.imgur.com/WtiocV5.png" width="340">


### Bone right-click

You must be in creative `/gamemode 1` to use **Bone**.

**Bone** can be configured with NBT tags. See [helper_jei.zs](helper/helper_jei.zs).


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


### Advanced Ingredients

#### Amount

The **amount** of each ingredient affects its representation:  
  - 1 - Automatic replacement according to the **ore dictionary** (if not disabled by the style)
  - 2 - The item will be taken **"as is"**
  - 3 - Item will be **Wildcarded**

<img src="https://i.imgur.com/ehhpOWO.png" width="144">

```zs
craft.remake(<minecraft:planks> * 30, [
  "≢#≠"], {
  "≢": <ore:logWood>,       // Any Wood Log
  "#": <forestry:logs.1:3>, // Sequoia Wood
  "≠": <forestry:logs.1:*>, // Wildcarded Logs
});
```

#### Catalysts

Large inventories with 4x3 grids have two free slots. Place special items there to change the logic of crafting:
- ![](https://git.io/JRLyS "Glass Pane") - The recipe will be shapeless.
- ![](https://git.io/Ju5yy "Iron Nugget") - Added removal of old recipes by name.

<img src="https://i.imgur.com/vC0Y89r.png">

## Additional Support

Out of the box, `Craft.zs` provide support for several modded crafting methods:

- ![](https://is.gd/rwdlH4 "Arcane Workbench")![](https://is.gd/TQRbxa "Crucible")![](https://is.gd/e9guy0 "Runic Matrix")![](https://is.gd/bqGKt0 "Blood Altar")![](https://is.gd/GHcxlQ "Thermionic Fabricator")![](https://is.gd/6lQbg1 "Carpenter")

You can find how to use them [here](helper/template/readme_template.md).


## API

See [Advanced API](readme_adv.md) readme for using other functions.

Most common of them is using `Grid` - part of `Craft.zs` for generating arrays of ingredients.

```zs
Grid(["uw","wu"], {
  "w": <ore:plankTreatedWood>,
  "u": <ore:logWood>,
}).shaped();
// returns [
//   [<ore:logWood>, <ore:plankTreatedWood>],
//   [<ore:plankTreatedWood>, <ore:logWood>]
// ] as IIngredient[][]

Grid(["u  w  u"], {
  "w": <ore:plankTreatedWood>,
  "u": <ore:logWood>,
}).shapeless();
// returns [
//  <ore:logWood>, <ore:plankTreatedWood>, <ore:logWood>
// ] as IIngredient[]
```

<br>

