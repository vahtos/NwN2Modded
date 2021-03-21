//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 7/30/2009									//
//	Title: st_disarming								//
//	Description: This maneuver allows you to combine//
//	a disarm attempt with a normal attack. You make //
//	a single melee attack as part of this strike. If//
//	this attack hits and deals damage, you can also //
//	attempt to disarm your opponent (PH 155). This 	//
//	disarm attempt does not provoke attacks of 		//
//	opportunity, nor is there any risk that your foe//
//  can disarm you.									//
//////////////////////////////////////////////////////

#include "bot9s_attack"
#include "bot9s_inc_maneuvers"
#include "bot9s_inc_variables"
#include "bot9s_include"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = GetManeuverObject(oToB, 80);

	if (NotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "IronHeartStrike", 1);
	DelayCommand(RoundsToSeconds(1), SetLocalInt(oToB, "IronHeartStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nHit = StrikeAttackRoll(oWeapon, oTarget);
	
	StrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
	WrapperPlayCustomAnimation(oPC, "*disarm", 0); 
	DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget));
	ExpendManeuver(80, "STR");

	if (nHit > 0) 
	{
		if (GetIsCreatureDisarmable(oTarget))
		{
			int nBonus, nFoeBonus;

			if (IsWeaponTwoHanded(oPC))
			{
				nBonus += 4;
			}
			else if (GetIsLightWeapon(oWeapon, oPC))
			{
				nBonus -= 4;
			}

			int nMySize = GetCreatureSize(oPC);
			int nFoeSize = GetCreatureSize(oTarget);

			if (nMySize > nFoeSize)
			{
				int nMult = nMySize - nFoeSize;
				nBonus += (4 * nMult);
			}
			else if (nMySize < nFoeSize)
			{
				int nMult = nFoeSize - nMySize;
				nFoeBonus += (4 * nMult);
			}

			object oFoeWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
			int nFoeAB = GetMaxAB(oTarget, oFoeWeapon, oPC);
			int nMyAB = GetMaxAB(oPC, oWeapon, oTarget);
			int nMyd20 = d20(1);
			int nFoed20 = d20(1);
			int nMyRoll = nMyd20 + nMyAB + nBonus;
			int nFoeRoll = nFoed20 + nFoeAB + nFoeBonus;

			SendMessageToPC(oPC, "<color=chocolate>Disarm: " + GetName(oPC) + " (" + IntToString(nMyd20) + " + " + IntToString(nMyAB) + " + " + IntToString(nBonus) + " = " + IntToString(nMyRoll) + ") vs. " + GetName(oTarget) + " (" + IntToString(nFoed20) + " + " + IntToString(nFoeAB) + " + " + IntToString(nFoeBonus) + " = " + IntToString(nFoeRoll) + ").</color>");

			if (nMyRoll >= nFoeRoll)
			{
				if (GetIsObjectValid(oWeapon))
				{
					AssignCommand(oTarget, ClearAllActions());
					AssignCommand(oTarget, ActionPutDownItem(oFoeWeapon));
				}
				else
				{
					object oDisarmed = CopyItem(oFoeWeapon, oPC, TRUE);
					DestroyObject(oFoeWeapon, 0.0f, FALSE);
					AssignCommand(oPC, ClearAllActions());
					AssignCommand(oPC, ClearStrikes());
					AssignCommand(oPC, ActionEquipItem(oDisarmed, INVENTORY_SLOT_RIGHTHAND));
				}
			}
		}
		else SendMessageToPC(oPC, "<color=red>It is impossible to disarm this creature!</color>");
	}
}