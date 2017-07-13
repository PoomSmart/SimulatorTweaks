#import "../../PS.h"
#import "../Common.h"

/*%hook NSFileManager

- (_Bool)fileExistsAtPath:(NSString *)filePath
{
	if ([filePath hasSuffix:@"/Library/PreferenceBundles/Internal Settings.bundle"])
		return YES;
	return %orig;
}

%end*/

/*extern "C" BOOL PSIsInternalInstall();
%hookf(BOOL, PSIsInternalInstall)
{
	return YES;
}*/

extern "C" BOOL PSSupportsMesa();
%hookf(BOOL, PSSupportsMesa) {
	return NO;
}

%ctor
{
	runIn(@"FullSettings");
	%init;
}
