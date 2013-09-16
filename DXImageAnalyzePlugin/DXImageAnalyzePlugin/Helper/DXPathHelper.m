//
//  DXPathHelper.m
//  DXImageAnalyzePlugin
//
//  Created by Dai Ryan on 13-9-16.
//  Copyright (c) 2013年 dhcdht. All rights reserved.
//

#import "DXPathHelper.h"

@implementation DXPathHelper

+ (NSString*)currentWorkspaceDirectoryPath
{
    id workspace = [self workspaceForKeyWindow];
    NSString *workspacePath = [[workspace valueForKey:@"representingFilePath"] valueForKey:@"_pathString"];
    NSString *resultPath = [workspacePath stringByDeletingLastPathComponent];
    
    return resultPath;
}

#pragma mark - Static Private
+ (id)workspaceForKeyWindow
{
    NSArray *workspaceWindowControllers = [NSClassFromString(@"IDEWorkspaceWindowController") valueForKey:@"workspaceWindowControllers"];
    
    for (id controller in workspaceWindowControllers)
    {
        if ([[controller valueForKey:@"window"] valueForKey:@"isKeyWindow"])
        {
            return [controller valueForKey:@"_workspace"];
        }
    }
    return nil;
}

@end
