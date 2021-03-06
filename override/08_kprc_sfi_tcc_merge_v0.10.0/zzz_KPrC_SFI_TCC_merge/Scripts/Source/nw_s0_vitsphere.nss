//:://///////////////////////////////////////////////
//:: Vitriolic Sphere
//:: nw_s0_vitsphere.nss
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//::////////////////////////////////////////////////
//:: Created By: Brock Heinz
//:: Created On: 08/10/05
//::////////////////////////////////////////////////
/*
        5.1.5.4.6	Vitriolic Sphere (B)
        E-mail from WotC, up-coming Complete Arcane
        School:		    Conjuration (Creation) [Acid]
        Components: 	Verbal, Somatic
        Range:		    Long
        Target:		    10 ft. radius burst
        Duration:		Instantaneous
        Saving Throw:	Reflex half
        Spell Resist:	Yes

        You conjure a sphere of sizzling emerald acid that streams towards the 
        target and explodes. Everything within the area of affect is drenched 
        with a potent acid that deals 1d4 points of acid damage per caster level 
        (maximum 15d4). Any creature who fails their Reflex save is subject to 
        continuing acid damage in subsequent rounds. On the second round, the 
        acid deals 6d4 damage (Reflex half); on the third round, it deals 3d4 
        damage (Reflex half); and on the fourth round it deals no more damage. 
        Once an affected creature succeeds on a Reflex save, it suffers no more 
        continuing damage.

        [Art] An emerald acid ball needs to fly to the target and explode. If 
        it could sizzle and sound like Alien type of acid burning in the area 
        that would be great.

*/
//
//      Reeron modified on 3-31-07
//      Correctly applies full damage in 1st round no matter what. Made save means 
//      no further damage. Failed save in round 1 means further damage in round 2.
//      Made save in round 2 results in 1/2 damage (or less- takes into account
//      Evasion and Improved Evasion) and no further damage.
//      Failed save in round 2 results in damage (Takes into account Improved Evasion)
//      and a 3rd round of possible damage. Round 3 takes into account Evasion and
//      Improved Evasion. Metamagic variable properly stored for future callbacks so 
//      casting another metamagically enhanced spell will not apply new metamagic to this spell.
//
//
//      Reeron modified on 5-4-09
//      Updated for patch 1.22.5588


// JLR - OEI 08/23/05 -- Metamagic changes
#include "nwn2_inc_spells"


#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "x2_i0_spells"

const float SPELL_EFFECT_RADIUS = 3.048;
const float DELAY_ONE_ROUND     = 6.0f;
//int nDamage2 = ApplyMetamagicVariableMods( d4(6), 24 );// 2nd round of damage if necessary
//int nDamage3 = ApplyMetamagicVariableMods( d4(3), 12 );// 3rd round of damage if necessary


void DamageVictim(int nDice, object oVictim, object oCaster, int nSpellSaveDC )//Made save so no further damage after first round.
{
	
	// Returns: 2 if the target was immune to the save type specified
    //int nSave = ReflexSave( oVictim, nSpellSaveDC, SAVING_THROW_TYPE_ACID, oCaster );

    SignalEvent(oVictim, EventSpellCastAt(oCaster, SPELL_VITRIOLIC_SPHERE));

    
    {
        int nDamage = d4(nDice);

		int nMaxVal = nDice * 4; // nDice * d4

        //Resolve metamagic
        nDamage = ApplyMetamagicVariableMods( nDamage, nMaxVal );   		

		// A successful saving throw results in half damage
		          

        effect eVisual = EffectVisualEffect(VFX_HIT_SPELL_ACID);
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVisual, oVictim );        

        effect eDamage  = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oVictim );
    }

}
void DamageVictim1(int nDice, object oVictim, object oCaster, int nSpellSaveDC )//Failed 1st save so there will be damage after first round.
{
	
	// Returns: 2 if the target was immune to the save type specified
    //int nSave = ReflexSave( oVictim, nSpellSaveDC, SAVING_THROW_TYPE_ACID, oCaster );

    SignalEvent(oVictim, EventSpellCastAt(oCaster, SPELL_VITRIOLIC_SPHERE));

    
    {
        int nDamage = d4(nDice);

		int nMaxVal = nDice * 4; // nDice * d4

        //Resolve metamagic
        nDamage = ApplyMetamagicVariableMods( nDamage, nMaxVal );   		

		// A successful saving throw results in half damage
		          

        effect eVisual = EffectVisualEffect(VFX_HIT_SPELL_ACID);
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVisual, oVictim );        

        effect eDamage  = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oVictim );
                
    }

}
void DamageVictim2(int nDice, object oVictim, object oCaster, int nSpellSaveDC, int nMetaMagic )// 2nd round of damage. Try for save for 1/2 and no further damage.
{
	// Returns: 0 if the saving throw roll failed
	// Returns: 1 if the saving throw roll succeeded
	// Returns: 2 if the target was immune to the save type specified
    int nSave = ReflexSave( oVictim, nSpellSaveDC, SAVING_THROW_TYPE_ACID, oCaster );
    int save2 = 0;

    SignalEvent(oVictim, EventSpellCastAt(oCaster, SPELL_VITRIOLIC_SPHERE));

    if ( nSave != 2 )
    {
        int nDamage = d4(nDice);

		int nMaxVal = nDice * 4; // nDice * d4

        //Resolve metamagics. Can't use original way in 2nd and 3rd rounds. This is a slight fudge but it works perfectly.
        if (nMetaMagic == METAMAGIC_MAXIMIZE)
        {
            nDamage = nMaxVal;
        }
        if (nMetaMagic == METAMAGIC_EMPOWER)
        {
            nDamage = nDamage + (nDamage/2);
        }  		

		// A successful saving throw results in half damage and no further rounds of damage.
		if ( nSave == 1 )
			{
             nDamage = nDamage / 2;
             save2 =1 ;// This tells script not to run round 3 if nDice=6.
            if (GetHasFeat(FEAT_EVASION, oVictim) || GetHasFeat(FEAT_IMPROVED_EVASION, oVictim))
             {nDamage = 0;}
		    }  
        if ( nSave == 0 )
        {
            if (GetHasFeat(FEAT_IMPROVED_EVASION, oVictim))
               {nDamage = nDamage / 2;}
        }
        if (nDamage > 0)
        {
        effect eVisual = EffectVisualEffect(VFX_HIT_SPELL_ACID);
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVisual, oVictim );        

        effect eDamage  = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oVictim );
        }
		
        if ((save2 == 0) && (nDice==6))
        {
         	DelayCommand( 6.0, DamageVictim2(3, oVictim, oCaster, nSpellSaveDC, nMetaMagic ) );
        }
    }

}


