// 'mrop_setdelay'
//
// Rod of Metapreparations v.beta.96
// kevL
// 2016 sept 11
// A console script for players to check and/or change the Fast-cast delay.
// Usage at the console:
//
// `
// debugmode 1
// rs mrop_setdelay(fDelay)
// debugmode 0
// `
//
// - (float)fDelay is the new interval between fast-casts. Eg,
//   rs mrop_setdelay(0.5)
// - if fDelay is given a negative float value the current setting is returned
//   and the script simply exits.
// - note that 0.5 sec is the default that new Rods get when created.
//   Longer intervals help alleviate the "Persistent Haste" bug, while
//   shorter invervals will execute the Fastcast routine quicker.


#include "mrop_inc_const"

void main(float fDel)
{
	object oRod, oPC = OBJECT_SELF;

	object oParty = GetFirstFactionMember(oPC, FALSE);
	while (GetIsObjectValid(oParty))
	{
		oRod = GetItemPossessedBy(oParty, MROP_TAG_ROD);
		if (GetIsObjectValid(oRod))
		{
			float fDel_0 = GetLocalFloat(oRod, MROP_VAR_FAST_DELAY);
			SendMessageToPC(oPC, "_ MRoP : Fastcast delay is currently " + FloatToString(fDel_0));

			if (fDel >= 0.f) // float drift shouldn't be a problem here
			{
				SetLocalFloat(oRod, MROP_VAR_FAST_DELAY, fDel);
				SendMessageToPC(oPC, "_ MRoP : Fastcast delay has been set to " + FloatToString(fDel));
			}
			return;
		}
		oParty = GetNextFactionMember(oPC, FALSE);
	}

	SendMessageToPC(oPC, "ERROR : The MetaRod was not found in the Party.");
}
