//::///////////////////////////////////////////////
//:: Color Spray
//:: NW_S0_ColSpray.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    A cone of sparkling lights flashes out in a cone
    from the casters hands affecting all those within
    the Area of Effect. 
	
    3-9-07 Reeron modified to PnP stats
	 
    
    Added effect eDispel to all linked effects (eSleep, eBlind, 
    and eStun) so that they are all dispelled on a failed save 
    versus Dispel Magic. Otherwise, some of the effects could remain 
    versus a failed save against Dispel Magic as they would be 
    seen as a separate spell.
    
    Reeron modified on 4-15-07
    Immunity to MindSpells was causing automatic failure of save
    and Blindness automatically being applied because of this. This 
    was fixed. Immunity to mindspells check was added.
    
    Reeron modified on 7-29-07
    Changed size of cone (in-script) to PnP correct 15'.
    
    Reeron modified on 1-24-08
    Immunity check, for Blindness, now takes into account Protection from Good/Evil.

    Reeron modified on 3-31-08
    No longer initiates a spell resistance check on the caster.

    Reeron modified on 6-15-09
    Updated for patch 1.22.5588

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 25, 2001
//:://////////////////////////////////////////////
//#include "NW_I0_SPELLS"
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 

int nDC= GetSpellSaveDC();

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
    int nMetaMagic = GetMetaMagicFeat();
    int nHD;
    int nSave;
    int nDuration;
    int nDuration2;
    int nDuration3;
    //int nDuration4;
    //int fDuration;
    float fDelay;
    float fMaxDelay = 0.0f; // Used to determine length of spell cone
    object oTarget;
    effect eSleep = EffectSleep();
    effect eStun = EffectStunned();
    effect eBlind = EffectBlindness();
    effect eCone = EffectVisualEffect(VFX_DUR_CONE_COLORSPRAY);

    //effect eLink2 = EffectLinkEffects(eStun, eSleep);

    //effect eLink3 = EffectLinkEffects(eBlind, eSleep);

    effect eHit = EffectVisualEffect(VFX_HIT_SPELL_ILLUSION);
    effect eDispel = EffectOnDispel(0.0f, RemoveEffectsFromSpell(oTarget, SPELL_COLOR_SPRAY));
    eSleep = EffectLinkEffects(eSleep, eDispel);
    eBlind = EffectLinkEffects(eBlind, eDispel);
    eStun = EffectLinkEffects(eStun, eDispel);    

    //Get first object in the spell cone
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 4.572, GetSpellTargetLocation(), TRUE);
    //Cycle through the target until the current object is invalid
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_COLOR_SPRAY));
            fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/30;
			if (fDelay > fMaxDelay)
			{
				fMaxDelay = fDelay;
			}
			
            if((oTarget != OBJECT_SELF) && !MyResistSpell(OBJECT_SELF, oTarget, fDelay))
            {
                // string feedback;
                 
                 //if (GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS))
                  {
                  //feedback="immune to mindspells";
                  //SendMessageToPC(oTarget, feedback);
                  }			
                //nSave = WillSave(oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF);
                if(!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, fDelay))
                //if (nSave==0)
                {
                  nDuration = d4(2);
                  nDuration3 = d4();
                  nDuration2 = nDuration3;
					  //fDuration=9;					  
					  //Enter Metamagic conditions
    		          /*if (nMetaMagic == METAMAGIC_MAXIMIZE)
    		          {
    			         nDuration = 7;//Damage is at max
    		          }
    		          else if (nMetaMagic == METAMAGIC_EMPOWER)
    		          {
    			         nDuration = nDuration + (nDuration/2); //Damage/Healing is +50%
    		          }
    		          else if (nMetaMagic == METAMAGIC_EXTEND)
    		          {
    			         nDuration = nDuration *2;	//Duration is +100%
						 //fDuration=18;
    		          }*/
					
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget));
                    nHD = GetHitDice(oTarget);
                    if(nHD <= 2)
                    {
                         //Apply the VFX impact and effects
                         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSleep, oTarget, RoundsToSeconds(nDuration)));
                         nDuration3+=nDuration;
                         if (!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, OBJECT_SELF))
                         {
                         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlind, oTarget, RoundsToSeconds(nDuration3)));
                         }
                         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, RoundsToSeconds(nDuration3+1)));
                    }
                    else if(nHD > 2 && nHD < 5)
                    {
                         //Apply the VFX impact and effects
                         if (!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, OBJECT_SELF))
                         {
                         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlind, oTarget, RoundsToSeconds(nDuration2)));
                         }
                         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, RoundsToSeconds(nDuration2+1)));                }
                    else
                    {
                         //Apply the VFX impact and effects	
						 			
                         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, 6.0));
                    }
                }
            }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 4.572, GetSpellTargetLocation(), TRUE);
    }
	fMaxDelay += 0.5f;
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCone, OBJECT_SELF, fMaxDelay);
}