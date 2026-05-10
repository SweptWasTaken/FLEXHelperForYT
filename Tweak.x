extern BOOL EnablesTweak();

%hook YTAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions {
    BOOL didFinishLaunching = %orig;
    if (EnablesTweak()) [[%c(FLEXManager) performSelector:@selector(sharedManager)] performSelector:@selector(showExplorer)];
    return didFinishLaunching;
}
- (void)appWillResignActive:(id)arg1 {
    %orig;
    if (EnablesTweak()) [[%c(FLEXManager) performSelector:@selector(sharedManager)] performSelector:@selector(showExplorer)];
}
%end