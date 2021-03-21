//::///////////////////////////////////////////////
//:: Flesh to Stone
//:: x0_s0_fleshsto
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
//:: The target freezes in place, standing helpless.
//::
//:: Reeron modified on 3-3-07
//:: 
//:: Can't affect Constructs, Undead, or Incorporeal 
//:: creatures as per PnP rules. Both Undead and Constructs
//:: are immune to any effect that requires a fortitude save,
//:: unless the effect also works on objects or is harmless.
//:: Flesh to Stone fails this requirement because in it's
//:: description it states that it affects one creature 
//:: (not one object). Incorporeal creatures have no flesh.
//:: Sorry, no flesh no worky.
//:: 
//:: Reeron modified on 7-28-07
//:: Actually only modified x0_i0_spells so that the petrification
//:: effect is now Supernatural. This makes it so it can't be removed 
//:: by resting. Dispel Magic can't remove it anyway, so making it a
//:: Supernatural effect is ok.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: October 16, 2002
//:://////////////////////////////////////////////
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
	if(!GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL)&&!( GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD )&&!( GetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT ))
    { 
    if (MyResistSpell(OBJECT_SELF,oTarget) <1)
    {
       	DoPetrification(nCasterLvl, OBJECT_SELF, oTarget, GetSpellId(), GetSpellSaveDC());
		//effect eHit = EffectVisualEffect(VFX_HIT_SPELL_TRANSMUTATION);	// VFX are handled in DoPetrification()
		//ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
     }
  }	 
}