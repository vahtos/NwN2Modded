//::///////////////////////////////////////////////
//:: Epic Dragon Breath
//:: NW_S1_DragLightn
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Calculates the proper damage and DC Save for the
    breath weapon based on the HD of the dragon.

    This spell is only intended to be used by the
    shifter's/druids dragon breath ability

    Druid's without at least 10 levels of shifter
    will do 4 dice damage less than a true shifter

    Green Dragon Gas also poisons the creatures
    to make up for its lower damage
    
    Reeron modified on 5-6-08
    Each target now has damage calculated individually.
    Now uses PnP correct DC calculation for breath weapon.
    Lightning breath weapon now shows visual effect.
    Size of breath weapon is based on the age and color of the dragon.
    Shape of breath weapon is based on dragon color. Red and Green 
    use a cone, while Blue uses a cylinder (line).

    Reeron modified on 6-28-09
    Updated for patch 1.22.5588

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-Oct-14
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"
#include "X0_i0_spells"
#include "x2_inc_shifter"
void main()
{
    int nAge;
    int nSpellId= GetSpellId();
    int nShape;
    float fLength = 4.572;// default
    int bShifter = (GetLevelByClass(CLASS_TYPE_SHIFTER,OBJECT_SELF)>=10);
    int bPoison = FALSE;
    int bIsDragon = FALSE;
    if (GetLevelByClass(CLASS_TYPE_DRAGON,OBJECT_SELF) > 0)
        {
        bIsDragon = TRUE;
        }

/* This totally doesn't work right, GetHasFeat has been incorrectly used.
   If this is the last use per day of Dragon Shape, GetHasFeat will return 0
   because it is no longer useable. Therefore, the damage calculation will be wrong.
    // -------------------------------------------------------------------------
    // We assume this spell is only used in dragon form
    // -------------------------------------------------------------------------
    if (GetHasFeat(873,OBJECT_SELF))
    {
        nAge = GetLevelByClass(CLASS_TYPE_DRUID,OBJECT_SELF) +  GetLevelByClass(CLASS_TYPE_SHIFTER,OBJECT_SELF);
    }
    // -------------------------------------------------------------------------
    // .. this case should never happen, but people do strange things with
    //    the toolset
    // -------------------------------------------------------------------------
    else if (GetIsPC(OBJECT_SELF))
    {
        nAge = GetHitDice(OBJECT_SELF)/2;
    }
    else
    {
        nAge = GetHitDice(OBJECT_SELF);
    }
*/
    // This should work better.
    nAge = GetLevelByClass(CLASS_TYPE_DRUID,OBJECT_SELF) +  GetLevelByClass(CLASS_TYPE_SHIFTER,OBJECT_SELF);
    // Just in case...
    if (nAge==0)
    {
        if (GetIsPC(OBJECT_SELF))
        {
            nAge = GetHitDice(OBJECT_SELF)/2;
        }
        else// Dragon companions fall into this category- Reeron.
        {
            nAge = GetHitDice(OBJECT_SELF);
        }
    }

    int nDice;
    int nDamage;
    int nDC;
    // -------------------------------------------------------------------------
    // Your damage dice and save DC are dependent on your hit dice
    // -------------------------------------------------------------------------
    if (nAge <= 6) //Wyrmling
    {
        nDice = 2;
        fLength = 6.096;// 20 feet
        if (nSpellId == 797) fLength = 9.144;// 30 feet for Red
    }
    else if (nAge >= 7 && nAge <= 9) //Very Young
    {
        nDice = 4;
        fLength = 9.144;// 30 feet
        if (nSpellId == 797) fLength = 12.192;// 40 feet for Red
    }
    else if (nAge >= 10 && nAge <= 12) //Young
    {
        nDice = 6;
        fLength = 9.144;// 30 feet
        if (nSpellId == 797) fLength = 12.192;// 40 feet for Red
    }
    else if (nAge >= 13 && nAge <= 15) //Juvenile
    {
        nDice = 8;
        fLength = 12.192;// 40 feet

    }
    else if (nAge >= 16 && nAge <= 18) //Young Adult
    {
        nDice = 10;
        fLength = 12.192;// 40 feet
        if (nSpellId == 797) fLength = 15.240;// 50 feet for Red
    }
    else if (nAge >= 19 && nAge <= 21) //Adult
    {
        nDice = 12;
        fLength = 15.240;// 50 feet
    }
    else if (nAge >= 22 && nAge <= 24) //Mature Adult
    {
        nDice = 14;
        fLength = 15.240;// 50 feet
    }
    else if (nAge >= 25 && nAge <= 27) //Old
    {
        nDice = 16;
        fLength = 15.240;// 50 feet
        if (nSpellId == 797) fLength = 18.288;// 60 feet for Red
    }
    else if (nAge >= 28 && nAge <= 30) //Very Old
    {
        nDice = 18;
        fLength = 15.240;// 50 feet
        if (nSpellId == 797) fLength = 18.288;// 60 feet for Red
    }
    else if (nAge >= 31 && nAge <= 33) //Ancient
    {
        nDice = 20;
        fLength = 18.288;// 60 feet
    }
    else if (nAge >= 34 && nAge <= 37) //Wyrm
    {
        nDice = 22;
        fLength = 18.288;// 60 feet
    }
    else
    {
        nDice = 24; // Great Wyrm
        fLength = 18.288;// 60 feet
        if (nSpellId == 797) fLength = 21.336;// 70 feet for Red
    }

    if (bIsDragon)
    {
        nDC = 10 + nAge/2 + GetAbilityModifier(ABILITY_CONSTITUTION, OBJECT_SELF);
    }
    else
    {
        nDC = ShifterGetSaveDC(OBJECT_SELF,SHIFTER_DC_NORMAL,TRUE);
    }

    if (!bShifter && !bIsDragon) // a shifter is a bit better at controlling this weapon
    {
       nDice -=4;
       nDC -=4;
    }

    int nVis;
    int nType;
    int nSave;

    if (nSpellId == 796) // lightning
    {
        nVis = VFX_IMP_LIGHTNING_S;
        nType = DAMAGE_TYPE_ELECTRICAL;
        nSave = SAVING_THROW_TYPE_ELECTRICITY;
        nShape = SHAPE_SPELLCYLINDER;
        fLength = 2.0 * fLength;// Line of electicity is double that of a fire/acid cone. 
        //nDamage = d8(nDice);
        //Get first target in spell area
        //effect eAcidBeam = EffectVisualEffect(VFX_BEAM_GREEN_DRAGON_ACID);
        effect eElectricBeam = EffectVisualEffect(VFX_BEAM_LIGHTNING);

	    location lNewLocation = GetAheadLocation(OBJECT_SELF, fLength);// Originates from dragon (OBJECT_SELF).
	    object oEndTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_ipoint ", lNewLocation);
	
	    DelayCommand(1.0f, DestroyObject(oEndTarget));
	
	    DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eElectricBeam, oEndTarget, 4.0f));
	

    }
    else if (nSpellId == 797) // fire
    {
        nVis = VFX_IMP_FLAME_M;
        nType = DAMAGE_TYPE_FIRE;
        nSave = SAVING_THROW_TYPE_FIRE;
        nShape = SHAPE_SPELLCONE;
        //nDamage = d10(nDice);
    }
    else //gas
    {
        nVis = VFX_IMP_ACID_L;
        //nVis = VFX_IMP_POISON_L;// Green dragons use acid, not poison.
        nType = DAMAGE_TYPE_ACID;
        nSave = SAVING_THROW_TYPE_ACID;
        nShape = SHAPE_SPELLCONE;
        //nDamage = d6(nDice);
        //bPoison = TRUE; // Green dragons only have an acid breath weapon.
    }

    effect eVis  = EffectVisualEffect(nVis);
    effect eDamage;
    effect ePoison;
    object oTarget;
    int nDamStrike;
    float fDelay;

     //------------------------------------------------------------------
    // Loop over all creatures, doors and placeables in the area of effect
    //------------------------------------------------------------------
    oTarget = GetFirstObjectInShape(nShape, fLength, GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));
    while (GetIsObjectValid(oTarget))
    {
        if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget,SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;

            //------------------------------------------------------------------
            // Calculate and Apply Reflex Save Adjusted Damage
            //------------------------------------------------------------------
            
            nDamage = d6(nDice);// Green by default
			
            if (nSpellId == 796)
            {
                nDamage = d8(nDice);// Blue
            }
            else if (nSpellId == 797)
            {
                nDamage = d10(nDice);// Red
            }
			
            nDamStrike = GetReflexAdjustedDamage(nDamage,oTarget, nDC,nSave, OBJECT_SELF);
            if(nDamStrike > 0)
            {

                eDamage = EffectDamage(nDamStrike, nType);
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));
            }

            //------------------------------------------------------------------
            // Green Dragon Breath is poisonous for creatures!
            // Reeron: No, it's not.
            //------------------------------------------------------------------
            if (bPoison && GetObjectType(oTarget) ==OBJECT_TYPE_CREATURE)
            {
               ePoison = EffectPoison(44);
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT,ePoison,oTarget));
            }
         }
        oTarget = GetNextObjectInShape(nShape, fLength, GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF) );
    }
}