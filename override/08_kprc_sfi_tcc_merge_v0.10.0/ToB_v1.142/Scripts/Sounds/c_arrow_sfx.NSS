//////////////////////////////////////////
//  Author: Drammel						//
//  Date: 3/11/2009						//
//  Title: c_arrow_sfx					//
//  Description: Creates an intangible	//
//	creature which can run sounds that	//
//	simulate the results of an attack	//
//	roll for a strike maneuver.			//
//////////////////////////////////////////

void main()
{
	object oMe = OBJECT_SELF;
	
	DelayCommand(0.1f, PlaySound("cb_ht_arrow2"));
	DelayCommand(0.2f, DestroyObject(oMe, 0.0f, FALSE));
}