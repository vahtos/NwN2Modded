//::///////////////////////////////////////////////
//:: Scorching Ray
//:: [NX1_S0_scorchingraymany.nss]
//:: Copyright (c) 2007 Obsidian Ent.
//:://////////////////////////////////////////////
//:: Shoot a ray of fire at multiple targets.
//:: Targets must be within a 30ft circle.
//:: Rays shot simultaneously.
//::
//:: 1 Ray at level 3, 2 Rays at level 7, 3 Rays at level 11
//:: 
//:: Does 4d(6) damage
//:: 
//:: Reeron modified on 10-31-07
//:: Now respects immunity to criticals.
//:: 
//:: Reeron modified on 10-31-07
//:: Added check for Weapon finesse feat on all melee touch 
//:: attack spells. Added check for point blank shot feat on 
//:: all ranged touch attack spells.
//:: Added sneak attack damage.
//:: Now does extra damage if you have the (custom) feat 
//:: Ranged Spell Specialization.
//::
//:: Reeron modified on 5-4-09
//:: Updated for patch 1.22.5588
//::
//:://////////////////////////////////////////////
//:: Created By: Ryan Young
//:: Created On: 1.17.2007
//:://////////////////////////////////////////////

// Note: There is some tricky delay timing going on
// (see var fDelay).  All that's happening is that
// I'm delaying the all the special effects to coincide
// with the character's animation (arm extends, etc).

