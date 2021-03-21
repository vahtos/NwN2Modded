//::///////////////////////////////////////////////
//:: Gust of Wind
//:: [x0_s0_gustwind.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spell creates a gust of wind in all directions
    around the target. All targets in a medium area will be
    affected:
    - Target must make a For save vs. spell DC or be
      knocked down for 3 rounds
    - plays a wind sound
    - if an area of effect object is within the area
    it is dispelled.
	
     Reeron modified on 4-4-07
     Now actually removes Fog Of Bewilderment.
     Now actually removes Choking Powder.
     Now working on Creeping Doom and Tenacious Plague.
     Dispels only the following AOE objects:
	 
    - Acid Fog
    - Choking Powder
    - Cloud of Bewilderment
    - Cloudkill
    - Creeping Doom
    - GhoulTouch
    - Incendiary Cloud
    - Mindfog
    - Stinking Cloud
    - StoneHold
    - Tenacious Plague
    
    Reeron modified on 8-15-07
    Changed from 40' diameter AOE to line shaped effect (have to use SpellCone instead).
    Changed from RADIUS_SIZED_HUGE to 18.288 meters (60 feet) as per PnP.
    Medium sized creature can't move towards the caster for 1 round (uses CutsceneImmobilize 
    to simulate this effect). Small or lesser sized creatures are knocked prone (EffectKnockdown) 
    for 1 round. This is as close to PnP as I can get for now. All creatures in the area of effect 
    suffer -4 to ranged attacks and listen checks for 1 round (duration of Gust of Wind) as per PnP.

    Reeron modified on 6-28-09
    Updated for patch 1.22.5588

*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 7, 2002
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
    object oCaster = OBJECT_SELF;
    int nCasterLvl = GetCasterLevel(oCaster);
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    float fDelay;
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_SONIC);
	string AOE;
   // effect eDam;
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();


    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 18.288, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_AREA_OF_EFFECT, GetPosition(oCaster));


    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
	if (GetHasSpellEffect(364, oTarget))//Creeping Doom
	{
    RemoveAnySpellEffects(364, oTarget); 
    }
    if (GetHasSpellEffect(835, oTarget))//Tenacious Plague
    {
    RemoveAnySpellEffects(835, oTarget); 
    }
        if (GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT)
        {
		 AOE = GetTag(oTarget);
           if (AOE == "AOE_ChokePowder_1" ||
               AOE == "VFX_PER_CREEPING_DOOM" ||		   
               AOE == "VFX_PER_FOGBEWILDERMENT" ||			   
               AOE == "VFX_PER_FOGACID" ||
               AOE == "VFX_PER_FOGFIRE" ||
               AOE == "VFX_PER_FOGGHOUL" ||
               AOE == "VFX_PER_FOGKILL" ||
               AOE == "VFX_PER_FOGMIND" ||
               AOE == "VFX_PER_FOGSTINK" ||
               AOE == "VFX_PER_STONEHOLD" ||
               AOE == "VFX_PER_TENACIOUS_PLAGUE")
            {
               DestroyObject(oTarget);
            }
           // DestroyObject(oTarget);
        }
        else
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    	{
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
                //Get the distance between the explosion and the target to calculate delay
                fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

                // * unlocked doors will reverse their open state
                if (GetObjectType(oTarget) == OBJECT_TYPE_DOOR)
                {
                    if (GetLocked(oTarget) == FALSE)
                    {
                        if (GetIsOpen(oTarget) == FALSE)
                        {
                            AssignCommand(oTarget, ActionOpenDoor(oTarget));
                        }
                        else
                            AssignCommand(oTarget, ActionCloseDoor(oTarget));
                    }
                }
                if(!MyResistSpell(OBJECT_SELF, oTarget) && !/*Fort Save*/ MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC()))
        	    {

                    effect eKnockdown = EffectKnockdown();
                    effect eRanged;
	                effect eCut = EffectCutsceneImmobilize();
	                effect eListen = EffectSkillDecrease(SKILL_LISTEN, 4);
                    object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND , oTarget);
                    object oItem2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND , oTarget);
                    if (GetWeaponRanged(oItem) || GetWeaponRanged(oItem2))
                    {
                    eRanged = EffectAttackDecrease(4);
                    }
                    else
                    {
                    eRanged = EffectAttackDecrease(0);
                    }
	                
	                effect eLink = EffectLinkEffects(eListen, eRanged);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1));
                    if (GetCreatureSize(oTarget)<=CREATURE_SIZE_MEDIUM)
                        {
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCut, oTarget, RoundsToSeconds(1));
                        }
                    if (GetCreatureSize(oTarget)<=CREATURE_SIZE_SMALL)
                        {
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, RoundsToSeconds(1));
                        }
                    //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, RoundsToSeconds(3));
                    // Apply effects to the currently selected target.
                 //   DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    //This visual effect is applied to the target object not the location as above.  This visual effect
                    //represents the flame that erupts on the target not on the ground.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    
                 }
             }
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 18.288, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE |OBJECT_TYPE_AREA_OF_EFFECT, GetPosition(oCaster));
    }
}