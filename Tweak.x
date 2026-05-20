#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <dlfcn.h>

@interface FLEXManager : NSObject
+ (instancetype)sharedManager;
- (void)showExplorer;
@end

static BOOL flexLoaded = NO;

static void loadFLEX() {
    NSString *flexPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Frameworks/FLEX.framework/FLEX"];
    flexLoaded = dlopen([flexPath UTF8String], RTLD_NOW) != NULL;
}

%hook YTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions {
    BOOL didFinishLaunching = %orig;
    if (flexLoaded) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[%c(FLEXManager) sharedManager] showExplorer];
        });
    }
    return didFinishLaunching;
}

- (void)appWillResignActive:(id)arg1 {
    %orig;
    if (flexLoaded) {
        [[%c(FLEXManager) sharedManager] showExplorer];
    }
}

%end

%ctor {
    loadFLEX();
    %init;
}