//::PKM-OEI: 05.29.07: Touch attacks now do critical hit damage
//:: -modernized metamagic behaviors

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "nwn2_inc_spells"
#include "Reeronspellinclude"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
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
	location lCaster = GetLocation( OBJECT_SELF );
	location lTarget = GetSpellTargetLocation();
	int nCasterLvl = GetCasterLevel(OBJECT_SELF);
	effect eRay = EffectBeam(VFX_BEAM_FIRE, OBJECT_SELF, BODY_NODE_HAND);
	effect eFire = EffectNWN2SpecialEffectFile("fx_ignition");
	int ni2=0;
	
	int nNumRays = 0;
	if (nCasterLvl >= 11)
		nNumRays = 3;			// 3 Rays @ lvl 11
	else if (nCasterLvl >= 7)
		nNumRays = 2;			// 2 Rays @ lvl 7
	else if (nCasterLvl >= 3)
		nNumRays = 1;			// 1 Ray  @ lvl 3
		
	int nEnemies = 0;
    object oTarget 	= OBJECT_INVALID;
    int nmodifyattack;
    int nSpecDamage =0;
    //nmodifyattack=FINESSE(oTarget);
    nmodifyattack=POINTBLANK(oTarget);

    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget) && nEnemies <= nNumRays )
    {
        // * caster cannot be harmed by this spell
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && (oTarget != OBJECT_SELF))
        {
            // * You can only fire missiles on visible targets
            if (GetObjectSeen(oTarget,OBJECT_SELF))
            {
                nEnemies++;
				//ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFire, oTarget, 2.5+(nNumRays-1));
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
     }

     // * Exit if no enemies to hit
     if (nEnemies == 0 || nNumRays==0) 
        return; 

     // divide the missles evenly amongst the enemies;
    int nRaysPerTarget	= nNumRays / nEnemies;
	int nExtraRays   	= nNumRays % nEnemies;
	
	
    //Cycle through the targets within the spell shape until an invalid object is captured.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
			//float fDelay = 2.5;
    while (GetIsObjectValid(oTarget))
    {
        // * caster cannot be harmed by this spell
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && (oTarget != OBJECT_SELF) && (GetObjectSeen(oTarget,OBJECT_SELF)))
        {
			int nRays = nRaysPerTarget;
			if (nExtraRays > 0) {
				nRays = nRays + 1;
				nExtraRays = nExtraRays - 1;
			}
			
			int ni=0;
			float fDelay = 0.75;
			
			//ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFire, oTarget, fDelay+(nRays-1));
			
			while (ni<nRays) {
				
		        //Fire cast spell at event for the specified target
		        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
				int nTouch      = TouchAttackRanged(oTarget,TRUE,nmodifyattack);
		 
				// Ray spells require a ranged touch attack
				if (nTouch != TOUCH_ATTACK_RESULT_MISS)
				{	//Make SR check
		        	if (!MyResistSpell(OBJECT_SELF, oTarget))
		        	{	
						int nDamage = d6(4);
						if(GetHasFeat(2991,OBJECT_SELF))
							{
							nSpecDamage=SPECIALIZATION(1);
							if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
							{
							nSpecDamage=SPECIALIZATION(2);
							}
							//FloatingTextStringOnCreature("*RangedTouchAttack modified by Ranged Spell Specialization!* Value of "+IntToString(nSpecDamage), OBJECT_SELF);
							}

					
						//Enter Metamagic conditions
		    			/*int nMetaMagic = GetMetaMagicFeat();
		                if (nMetaMagic == METAMAGIC_MAXIMIZE)
		                {
		                    nDamage = 6*4;
		                }
		                if (nMetaMagic == METAMAGIC_EMPOWER)
		                {
		                     nDamage = nDamage + (nDamage/2);
		                }
						*/
						nDamage = ApplyMetamagicVariableMods(nDamage, 24);
						
						
						if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
						{
							nDamage = d6(8);
							nDamage = ApplyMetamagicVariableMods(nDamage, 48);
							
						}
						if (ni2==0)
						{
						nDamage=SNEAK(oTarget, nDamage);
						nDamage+=nSpecDamage; // Can only do extra damage on first ray.
						ni2=1;// Don't want to do sneak damage on first ray on every target. Just first ray period.
						}

						//Set ability damage effect
		                effect eFireDamage = EffectDamage(nDamage, DAMAGE_TYPE_FIRE, DAMAGE_POWER_NORMAL, FALSE);
		  			    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
		                effect eLink = EffectLinkEffects(eFireDamage, eVis);
		
		                //Apply the ability damage effect and VFX impact
		                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));
					}
		        }
			   	DelayCommand((fDelay-0.5), ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 0.5));
				
				ni++;
				fDelay = fDelay + 1.6f;
				ni2=1; // Don't want to do sneak damage on first ray on every target. Just first ray period.
			}
			//ni2=1; // Don't want to do sneak damage on first ray on every target. Just first ray period.
        }
        //ni2=1; // Don't want to do sneak damage on first ray on every target. Just first ray period.
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }

	// If you want random selection of targets, and rays fired one right after the other instead
	// of all at the same time, use the code below.
	
	/*
	int nRaysLeft = nNumRays;
	float fDelay = 2.5;
	while (nRaysLeft > 0) {
		int nWhichEnemy = Random(nEnemies)-1;
    	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
		
		while (nWhichEnemy >= 0) {
    		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
			nWhichEnemy--;
		}
		if (GetIsObjectValid(oTarget) && spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && (oTarget != OBJECT_SELF) && (GetObjectSeen(oTarget,OBJECT_SELF)))
		{
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
		 
			// Ray spells require a ranged touch attack
			if (TouchAttackRanged(oTarget) != TOUCH_ATTACK_RESULT_MISS) 
			{	//Make SR check
	        	if (!MyResistSpell(OBJECT_SELF, oTarget))
	        	{	
					int nDamage = d6(4);
				
					//Enter Metamagic conditions
	    			int nMetaMagic = GetMetaMagicFeat();
	                if (nMetaMagic == METAMAGIC_MAXIMIZE)
	                {
	                    nDamage = 6*4;
	                }
	                if (nMetaMagic == METAMAGIC_EMPOWER)
	                {
	                     nDamage = nDamage + (nDamage/2);
	                }
					
	                //Set ability damage effect
	                effect eFireDamage = EffectDamage(nDamage, DAMAGE_TYPE_FIRE, DAMAGE_POWER_NORMAL, FALSE);
	  			    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
	                effect eLink = EffectLinkEffects(eFireDamage, eVis);
	
	                //Apply the ability damage effect and VFX impact
	                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));
				}
	        }
		   	DelayCommand((fDelay-0.5), ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 0.5));
		}
		fDelay = fDelay + 1.0;
		nRaysLeft--;
	}
	*/
}