# Additional Support

Out of the box, `Craft.zs` provide support for several crafting methods.

- [Additional Support](#additional-support)
  - [ Arcane Workbench](#-arcane-workbench)
  - [ Crucible](#-crucible)
  - [ Runic Matrix](#-runic-matrix)
  - [ Blood Altair](#-blood-altair)
  - [ Thermionic Fabricator](#-thermionic-fabricator)
  - [ Carpenter](#-carpenter)








## ![](https://is.gd/rwdlH4 "Arcane Workbench") Arcane Workbench

<table>
<tr >
  <td style="min-width:200px">Layout:<img src="https://i.imgur.com/G2n2JxT.png"></td>
  <td rowspan=2>

```zs
# [Complex Arcane Mechanism] from [Nickel Plate][+5]
mods.thaumcraft.ArcaneWorkbench.removeRecipe(<thaumcraft:mechanism_complex>);
mods.thaumcraft.ArcaneWorkbench.registerShapedRecipe(
  "mechanism_complex", # Name
  "TWOND_BASE", # Research
  30, # Vis cost
  [<aspect:aqua>, <aspect:ignis>],
  <thaumcraft:mechanism_complex>, # Output
  Grid(["pretty",
  "  S  ",
  "‚ □ ‚",
  "  S  "], {
  "S": <thaumcraft:mechanism_simple>, # Simple Arcane Mechanism
  "‚": <ore:nuggetThaumium>,          # Thaumium Nugget
  "□": <ore:plateNickel>,             # Nickel Plate
}).shaped());
```

  </td>
</tr>
<tr><td>Result:<img src="https://i.imgur.com/sxCBPWu.png"></td></tr>
<tr>
  <td colspan=2>

- You can use any **Potentia**-stored item, such as ![](https://is.gd/h2suAr "Glass Phial") to set `Vis cost`.
- Any ![](https://is.gd/mMysWS "%s Vis Crystal") will be converted into aspect array

  </td>
  <td>
</tr>
</table>

## ![](https://is.gd/TQRbxa "Crucible") Crucible

<table>
<tr >
  <td style="min-width:200px">Layout:<img src="https://i.imgur.com/hn3OrpH.png"></td>
  <td rowspan=2>

```zs
# [Yellow Nitor]*10 from [Glowstone Dust][+3]
mods.thaumcraft.Crucible.removeRecipe(<thaumcraft:nitor_yellow>);
mods.thaumcraft.Crucible.registerRecipe(
  "nitor_yellow", # Name
  "BASEALCHEMY", # Research
  <thaumcraft:nitor_yellow> * 10, # Output
  <ore:dustGlowstone>, # Input
  [<aspect:potentia> * 10, <aspect:ignis> * 10, <aspect:lux> * 10]
);
```

  </td>
</tr>
<tr><td>Result:<img src="https://i.imgur.com/lO9uH8q.png"></td></tr>
<tr>
  <td colspan=2>

- You can use any **Vis-storing** item, such as ![](https://is.gd/h2suAr "Glass Phial"), ![](https://is.gd/mMysWS "%s Vis Crystal") or ![](https://is.gd/8F1En9 "Warded Jar") to set `aspects`.

  </td>
  <td>
</tr>
</table>

## ![](https://is.gd/e9guy0 "Runic Matrix") Runic Matrix

<table>
<tr >
  <td style="min-width:200px">Layout:<img src="https://i.imgur.com/26od7X5.png"></td>
  <td rowspan=2>

```zs
# [Adaminite Block] from [Mithrillium Block][+8]
mods.thaumcraft.Infusion.removeRecipe(<thaumadditions:adaminite_block>);
mods.thaumcraft.Infusion.registerRecipe(
  "thaumadditions:adaminite_block", # Name
  "INFUSION", # Research
  <thaumadditions:adaminite_block>, # Output
  15, # Instability
  [<aspect:infernum> * 200, <aspect:visum> * 200, <aspect:draco> * 200, <aspect:spiritus> * 200],
  <thaumadditions:mithrillium_block>, # Central Item
  Grid(["pretty",
  "▬ r ▬",
  "c   c",
  "▬ D ▬"], {
  "▬": <ore:ingotMithril>,                        # Mana Infused Ingot
  "r": <thaumcraft:primordial_pearl>.anyDamage(), # Primordial Pearl
  "c": <ore:carminite>,                           # Carminite
  "D": <thaumicwonders:disjunction_cloth>.anyDamage(), # Disjunction Cloth
}).spiral(1));
```

  </td>
</tr>
<tr><td>Result:<img src="https://i.imgur.com/eXmPZ6w.png"></td></tr>
<tr>
  <td colspan=2>

- You can use any **Vis-storing** item, such as ![](https://is.gd/h2suAr "Glass Phial"), ![](https://is.gd/mMysWS "%s Vis Crystal") or ![](https://is.gd/8F1En9 "Warded Jar") to set `aspects`.
- ![](https://is.gd/en0juB "Fibrous Taint") would be converted into **Instability** value.

  </td>
  <td>
</tr>
</table>

## ![](https://is.gd/bqGKt0 "Blood Altar") Blood Altair

<table>
<tr >
  <td style="min-width:200px">Layout:<img src="https://i.imgur.com/TndtScD.png"></td>
  <td rowspan=2>

```zs
# [Blood Wood] from [Universal Fluid Cell][+1]
mods.bloodmagic.BloodAltar.removeRecipe(<animus:blockbloodwood>);
mods.bloodmagic.BloodAltar.addRecipe(<animus:blockbloodwood>, <randomthings:spectrelog>, 0, 2000, 20, 40);
```

  </td>
</tr>
<tr><td>Result:<img src="https://i.imgur.com/FedWwx6.png"></td></tr>
<tr>
  <td colspan=2>

- ![](https://is.gd/dB1E54 "Universal Fluid Cell") with `Life Essence` will change required amount of blood.

  </td>
  <td>
</tr>
</table>

## ![](https://is.gd/GHcxlQ "Thermionic Fabricator") Thermionic Fabricator

<table>
<tr >
  <td style="min-width:200px">Layout:<img src="https://i.imgur.com/mG5D8CO.png"></td>
  <td rowspan=2>

```zs
# [Insulating Glass]*6 from [Cactus Green][+1]
mods.forestry.ThermionicFabricator.removeRecipe(<immersiveengineering:stone_decoration:8>);
mods.forestry.ThermionicFabricator.addCast(<immersiveengineering:stone_decoration:8> * 6, Grid(["▲d▲"], {
  "▲": <ore:dustIron>,             # Pulverized Iron
  "d": <ore:dye> | <ore:dyeGreen>, # Cactus Green
}).shaped(), <fluid:glass> * 1000, <forestry:wax_cast:*>);
```

  </td>
</tr>
<tr><td>Result:<img src="https://i.imgur.com/uWYnLEP.png"></td></tr>
<tr>
  <td colspan=2>

- Add ![](https://is.gd/4y9c6k "Wax Cast") to catalyst slot if you want to use it.

  </td>
  <td>
</tr>
</table>

## ![](https://is.gd/6lQbg1 "Carpenter") Carpenter

<table>
<tr >
  <td style="min-width:200px">Layout:<img src="https://i.imgur.com/X4JUOhi.png"></td>
  <td rowspan=2>

```zs
# [Overclocker Upgrade]*2 from [Electronic Circuit][+3]
mods.forestry.Carpenter.removeRecipe(<ic2:upgrade>);
mods.forestry.Carpenter.addRecipe(<ic2:upgrade> * 2, Grid(["pretty",
  "□ □ □",
  "C B C",
  "□ □ □"], {
  "□": <ore:plateTin>,        # Tin Plate
  "C": <ore:itemCopperCable>, # Copper Cable
  "B": <ore:circuitBasic>,    # Electronic Circuit
}).shaped(), 40, <fluid:ic2coolant> * 2000);
```

  </td>
</tr>
<tr><td>Result:<img src="https://i.imgur.com/ow3Q8II.png"></td></tr>
<tr>
  <td colspan=2>

- Set Fluid ingredient with ![](https://is.gd/dB1E54 "Universal Fluid Cell").

  </td>
  <td>
</tr>
</table>
