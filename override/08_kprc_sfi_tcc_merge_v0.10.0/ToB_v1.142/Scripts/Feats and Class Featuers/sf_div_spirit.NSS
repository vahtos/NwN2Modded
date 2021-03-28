//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 4/14/2009									//
//	Name: sf_div_spirit								//
//	Description: Expend a turn undead use while in	//
//	a Devoted Spirit Stance to regain 3 + CHA HP.	//
//////////////////////////////////////////////////////

#include "bot9s_inc_maneuvers"
#include "bot9s_inc_constants"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	
	if ((GetLocalInt(oToB, "Swift") == 0) && GetHasFeat(FEAT_TURN_UNDEAD))
	{
		int nStance = GetLocalInt(oToB, "Stance");
		int nStance2 = GetLocalInt(oToB, "Stance2");
	
		if (nStance == STANCE_AURA_OF_CHAOS || nStance2 == STANCE_AURA_OF_CHAOS
		|| nStance == STANCE_AURA_OF_PERFECT_ORDER || nStance2 == STANCE_AURA_OF_PERFECT_ORDER
		|| nStance == STANCE_AURA_OF_TRIUMPH || nStance2 == STANCE_AURA_OF_TRIUMPH
		|| nStance == STANCE_AURA_OF_TYRANNY || nStance2 == STANCE_AURA_OF_TYRANNY
		|| nStance == STANCE_IMMORTAL_FORTITUDE || nStance2 == STANCE_IMMORTAL_FORTITUDE
		|| nStance == STANCE_IRON_GUARDS_GLARE || nStance2 == STANCE_IRON_GUARDS_GLARE
		|| nStance == STANCE_MARTIAL_SPIRIT || nStance2 == STANCE_MARTIAL_SPIRIT
		|| nStance == STANCE_THICKET_OF_BLADES || nStance2 == STANCE_THICKET_OF_BLADES)
		{
			int nMyCHA;

			if (GetAbilityModifier(ABILITY_CHARISMA) < 1)
			{
				nMyCHA = 0;
			}
			else nMyCHA = GetAbilityModifier(ABILITY_CHARISMA);

			effect eHeal = EffectHeal(3 + nMyCHA);
			
			DecrementRemainingFeatUses(oPC, FEAT_TURN_UNDEAD);
			RunSwiftAction(214, "F");
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);
		}
	}
}