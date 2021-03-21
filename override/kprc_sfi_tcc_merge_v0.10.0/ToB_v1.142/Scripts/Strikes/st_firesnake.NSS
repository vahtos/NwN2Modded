//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 9/8/2009									//
//	Title: st_firesnake								//
//	Description: When you initiate this maneuver,   //
//  you cause a line of fire to twist across an area//
//  to burn your target and enemies in between.     //
//  Unlike a standard line, a firesnake can bend and//
//  twist to hit your foes. A firesnake starts in an//
//  adjacent square.  It can move out of your line  //
//  of sight or line of effect, but you gain no     //
//  special knowledge of the areas it moves into. If//
//  a firesnake moves into a creature's space, that //
//  creature takes 6d6 points of fire damage, with a//
//  Reflex save (DC 14 + your Wisdom modifier) for  //
//  half damage. A creature can only take damage    //
//  from the firesnake once in a single round.  The //
//  firesnake ends when it reaches its target or can//
//  no longer move towards its target.				//
//////////////////////////////////////////////////////

#include "bot9s_inc_maneuvers"
#include "bot9s_include"

void Firesnake(object oPC, object oTarget)
{
	object oFiresnake = GetObjectByTag(GetFirstName(oPC) + "c_firesnake");

	if (GetIsObjectValid(oFiresnake))
	{
		SetLocalObject(oFiresnake, "PC", oPC);
		SetLocalObject(oFiresnake, "Target", oTarget);
	}
	else DelayCommand(0.01f, Firesnake(oPC, oTarget));
}

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 11);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "DesertWindStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "DesertWindStrike", 0));

	float fDist = GetDistanceBetween(oPC, oTarget);

	if (fDist <= FeetToMeters(60.0f))
	{
		location lPC = GetLocation(oPC);
		object oFiresnake = CreateObject(OBJECT_TYPE_CREATURE, "c_firesnake", lPC, FALSE, GetFirstName(oPC) + "c_firesnake");

		Firesnake(oPC, oTarget); //Data enforcing function.
		WatchOpponent(oTarget, oPC);
		ExpendManeuver(11, "STR");
	}
	else SendMessageToPC(oPC, "<color=red>You must be within 60 feet of your target to initiate this maneuver.</color>");
}