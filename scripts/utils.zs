#priority 2009
import crafttweaker.item.IIngredient;


zenClass Utils {
	zenConstructor() { }

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


  function repeat(n as int) as string {return repeat(" ", n);}
  function repeat(s as string, n as int) as string {
    if(n<=0) return "";
    var str = "";
    for i in 0 to n {
      str += s;
    }
    return str;
  }

  function join(arr as string[]) as string { return join(arr, "\n"); }
  function join(arr as string[], delimiter as string) as string {
    var first = true;
    var s = "";
    for str in arr {
      val d = !first ? delimiter: "";
      first = false;
      s += d ~ str;
    }
    return s;
  }
}
global utils as Utils = Utils();
