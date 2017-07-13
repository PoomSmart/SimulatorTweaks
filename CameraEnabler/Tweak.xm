#import "../../PS.h"
#import "../Common.h"
#import <substrate.h>

BOOL override = NO;

%hook AVCaptureSession

// get rid of crashing at startup on iOS 10
- (BOOL)_buildAndRunGraph {
    return YES;
}

%end

%hook CAMCaptureEngine

- (id)initWithPowerController: (id)arg1
{
    self = %orig;
    [self _handleSessionDidStartRunning:nil];
    return self;
}

%end

%hook CUCaptureController

- (_Bool)isConfigurationAvailable {
    return YES;
}
- (_Bool)isCaptureAvailable {
    return YES;
}

- (_Bool)isPreviewDisabled {
    return NO;
}

- (_Bool)_isVideoCaptureAvailable {
    return YES;
}

%end

%hook CAMEffectsRenderer

- (id)init
{
    self = %orig;
    [self _deviceStarted:nil];
    [self _setPreviewStartedNotificationNeeded:YES];
    [self _previewStarted:nil];
    return self;
}

%end

%hook CAMClosedViewfinderController

- (void)addClosedViewfinderReason: (NSInteger)reason
{
    %orig;
    [self removeClosedViewfinderReason:reason];
}

%end

%hook CAMViewfinderViewController

- (void)_willChangeFromMode: (NSInteger)fromMode toMode: (NSInteger)toMode fromDevice: (NSInteger)fromDevice toDevice: (NSInteger)toDevice animated: (BOOL)animated
{
    %orig;
    [self captureController:nil didChangeToMode:toMode device:toDevice];
}

%end

%hook AVCaptureMovieFileOutput

- (NSMutableArray *)liveConnections {
    return @[@"0"];
}

%end

%hook CAMViewfinderView

- (id)initWithFrame: (CGRect)frame
{
    self = %orig;
    UIImage *image = [UIImage imageWithContentsOfFile:@"/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS 9.3.simruntime/Contents/Resources/SampleContent/Media/DCIM/100APPLE/IMG_0005.JPG"];
    image = [UIImage imageWithCGImage:[image CGImage] scale:2 orientation:UIImageOrientationUp];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.alpha = 0.6;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imageView];
    [imageView release];
    return self;
}

- (id)initWithLayoutStyle:(NSInteger)layoutStyle {
    self = %orig;
    UIImage *image = [UIImage imageWithContentsOfFile:@"/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS 9.3.simruntime/Contents/Resources/SampleContent/Media/DCIM/100APPLE/IMG_0005.JPG"];
    image = [UIImage imageWithCGImage:[image CGImage] scale:2 orientation:UIImageOrientationUp];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.alpha = 0.6;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imageView];
    [imageView release];
    return self;
}

%end

%hook CAMPreviewView

- (id)initWithFrame: (CGRect)frame
{
    self = %orig;
    MSHookIvar<UILabel *>(self, "__simulatorLabel").text = @"Camera Simulator";
    self.backgroundColor = UIColor.clearColor;
    return self;
}

%end

%hook CAMCaptureCapabilities

- (CGFloat)maximumVideoZoomFactorForMode: (NSInteger)mode device: (NSInteger)device videoConfiguration: (NSInteger)config {
    return 10.0;
}
- (_Bool)isPanoramaSupportedForDevice:(NSInteger)device {
    return YES;
}

- (_Bool)isBackPanoramaSupported {
    return YES;
}

- (_Bool)isBackFlashSupported {
    return YES;
}

- (_Bool)isFrontFlashSupported {
    return YES;
}

- (_Bool)isBackSlomoSupported {
    return YES;
}

- (_Bool)isFrontSlomoSupported {
    return YES;
}

- (_Bool)isSlomoSupportedForDevice:(NSInteger)device {
    return YES;
}

- (_Bool)isIrisSupportedForDevice:(NSInteger)device {
    return YES;
}

- (_Bool)isFlashSupportedForDevice:(NSInteger)device {
    return YES;
}

- (_Bool)isBackHDRSupported {
    return YES;
}

- (_Bool)isBackHDROnSupported {
    return YES;
}

- (_Bool)isFrontHDRSupported {
    return YES;
}

- (_Bool)isFrontHDROnSupported {
    return YES;
}

- (_Bool)isVideoSupported {
    return YES;
}

- (_Bool)isLiveFilteringSupported {
    return YES;
}

- (_Bool)isBackCameraSupported {
    return YES;
}

- (_Bool)isFrontCameraSupported {
    return YES;
}

- (_Bool)isBackIrisSupported {
    return YES;
}

- (_Bool)isFrontIrisSupported {
    return YES;
}

- (_Bool)isBackBurstSupported {
    return YES;
}

- (_Bool)isFrontBurstSupported {
    return YES;
}

- (_Bool)isSquareModeSupported {
    return YES;
}

- (_Bool)isSupportedVideoConfiguration:(NSInteger)config forMode:(NSInteger)mode device:(NSInteger)device {
    return YES;
}

%end

%hook SBApplicationInfo

- (id)_parseAppTags: (NSDictionary *)dict hasVisibilityOverride: (BOOL)visible
{
    if ([dict[@"CFBundleIdentifier"] isEqualToString:@"com.apple.camera"]) {
        NSMutableDictionary *mdict = dict.mutableCopy;
        [mdict removeObjectForKey:@"SBAppTags"];
        dict = mdict.copy;
        [mdict release];
    }
    return %orig(dict, visible);
}

%end

%hook SpringBoard

- (_Bool)lockScreenCameraSupported {
    return YES;
}
- (_Bool)canShowLockScreenCameraGrabber {
    return YES;
}

%end

%hook SBPlatformController

- (id)defaultIconStateDisplayIdentifiers
{
    id r = %orig;
    NSLog(@"%@ %@", [r class], r);
    return r;
}

%end

extern "C" BOOL MGGetBoolAnswer(CFStringRef);
%hookf(BOOL, MGGetBoolAnswer, CFStringRef string){
    if (k("euampscYbKXqj/bSaHD0QA") || k("pLzf7OiX5nWAPUMj7BfI4Q") || k("video-stills"))
        return YES;
    return %orig;
}

%ctor
{
    NSString *identifier = NSBundle.mainBundle.bundleIdentifier;
    if ([identifier isEqualToString:@"com.apple.SpringBoard"] || [identifier isEqualToString:@"com.apple.camera"]) {
        runIn(@"CameraEnabler");
        %init;
    }
}
