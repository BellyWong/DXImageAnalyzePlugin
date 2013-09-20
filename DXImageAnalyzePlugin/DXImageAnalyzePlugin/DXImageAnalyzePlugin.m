//
//  DXImageAnalyzePlugin.m
//  DXImageAnalyzePlugin
//
//  Created by Dai Ryan on 13-9-16.
//    Copyright (c) 2013年 dhcdht. All rights reserved.
//

#import "DXImageAnalyzePlugin.h"

#import "DXShellHelper.h"
#import "DXPathHelper.h"

@implementation DXImageAnalyzePlugin

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static id sharedPlugin = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPlugin = [[self alloc] init];
    });
}

- (id)init
{
    if (self = [super init])
    {
        // Create menu items, initialize UI, etc.
        [self initMenuItems];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private
- (void)initMenuItems
{
    NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"File"];
    if (menuItem)
    {
        [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
        
        NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Check useless images" action:@selector(checkUselessImages) keyEquivalent:@""];
        [actionMenuItem setTarget:self];
        [[menuItem submenu] addItem:actionMenuItem];
        
        NSMenuItem *actionMenuItem2 = [[NSMenuItem alloc] initWithTitle:@"Check missing images" action:@selector(checkMissingImages) keyEquivalent:@""];
        [actionMenuItem2 setTarget:self];
        [[menuItem submenu] addItem:actionMenuItem2];
    }
}

- (void)checkUselessImagesForWorkspaceDirectory
{
    NSString *checkUselessImagesScripe =
    [NSString stringWithFormat: @"find . -name \"*.png\" |grep -v @ | while read line;do iname=$(basename \"$line\"|sed -e \"s/\\.png//\"); [ -z \"`find ./ \\( -name \"*.m\" -or -name \"*.h\" -or -name \"*.xib\" \\) -print0 | xargs -0 grep -E \"${iname}(\\\\\\.png)?\"`\" ] && echo $line && img2x=\"`echo \"$line\"|sed -e \"s/\\.png/@2x\\.png/\"`\" && [ -e \"$img2x\" ] && echo $img2x; done"];
    [DXShellHelper runScript: checkUselessImagesScripe
                   directory: [DXPathHelper currentWorkspaceDirectoryPath]
                  completion: ^(NSTask *task, NSString *output, NSString *error) {
                      if ([error length])
                      {
                          NSAlert *alert = [NSAlert alertWithMessageText:error defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
                          [alert runModal];
                      }
                      NSAlert *alert = [NSAlert alertWithMessageText:output defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
                      [alert runModal];
                  }];
}

- (void)checkMissingImagesForWorkspaceDirectory
{
    NSString *checkMissingImagesScripe =
    [NSString stringWithFormat: @"find . -name \"*.png\" | while read line;do iname=$(basename \"$line\" | sed -e \"s/\\.png//\" -e \"s/@2x//\"); dname=\"$(dirname \"$line\")/\"; [ ! -e \"${dname}${iname}.png\" ] && echo \"$line miss image\"; [ ! -e \"${dname}${iname}@2x.png\" ] && echo \"$line miss @2x image\"; done"];
    [DXShellHelper runScript: checkMissingImagesScripe
                   directory: [DXPathHelper currentWorkspaceDirectoryPath]
                  completion: ^(NSTask *task, NSString *output, NSString *error) {
                      if ([error length])
                      {
                          NSAlert *alert = [NSAlert alertWithMessageText:error defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
                          [alert runModal];
                      }
                      NSAlert *alert = [NSAlert alertWithMessageText:output defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
                      [alert runModal];
                  }];
}

#pragma mark - Menu Action
- (void)checkUselessImages
{
//    NSAlert *alert = [NSAlert alertWithMessageText:@"Hello, World" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
//    [alert runModal];
    [self checkUselessImagesForWorkspaceDirectory];
}

- (void)checkMissingImages
{
    [self checkMissingImagesForWorkspaceDirectory];
}

@end
