//\/////////////////////////////////////////////////////////////////////////////
//
//  tob_inc_metmag based on nwn2_inc_metmag.nss
//
//  Metamagic related utility functions for NWN2
//  These are not included in nwn_inc_spells, so that they can be added 
//  to older scripts
//
//  (c) Obsidian Entertainment Inc., 2005
//
//\/////////////////////////////////////////////////////////////////////////////
/*	Drammel's Note 2/4/2010: This is a copy of the original for use in the Tome of Battle.
	Using modified versions of the original files caues far too many compatibility issues,
	therefore a copy is made which is hooked into the relavent overriden files rather than
	the original.  Thus, I can use all the functionality of the original without worrying about
	recompiling errors into the original versions.
*/
// ChazM 7/24/07 - fix for no meta-magic feats - thanks to OVLD_NZ for pointing this out.


int tob_ApplyMetamagicVariableMods(int nVal, int nValMax);

float tob_ApplyMetamagicDurationMods(float fDuration);

int tob_ApplyMetamagicDurationTypeMods(int nDurType);


int tob_ApplyMetamagicVariableMods(int nVal, int nValMax)
{
    int nOrigVal = nVal;
    int nMetaMagic = GetMetaMagicFeat();
	
	// if no metamagic feats then don't go any further (or do any bitwise comparisons!)
	if(nMetaMagic==-1) 
		return nVal;
	
    // Need to handle Multiple Metamagics properly here, in case that gets supported in the GUI...
    if (nMetaMagic & METAMAGIC_MAXIMIZE)
    {
        nVal = nValMax;     // Ignore the rolled value, we are MAXED!
    }
    if (nMetaMagic & METAMAGIC_EMPOWER)
    {
        nVal += nOrigVal/2; // Add in 50%
    }
    return nVal;
}


float tob_ApplyMetamagicDurationMods(float fDuration)
{
    int nMetaMagic = GetMetaMagicFeat();
	
	// if no metamagic feats then don't go any further (or do any bitwise comparisons!)
	if(nMetaMagic==-1) 
		return fDuration;
	
    if (nMetaMagic & METAMAGIC_PERMANENT)
    {
        fDuration = 0.0;
    }
    else if (nMetaMagic & METAMAGIC_PERSISTENT)
    {
        fDuration = HoursToSeconds(24);
    }
    else if (nMetaMagic & METAMAGIC_EXTEND)
    {
        fDuration *= 2;
    }
    return fDuration;
}


int tob_ApplyMetamagicDurationTypeMods(int nDurType)
{
    int nMetaMagic = GetMetaMagicFeat();
	
	// if no metamagic feats then don't go any further (or do any bitwise comparisons!)
	if(nMetaMagic==-1) 
		return nDurType;

	
    if (nMetaMagic & METAMAGIC_PERMANENT)
    {
        nDurType = DURATION_TYPE_PERMANENT;
    }

    // Note: METAMAGIC_PERSISTENT & METAMAGIC_EXTEND don't affect this...

    return nDurType;
}