//////////////////////////////////////////
//	Author: Drammel						//
//	Date: 7/22/2009						//
//	Title:	bo_codeception				//
//	Description: When you initiate this //
//	maneuver, you turn invisible, as the//
//	greater invisibility spell			//
//////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_maneuvers"

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	
	if (GetLocalInt(oToB, "Swift") == 0)	
	{
		effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_IMPROVED);
		effect eInVis = EffectVisualEffect(VFX_TOB_FADE); // Doesn't play well with other effects in a link.
		effect eCover = EffectConcealment(50);
		effect eCloak = EffectLinkEffects(eInvis, eCover);
		eCloak = SupernaturalEffect(eCloak);
		eCloak = SetEffectSpellId(eCloak, 6551);

		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCloak, oPC, 6.0f);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInVis, oPC, 6.0f);
		RunSwiftAction(121, "B");
		ExpendManeuver(121, "B");
	}
}