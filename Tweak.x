#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FLEXManager : NSObject
- (void)sharedManager;
- (void)showExplorer;
@end

%hook YTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions {
    BOOL didFinishLaunching = %orig;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[%c(FLEXManager) performSelector:@selector(sharedManager)] performSelector:@selector(showExplorer)];
    });
    return didFinishLaunching;
}

- (void)appWillResignActive:(id)arg1 {
    %orig;
    [[%c(FLEXManager) performSelector:@selector(sharedManager)] performSelector:@selector(showExplorer)];
}

%end