void RunRecurringEffects( location lTarget, object oCaster, int nCasterLevel, int nSpellSaveDC, int nRound )
{
	int nDice = 0;
	
/*	switch ( nRound )
	{
		case 1: 	if ( nCasterLevel > 15 )	nDice = 15;
					else						nDice = nCasterLevel;
		break;

		case 2:		nDice = 6; 
		break;

		case 3:		nDice = 3; 
		break;
	}
	*/
	
	if (nCasterLevel > 15)
	{
		nDice = 15;
	}
	else
	{
		nDice = nCasterLevel;
	}

	if ( nDice == 0 )
	{
		return; // WTF?
	}
    int nMetaMagic = GetMetaMagicFeat();
	
    object oVictim = GetFirstObjectInShape(SHAPE_SPHERE, SPELL_EFFECT_RADIUS, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE );

    while ( GetIsObjectValid(oVictim) )
    {
        if ( spellsIsTarget( oVictim, SPELL_TARGET_STANDARDHOSTILE, oCaster) )
		//if (GetIsReactionTypeFriendly(oVictim) == FALSE)
        {
			// Add a delay to the damage done to nearby victims, based on their
			// distance from the target.
            float fDistance = GetDistanceBetweenLocations( lTarget, GetLocation(oVictim) );
			float fDelay = 0.15f * fDistance;
			if ( fDelay > 1.0f )  // clamp it.. (it would be nice if this were a curve, but..)
			{
				fDelay = 1.0f;
			}
            int nSave = ReflexSave( oVictim, nSpellSaveDC, SAVING_THROW_TYPE_ACID, oCaster );
			if ( nSave == 1 )//  Made initial save then only 1 round of full damage.
			{
				DamageVictim( nDice, oVictim, oCaster, nSpellSaveDC );
			}
			else// Failed first save then 1 round of full damage and try for save in 2nd round for half damage....
			{
				DelayCommand( 0.0, 	DamageVictim1( nDice, oVictim, oCaster, nSpellSaveDC ) );
				DelayCommand( 6.0, 	DamageVictim2( 6,oVictim, oCaster, nSpellSaveDC, nMetaMagic ) );// 6hd
				//DelayCommand( 12.0, DamageVictim3( 3, oVictim, oCaster, nSpellSaveDC ) );// 3hd
			}


			//DelayCommand(fDelay, DamageVictim( nDice, oVictim, oCaster, nSpellSaveDC ) );

        }

        oVictim = GetNextObjectInShape(SHAPE_SPHERE, SPELL_EFFECT_RADIUS, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE );
    }
	

/*	if ( nRound < 3 ) //|| 1rst = 0
	{
		// Que the effect to fire again.... 
        DelayCommand( DELAY_ONE_ROUND, RunRecurringEffects( lTarget, oCaster, nCasterLevel, nSpellSaveDC, nRound+1) );
	}
*/
}

void main()
{
	// uncomment for debugging.. 
	//SpawnScriptDebugger();
    

    //--------------------------------------------------------------------------
    // Spellcast Hook Code
    // If you want to make changes to all spells, check x2_inc_spellhook.nss to
    // find out more
    //--------------------------------------------------------------------------
    if (!X2PreSpellCastCode())
    {
        return;
    }
    // End of Spell Cast Hook


    //--------------------------------------------------------------------------
    // Get the dependent info
	// Some things (caster level, save DC), will not be valid after a delay
    //--------------------------------------------------------------------------
    object oCaster   = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();
	int nSpellSaveDC = GetSpellSaveDC();
	int nCasterLevel = GetCasterLevel(oCaster); 
    
	
	RunRecurringEffects( lTarget, oCaster, nCasterLevel, nSpellSaveDC, 1 );


}