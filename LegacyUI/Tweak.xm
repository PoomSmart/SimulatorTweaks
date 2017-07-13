#import "../../PS.h"
#import "../Common.h"
#import <substrate.h>

extern "C" BOOL GSApplicationUsesLegacyUI();

%hookf(BOOL, GSApplicationUsesLegacyUI)
{
	return YES;
}

%ctor
{
	runIn(@"LegacyUI");
	%init;
}