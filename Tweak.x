#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <dlfcn.h>

@interface FLEXManager : NSObject
+ (instancetype)sharedManager;
- (void)showExplorer;
@end

BOOL flexLoaded = NO;

// Called on-demand from Settings.x — NOT at startup.
// FLEX must not load during dyld init because its +load methods modify the ObjC
// runtime in ways that cause YouTube's own +load to trap (EXC_BAD_INSTRUCTION).
BOOL loadFLEXIfNeeded() {
    if (flexLoaded) return YES;
    NSString *flexPath = [[[NSBundle mainBundle] bundlePath]
                          stringByAppendingPathComponent:@"Frameworks/FLEX.framework/FLEX"];
    flexLoaded = dlopen([flexPath UTF8String], RTLD_NOW) != NULL;
    return flexLoaded;
}

void showFLEXExplorer() {
    if (loadFLEXIfNeeded()) {
        [[%c(FLEXManager) sharedManager] showExplorer];
    }
}

%hook YTAppDelegate

// Re-surface FLEX when returning to foreground, but only if already loaded.
- (void)appWillResignActive:(id)arg1 {
    %orig;
    if (flexLoaded) {
        [[%c(FLEXManager) sharedManager] showExplorer];
    }
}

%end

%ctor {
    // Do NOT dlopen FLEX here. Loading FLEX during dyld startup runs FLEX's
    // +load methods before YouTube's own +load, causing YouTube to crash.
    // FLEX is loaded lazily from Settings when the user taps "Activate FLEX".
    %init;
}
