//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 7/17/2009							//
//	Title: sa_isldoblds						//
//	Description: When you and an ally are	//
//	adjacent to a creature both of you		//
//	qualify for a flank against it.			//
//////////////////////////////////////////////

#include "bot9s_combat_overrides"
#include "bot9s_inc_maneuvers"
#include "bot9s_include"
		
void IslandOfBlades(int bPlayerControlled)
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");

	if (ValidateStance(129))
	{
		object oParty, oFoe;
		float fRange;
		int i;

		SetLocalInt(oPC, "IslandOfBlades", 1); // Status check to prevent extra callbacks of this function from running.

		oParty = GetFirstFactionMember(oPC, bPlayerControlled); //I think PC in bPCOnly referrers to Player Controlled and not Player Character, based on my testing.
		i = 1;

		while (GetIsObjectValid(oParty))
		{
			oFoe = GetAttackTarget(oParty);
			fRange = GetMeleeRange(oFoe);

			if ((oParty != oPC) && (GetDistanceBetween(oParty, oFoe) - GetGirth(oFoe) <= fRange) && (GetDistanceBetween(oPC, oFoe) - GetGirth(oFoe) <= fRange))
			{
				if (GetAttackTarget(oPC) == oFoe)
				{
					OverrideFlank(oPC);
					DelayCommand(6.0f, RemoveAttackRollOverride(oPC, 8));
				}

				OverrideFlank(oParty);
				DelayCommand(6.0f, RemoveAttackRollOverride(oParty, 8));
				SetLocalObject(oToB, "IoBParty" + IntToString(i), oParty);
				i++;
			}

			if (GetLocalInt(oParty, "IslandOfBlades") == 0) //In case more than one member of the party has this stance active.
			{
				DelayCommand(5.99f, ProtectedClearCombatOverrides(oParty));
			}

			oParty = GetNextFactionMember(oPC, bPlayerControlled);
		}

		if (GetLocalInt(oPC, "bot9s_overridestate") > 0)
		{
			//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
			//2 = Combat round is pending and the command has already been sent, do nothing.
		}
		else ManageCombatOverrides(TRUE); //Doesn't work when called from a loop and we're not checking too many variables.

		object oParty1 = GetLocalObject(oToB, "IoBParty1");

		if (GetIsObjectValid(oParty1))
		{
			if (GetLocalInt(oParty1, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else AssignCommand(oParty1, ManageCombatOverrides(TRUE));

			DeleteLocalObject(oToB, "IoBParty1");
		}

		object oParty2 = GetLocalObject(oToB, "IoBParty2");

		if (GetIsObjectValid(oParty2))
		{
			if (GetLocalInt(oParty2, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else AssignCommand(oParty2, ManageCombatOverrides(TRUE));

			DeleteLocalObject(oToB, "IoBParty2");
		}

		object oParty3 = GetLocalObject(oToB, "IoBParty3");

		if (GetIsObjectValid(oParty3))
		{
			if (GetLocalInt(oParty3, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else AssignCommand(oParty3, ManageCombatOverrides(TRUE));

			DeleteLocalObject(oToB, "IoBParty3");
		}

		object oParty4 = GetLocalObject(oToB, "IoBParty4");

		if (GetIsObjectValid(oParty4))
		{
			if (GetLocalInt(oParty4, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else AssignCommand(oParty4, ManageCombatOverrides(TRUE));

			DeleteLocalObject(oToB, "IoBParty4");
		}

		object oParty5 = GetLocalObject(oToB, "IoBParty5");

		if (GetIsObjectValid(oParty5))
		{
			if (GetLocalInt(oParty5, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else AssignCommand(oParty5, ManageCombatOverrides(TRUE));

			DeleteLocalObject(oToB, "IoBParty5");
		}

		object oParty6 = GetLocalObject(oToB, "IoBParty6");

		if (GetIsObjectValid(oParty6))
		{
			if (GetLocalInt(oParty6, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else AssignCommand(oParty6, ManageCombatOverrides(TRUE));

			DeleteLocalObject(oToB, "IoBParty6");
		}

		object oParty7 = GetLocalObject(oToB, "IoBParty7");

		if (GetIsObjectValid(oParty7))
		{
			if (GetLocalInt(oParty7, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else AssignCommand(oParty7, ManageCombatOverrides(TRUE));

			DeleteLocalObject(oToB, "IoBParty7");
		}

		DelayCommand(6.0f, IslandOfBlades(bPlayerControlled));
	}
	else
	{
		DeleteLocalInt(oPC, "IslandOfBlades");
		DeleteLocalObject(oToB, "IoBParty1");
		DeleteLocalObject(oToB, "IoBParty2");
		DeleteLocalObject(oToB, "IoBParty3");
		DeleteLocalObject(oToB, "IoBParty4");
		DeleteLocalObject(oToB, "IoBParty5");
		DeleteLocalObject(oToB, "IoBParty6");
		DeleteLocalObject(oToB, "IoBParty7");
		ProtectedClearCombatOverrides(oPC);
		RemoveAttackRollOverride(oPC, 8);
	}
}

void main()
{
	object oPC = OBJECT_SELF;

	if (GetLocalInt(oPC, "IslandOfBlades") == 0)
	{
		IslandOfBlades(FALSE);

		if (!GetIsSinglePlayer()) //Multiplayer Support
		{
			IslandOfBlades(TRUE);
		}
	}
}