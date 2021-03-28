//////////////////////////////////////////////////////////
//	Author: Drammel										//
//	Date: 9/1/2009										//
//	Title: sa_crushing_wotm								//
//	Description: While you are in this stance, you gain //
//  the ability to constrict for 2d6 points of damage + //
//  1-1/2 times your Str bonus (if any). You can        //
//  constrict an opponent that you grapple by making a  //
//  successful grapple check.							//
//////////////////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_maneuvers"
#include "bot9s_include"

void CrushingWeightOfTheMountain(object oPC, object oToB)
{
	if (ValidateStance(149))
	{
		object oTarget = IntToObject(GetLocalInt(oToB, "CrushingWotM"));
		float fDist = GetDistanceBetween(oPC, oTarget) - GetGirth(oTarget);
		float fRange = GetMeleeRange(oPC);
		int nTouch = TouchAttackMelee(oTarget, FALSE);

		if ((nTouch > 0) && (fDist <= fRange))
		{
			int nAbility = GetAbilityModifier(ABILITY_STRENGTH, oPC);
			int nFoeAbility = GetAbilityModifier(ABILITY_STRENGTH, oTarget);
			int nMySize = GetCreatureSize(oPC);
			int nFoeSize = GetCreatureSize(oTarget);
			int nBonus, nFoeBonus;
		
			if (nMySize > CREATURE_SIZE_MEDIUM)
			{
				nBonus += (nMySize - CREATURE_SIZE_MEDIUM) * 4;
			}
			else if (nMySize < CREATURE_SIZE_MEDIUM)
			{
				nBonus -= (CREATURE_SIZE_MEDIUM - nMySize) * 4;
			}
	
			if (nFoeSize > CREATURE_SIZE_MEDIUM)
			{
				nFoeBonus += (nFoeSize - CREATURE_SIZE_MEDIUM) * 4;
			}
			else if (nFoeSize < CREATURE_SIZE_MEDIUM)
			{
				nFoeBonus -= (CREATURE_SIZE_MEDIUM - nFoeSize) * 4;
			}

			int nMyBAB = GetTRUEBaseAttackBonus(oPC);
			int nFoeBAB = GetTRUEBaseAttackBonus(oTarget);
			int nMyd20 = d20(1);
			int nFoed20 = d20(1);
			int nMyRoll = nMyBAB + nAbility + nBonus + nMyd20;
			int nFoeRoll = nFoeBAB + nFoeAbility + nFoeBonus + nFoed20;
	
			if (nMyRoll >= nFoeRoll)
			{
				object oLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
				int nStr;

				if (!GetIsObjectValid(oLeft))
				{
					float fAbility = IntToFloat(nAbility);
					nStr = FloatToInt(1.5f * fAbility);
				}
				else nStr = nAbility;

				effect eDamage = EffectDamage(d6(2) + nStr, DAMAGE_TYPE_BLUDGEONING);
				effect eVis = EffectVisualEffect(VFX_TOB_CRUSHING_WOTM);

				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			}
		}
		DelayCommand(6.0f, CrushingWeightOfTheMountain(oPC, oToB));
	}
	else DeleteLocalInt(oToB, "CrushingWotM");
}

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = IntToObject(GetLocalInt(oToB, "Target"));

	SetLocalInt(oToB, "CrushingWotM", ObjectToInt(oTarget));

	if (GetIsReactionTypeHostile(oTarget, oPC))
	{
		CrushingWeightOfTheMountain(oPC, oToB);
	}
	else SendMessageToPC(oPC, "<color=red>You can only select a hostile enemy with this maneuver.</color>");
}