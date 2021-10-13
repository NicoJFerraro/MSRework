using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GlobalData 
{
    public static int towin = 1;
    public static int map = 1;
    public static int gamemode = 1;

    public static Weapons pj1;
    public static Weapons pj2;

    public static GameObject secondarypj1;
    public static GameObject secondarypj2;

    public static List<int> pjwpns =
        new List<int>() { 1, 2, 3, 1 };
    public static List<int> pjvehicles =
        new List<int>() { 1, 2, 1, 2 };




    //public static int[] playerWeapons = new int[4];
    //public static int[] playersVehicles = new int[4];
    //public static bool[] playersTeamBlue = new bool[4];

    public static int[] playerWeapons = { 3, 2, 3, 4 };
    public static int[] playersVehicles = { 1, 2, 2, 1 };
    public static bool[] playersTeamBlue = { true, false, true, false };

public static int[] playerrank = new int[4];
    public static int[] playerpoints = new int[4];
    public static int[] playerdeaths = new int[4];
    public static int[] playersds = new int[4];
    public static int[] playerdamage = new int[4];

}
