// 'i_mrop_page_ac'
//
// LostCreation
// Rod of Preparation
// Version 0.04 (preview 2):
// 2010 april 1
//
// kevL's, 2012 july 2
// MetaRod of Preparations
// v.beta.5
// v.beta.6, july 11
// v.beta.7, july 14
// v.beta.8, july 25
// ~ 2013 ~
// v.beta.93 april 20 - removed calls to 'x2_inc_switches'
// ~ 2016 ~
// v.beta.96 sept 9 - refactor.
// ~ 2020 ~
// v.beta.97a march 14 - reformat.
//
//
// Rod of Preparation - Item Activation Script
// -----------------------------------------------------
// This activation script will delete a Preparation Page.
// If NwN2-style tag-based scripts are enabled this script will be called when
// a Preparation Page is activated.


#include "mrop_inc_gui"

void main()
{
	object oPC   = GetItemActivator();
	object oPage = GetItemActivated();

	if (GetIsObjectValid(oPC) && GetIsObjectValid(oPage))
		ShowDeletePreparation(oPC, oPage);
}
