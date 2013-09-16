//
//  DXShellHelper.m
//  DXImageAnalyzePlugin
//
//  Created by Dai Ryan on 13-9-16.
//  Copyright (c) 2013年 dhcdht. All rights reserved.
//

#import "DXShellHelper.h"

@implementation DXShellHelper

+ (void)runShellCommand:(NSString *)command
               withArgs:(NSArray *)args
              directory:(NSString *)directory
             completion:(TaskCompleteBlock)completion
{
    __block NSMutableData *taskOutput = [NSMutableData new];
    __block NSMutableData *taskError  = [NSMutableData new];
    
    NSTask *task = [NSTask new];
    
    task.currentDirectoryPath = directory;
    task.launchPath = command;
    task.arguments  = args;
    
    task.standardOutput = [NSPipe pipe];
    task.standardError  = [NSPipe pipe];
    
    [[task.standardOutput fileHandleForReading] setReadabilityHandler:^(NSFileHandle *file) {
        [taskOutput appendData:[file availableData]];
    }];
    
    [[task.standardError fileHandleForReading] setReadabilityHandler:^(NSFileHandle *file) {
        [taskError appendData:[file availableData]];
    }];
    
    [task setTerminationHandler:^(NSTask *t) {
        [t.standardOutput fileHandleForReading].readabilityHandler = nil;
        [t.standardError fileHandleForReading].readabilityHandler  = nil;
        NSString *output = [[NSString alloc] initWithData:taskOutput encoding:NSUTF8StringEncoding];
        NSString *error = [[NSString alloc] initWithData:taskError encoding:NSUTF8StringEncoding];
        if (completion)
        {
            completion(t, output, error);
        }
        [output release];
        [error release];
    }];
    
    [task launch];
}

@end
