//////////////////////////////////////////
//  Author: Drammel						//
//  Date: 3/15/2009						//
//  Title: c_ihit_holy					//
//  Description: Creates an intangible	//
//	creature which can run sounds that	//
//	simulate the results of an attack	//
//	roll for a strike maneuver.			//
//////////////////////////////////////////

void main()
{
	object oMe = OBJECT_SELF;
	
	DelayCommand(0.1f, PlaySound("sfx_hit_Holy"));
	DelayCommand(0.2f, DestroyObject(oMe, 0.0f, FALSE));
}