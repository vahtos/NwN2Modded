//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 10/9/2009							//
//	Title: sa_aura_of_evil					//
//	Description: While you are in this      //
//  stance, you drain hit points from your  //
//  allies. Every turn, deal 2 points of    //
//  damage to each ally with more than 2 hit//
//  points that is within 10 feet. For each //
//  ally who takes this damage, you heal 1  //
//  point of damage.                        //
//////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_maneuvers"
		
void AuraOfTyranny(int bPlayerControlled)
{
	object oPC = OBJECT_SELF;

	if (ValidateStance(31))
	{
		effect eTyranny = EffectDamage(2, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL, TRUE);
		effect eHeal;
		object oParty;
		float fRange;
		int i;

		oParty = GetFirstFactionMember(oPC, bPlayerControlled); //I think PC in bPCOnly referrers to Player Controlled and not Player Character, based on my testing.
		i = 1;

		while (GetIsObjectValid(oParty))
		{
			fRange = FeetToMeters(10.0f);

			if ((oParty != oPC) && (GetDistanceBetween(oParty, oPC) - GetGirth(oParty) <= fRange))
			{
				eHeal = ManeuverHealing(oPC, 1);

				AssignCommand(oParty, ApplyEffectToObject(DURATION_TYPE_INSTANT, eTyranny, oParty));//Assigned to prevent faction issues from popping up.
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);
				i++;
			}

			if (i > 7)
			{
				break;
			}

			oParty = GetNextFactionMember(oPC, bPlayerControlled);
		}

		DelayCommand(6.0f, AuraOfTyranny(bPlayerControlled));
	}
	else DeleteLocalInt(oPC, "AuraOfTyranny");
}

void main()
{
	object oPC = OBJECT_SELF;
	effect eTriumph = EffectVisualEffect(VFX_TOB_TYRANNY);

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTriumph, oPC, 6.0f);
	AuraOfTyranny(FALSE);

	if (!GetIsSinglePlayer()) //Multiplayer Support
	{
		AssignCommand(oPC, AuraOfTyranny(TRUE));
	}
}