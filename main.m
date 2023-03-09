#include <stdio.h>

#import <Cocoa/Cocoa.h>

@interface MYAppDelegate : NSObject <NSApplicationDelegate> {
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender;
@end

@implementation MYAppDelegate : NSObject

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return TRUE;
}
@end


int
main(int argc, char *argv[])
{ @autoreleasepool
{
    NSWindow *nswindow;
    NSRect rect;
    NSUInteger style;
    NSArray *screens = [NSScreen screens];
    NSScreen *screen = nil;

    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    [NSApplication sharedApplication];

    rect.origin.x = 100;
    rect.origin.y = CGDisplayPixelsHigh(kCGDirectMainDisplay) - 100 - 500;
    rect.size.width = 600;
    rect.size.height = 500;

    style = NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskResizable;

    screen = screens[0];

    @try {
        nswindow = [[NSWindow alloc] initWithContentRect:rect styleMask:style backing:NSBackingStoreBuffered defer:NO screen:screen];
    }
    @catch (NSException *e) {
        return fprintf(stderr, "%s", [[e reason] UTF8String]);
    }

    [nswindow setColorSpace:[NSColorSpace sRGBColorSpace]];

#if MAC_OS_X_VERSION_MAX_ALLOWED >= 101200 /* Added in the 10.12.0 SDK. */
    /* By default, don't allow users to make our window tabbed in 10.12 or later */
    if ([nswindow respondsToSelector:@selector(setTabbingMode:)]) {
        [nswindow setTabbingMode:NSWindowTabbingModeDisallowed];
    }
#endif

    [nswindow setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];

    [nswindow setLevel:NSFloatingWindowLevel];

    [nswindow makeKeyAndOrderFront:NSApp];
    [nswindow setBackgroundColor:[NSColor blueColor]];
    [nswindow display];

    MYAppDelegate *appDelegate = [MYAppDelegate alloc];
    [NSApp setDelegate:appDelegate];
    [NSApp run];

    [pool release];

    return 0;
}}