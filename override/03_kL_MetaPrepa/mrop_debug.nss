// 'mrop_debug'
//
// kevL's 2013 april 26
// For debugging MRoP variables.

#include "mrop_inc_const"

object _oPcc = GetFirstPC(FALSE);


void main(int iCase, string sSpellhook, int bWildMagic)
{
	SendMessageToPC(_oPcc, "\nMRoP Debug :\n");

	switch (iCase)
	{
		case 0: // print vars
		{
			object oRod = GetObjectByTag(MROP_TAG_ROD);

			int bSetup = GetLocalInt(oRod, MROP_VAR_SETUP_COMPLETE);
			SendMessageToPC(_oPcc, "Rod : MROP_VAR_SETUP_COMPLETE = " + IntToString(bSetup));

			int bInstant = GetLocalInt(oRod, MROP_VAR_NOT_INSTANT);
			SendMessageToPC(_oPcc, "Rod : MROP_VAR_NOT_INSTANT = " + IntToString(bInstant) + "\n");


			object oModule = GetModule();

			int bMetaRoP = GetLocalInt(oModule, MROP_VAR_ACTIVE);
			SendMessageToPC(_oPcc, "Module : MROP_VAR_ACTIVE = " + IntToString(bMetaRoP));

			string sSpellhook = GetLocalString(oModule, MROP_VAR_SPELLHOOK);
			SendMessageToPC(_oPcc, "Module : MROP_VAR_SPELLHOOK = " + sSpellhook);

			string sSpellhook_orig = GetLocalString(oModule, MROP_VAR_SPELLHOOK_ORIG);
			SendMessageToPC(_oPcc, "Module : MROP_VAR_SPELLHOOK_ORIG = " + sSpellhook_orig);

			int bIntegrated = GetLocalInt(oModule, MROP_VAR_USEINTEGRATED);
			SendMessageToPC(_oPcc, "Module : MROP_VAR_USEINTEGRATED = " + IntToString(bIntegrated) + "\n");


			object oArea = GetArea(OBJECT_SELF);

			int bWildMagic = GetLocalInt(oArea, MROP_VAR_WILDMAGIC);
			SendMessageToPC(_oPcc, "Area : MROP_VAR_WILDMAGIC = " + IntToString(bWildMagic));

			int bWildMagic_orig = GetLocalInt(oArea, MROP_VAR_WILDMAGIC_ORIG);
			SendMessageToPC(_oPcc, "Area : MROP_VAR_WILDMAGIC_ORIG = " + IntToString(bWildMagic_orig) + "\n");
			break;
		}

		case 1: // set spellhook script
		{
			object oModule = GetModule();
			SetLocalString(oModule, MROP_VAR_SPELLHOOK, sSpellhook);
			break;
		}

		case 2: // set Wild Magic
		{
			object oArea = GetArea(OBJECT_SELF);
			SetLocalInt(oArea, MROP_VAR_WILDMAGIC, bWildMagic);
			break;
		}

		case 3: // set spellhook_original script
		{
			object oModule = GetModule();
			SetLocalString(oModule, MROP_VAR_SPELLHOOK_ORIG, sSpellhook);
			break;
		}

		case 4: // set Wild Magic_original
		{
			object oArea = GetArea(OBJECT_SELF);
			SetLocalInt(oArea, MROP_VAR_WILDMAGIC_ORIG, bWildMagic);
			break;
		}

		case 5: // delete all Vars.
		{
			object oRod = GetObjectByTag(MROP_TAG_ROD);

			DeleteLocalInt(oRod, MROP_VAR_SETUP_COMPLETE);
			DeleteLocalInt(oRod, MROP_VAR_NOT_INSTANT);


			object oModule = GetModule();

			DeleteLocalInt(oModule, MROP_VAR_ACTIVE);
			DeleteLocalString(oModule, MROP_VAR_SPELLHOOK);
			DeleteLocalString(oModule, MROP_VAR_SPELLHOOK_ORIG);
			DeleteLocalInt(oModule, MROP_VAR_USEINTEGRATED);


			object oArea = GetArea(OBJECT_SELF);

			DeleteLocalInt(oArea, MROP_VAR_WILDMAGIC);
			DeleteLocalInt(oArea, MROP_VAR_WILDMAGIC_ORIG);
			break;
		}
	}
}
