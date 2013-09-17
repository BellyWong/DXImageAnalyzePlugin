//
//  DXShellHelper.h
//  DXImageAnalyzePlugin
//
//  Created by Dai Ryan on 13-9-16.
//  Copyright (c) 2013年 dhcdht. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^TaskCompleteBlock)(NSTask *task, NSString *output, NSString *error);

@interface DXShellHelper : NSObject

+ (void)runShellCommand:(NSString *)command
               withArgs:(NSArray *)args
              directory:(NSString *)directory
             completion:(TaskCompleteBlock)completion;

+ (void)runScript:(NSString*)script
        directory:(NSString*)directory
       completion:(TaskCompleteBlock)completion;

@end
