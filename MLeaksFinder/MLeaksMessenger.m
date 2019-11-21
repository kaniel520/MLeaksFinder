/**
 * Tencent is pleased to support the open source community by making MLeaksFinder available.
 *
 * Copyright (C) 2017 THL A29 Limited, a Tencent company. All rights reserved.
 *
 * Licensed under the BSD 3-Clause License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 *
 * https://opensource.org/licenses/BSD-3-Clause
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
 */

#import "MLeaksMessenger.h"

static __weak UIAlertController *g_alertVC;

@implementation MLeaksMessenger

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message {
    [self alertWithTitle:title message:message delegate:nil additionalButtonTitle:nil];
}

+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
              delegate:(id<MLeakedObjectProxyDelegate>)delegate
 additionalButtonTitle:(NSString *)additionalButtonTitle {
    NSLog(@"可能存在内存泄漏：%@: %@", title, message);
    if (g_alertVC){
        return;
    }
    UIAlertController * alertVC = [UIAlertController
                                   alertControllerWithTitle:title
                                   message:message
                                   preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //do something when click button
    }];
    [alertVC addAction:okAction];
    if (additionalButtonTitle.length > 0){
        UIAlertAction *addtionaleAction = [UIAlertAction actionWithTitle:additionalButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            if(delegate && [delegate respondsToSelector:@selector(didClickDetail)]){
                [delegate didClickDetail];
            }
        }];
        [alertVC addAction:addtionaleAction];
    }
    
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertVC animated:YES completion:nil];
    g_alertVC = alertVC;
}

@end
