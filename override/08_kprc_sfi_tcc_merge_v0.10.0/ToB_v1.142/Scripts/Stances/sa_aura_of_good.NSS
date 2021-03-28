//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 10/8/2009							//
//	Title: sa_aura_of_good					//
//	Description: While you are in this      //
//  stance, you and any ally within 10 feet //
//  of you both heal 4 points of damage with//
//  each successful melee attack either of  //
//  you makes against an evil target.       //
//////////////////////////////////////////////

	/*The healing portion of this stance is handled in bot9s_inc_maneuvers
	under the functions DoAuraOfTriumph and StrikeWeaponDamage.  This script
	places combat overrides on the player and party memebers in order to take
	advantage of these functions.*/

#include "bot9s_combat_overrides"
#include "bot9s_inc_constants"
#include "bot9s_inc_maneuvers"
		
void AuraOfTriumph(int bPlayerControlled)
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");

	if (ValidateStance(30))
	{
		object oParty;
		float fRange;
		int i;

		SetLocalInt(oPC, "AuraOfTriumph", 1); // Status check to prevent extra callbacks of this function from running.

		oParty = GetFirstFactionMember(oPC, bPlayerControlled); //I think PC in bPCOnly referrers to Player Controlled and not Player Character, based on my testing.
		i = 1;

		while (GetIsObjectValid(oParty))
		{
			fRange = FeetToMeters(10.0f);

			if ((oParty != oPC) && (GetDistanceBetween(oParty, oPC) - GetGirth(oParty) <= fRange))
			{
				SetLocalInt(oParty, "ToB_Triumph", 1);
				AssignCommand(oParty, DelayCommand(6.0f, DeleteLocalInt(oParty, "ToB_Triumph")));
				SetLocalObject(oToB, "TriumphParty" + IntToString(i), oParty);
				i++;
			}

			if (GetLocalInt(oParty, "AuraOfTriumph") == 0) //In case more than one member of the party has this stance active.
			{
				DelayCommand(5.99f, ProtectedClearCombatOverrides(oParty));
			}

			if (i > 7)
			{
				break;
			}

			oParty = GetNextFactionMember(oPC, bPlayerControlled);
		}

		if (GetLocalInt(oPC, "bot9s_overridestate") > 0)
		{
			//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
			//2 = Combat round is pending and the command has already been sent, do nothing.
		}
		else ManageCombatOverrides(TRUE); //Doesn't work when called from a loop and we're not checking too many variables.

		object oParty1 = GetLocalObject(oToB, "TriumphParty1");

		if (GetIsObjectValid(oParty1))
		{
			if (GetLocalInt(oParty1, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else AssignCommand(oParty1, ManageCombatOverrides(TRUE));

			DelayCommand(5.95f, DeleteLocalObject(oToB, "TriumphParty1"));
		}

		object oParty2 = GetLocalObject(oToB, "TriumphParty2");

		if (GetIsObjectValid(oParty2))
		{
			if (GetLocalInt(oParty2, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else AssignCommand(oParty2, ManageCombatOverrides(TRUE));

			DelayCommand(5.95f, DeleteLocalObject(oToB, "TriumphParty2"));
		}

		object oParty3 = GetLocalObject(oToB, "TriumphParty3");

		if (GetIsObjectValid(oParty3))
		{
			if (GetLocalInt(oParty3, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else AssignCommand(oParty3, ManageCombatOverrides(TRUE));

			DelayCommand(5.95f, DeleteLocalObject(oToB, "TriumphParty3"));
		}

		object oParty4 = GetLocalObject(oToB, "TriumphParty4");

		if (GetIsObjectValid(oParty4))
		{
			if (GetLocalInt(oParty4, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else AssignCommand(oParty4, ManageCombatOverrides(TRUE));

			DelayCommand(5.95f, DeleteLocalObject(oToB, "TriumphParty4"));
		}

		object oParty5 = GetLocalObject(oToB, "TriumphParty5");

		if (GetIsObjectValid(oParty5))
		{
			if (GetLocalInt(oParty5, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else AssignCommand(oParty5, ManageCombatOverrides(TRUE));

			DelayCommand(5.95f, DeleteLocalObject(oToB, "TriumphParty5"));
		}

		object oParty6 = GetLocalObject(oToB, "TriumphParty6");

		if (GetIsObjectValid(oParty6))
		{
			if (GetLocalInt(oParty6, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else AssignCommand(oParty6, ManageCombatOverrides(TRUE));

			DelayCommand(5.95f, DeleteLocalObject(oToB, "TriumphParty6"));
		}

		object oParty7 = GetLocalObject(oToB, "TriumphParty7");

		if (GetIsObjectValid(oParty7))
		{
			if (GetLocalInt(oParty7, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else AssignCommand(oParty7, ManageCombatOverrides(TRUE));

			DelayCommand(5.95f, DeleteLocalObject(oToB, "TriumphParty7"));
		}

		DelayCommand(6.0f, AuraOfTriumph(bPlayerControlled));
	}
	else
	{
		DeleteLocalInt(oPC, "AuraOfTriumph");
		DeleteLocalObject(oToB, "TriumphParty1");
		DeleteLocalObject(oToB, "TriumphParty2");
		DeleteLocalObject(oToB, "TriumphParty3");
		DeleteLocalObject(oToB, "TriumphParty4");
		DeleteLocalObject(oToB, "TriumphParty5");
		DeleteLocalObject(oToB, "TriumphParty6");
		DeleteLocalObject(oToB, "TriumphParty7");
		ProtectedClearCombatOverrides(oPC);
	}
}

void main()
{
	object oPC = OBJECT_SELF;

	if (GetLocalInt(oPC, "AuraOfTriumph") == 0)
	{
		effect eTriumph = EffectVisualEffect(VFX_TOB_TRIUMPH);

		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTriumph, oPC, 6.0f);
		AuraOfTriumph(FALSE);

		if (!GetIsSinglePlayer()) //Multiplayer Support
		{
			AssignCommand(oPC, AuraOfTriumph(TRUE));
		}
	}
}