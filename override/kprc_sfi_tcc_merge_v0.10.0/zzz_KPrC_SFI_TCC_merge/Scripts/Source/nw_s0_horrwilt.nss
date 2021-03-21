//::///////////////////////////////////////////////
//:: Horrid Wilting
//:: NW_S0_HorrWilt
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All living creatures (not undead or constructs)
    suffer 1d6 damage per caster level to a maximum
    of 20d6 damage.
    
    Reeron modified on 5-10-07
    According to WoTC website it is not a 30' radius
    like a Fireball spell but it affects any living 
    creature that is within 60' of one another. This 
    acts like a 30' radius but since the spell description
    lists targets as "living creatures within 60' of each other",
    that should mean you are picking your targets. If you are, 
    then it is enemy only. Range was set to "Long" in Spells.2da.
    Water Elementals take d8 damage as per PnP rules.

    Reeron modified on 6-25-09
    Updated for patch 1.22.5588

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 12 , 2001
//:://////////////////////////////////////////////


// (Update JLR - OEI 07/22/05) -- Changed Dmg to 1d6 per lvl
// CGaw - OEI 6/26/06 -- Changed damage cap from 25d6 to 20d6


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
    object oCaster = OBJECT_SELF;
    int nCasterLvl = GetCasterLevel(oCaster);
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    float fDelay;
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);
    effect eDam;
    int nWe = 0; // Used for Water Elemental damage application. If nWe==1 apply d8 damage dice.
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();
    //Limit Caster level for the purposes of damage
    if (nCasterLvl > 20)
    {
        nCasterLvl = 20;
    }
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget); //COLOSSAL is 30' radius.
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        // GZ: Not much fun if the caster is always killing himself
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HORRID_WILTING));
            //Get the distance between the explosion and the target to calculate delay
            fDelay = GetRandomDelay(1.5, 2.5);
            if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
            {
                if(GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT && GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
                {
                    //Roll damage for each target
                    nDamage = d6(nCasterLvl);	// JLR - OEI 07/22/05 -- 3.5 Change
                    int nApp= GetAppearanceType(oTarget);
                    if(nApp==68 || nApp==69 || nApp==560 || nApp==561)// Water Elemantals
                        {
                        nDamage = d8(nCasterLvl); // Water Elementals take more damage.
                        nWe = 1; 
                        }
                    //Resolve metamagic
                    if (nMetaMagic == METAMAGIC_MAXIMIZE)
                    {
                        nDamage = 6 * nCasterLvl;
                        if (nWe==1)
                            {
                            nDamage = 8 * nCasterLvl; // Water Elementals take more damage.
                            }
                    }
                    else if (nMetaMagic == METAMAGIC_EMPOWER)
                    {
                       nDamage = nDamage + nDamage / 2;
                    }
                    if(/*Fort Save*/ MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
                    {
                        nDamage = nDamage/2;
                    }
                    //Set the damage effect
                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
                    // Apply effects to the currently selected target.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    //This visual effect is applied to the target object not the location as above.  This visual effect
                    //represents the flame that erupts on the target not on the ground.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
             }
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget);
    }
}