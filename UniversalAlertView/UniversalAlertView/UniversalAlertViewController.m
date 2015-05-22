/*
 Copyright (c) 2015, Akshay Bhalotia.
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 */

//
//  UniversalAlertViewController.m
//  UniversalAlertView
//
//  Created by Akshay Bhalotia on 21/05/15.
//  Copyright (c) 2015 Akshay Bhalotia. All rights reserved.
//

#import "UniversalAlertViewController.h"

@interface UniversalAlertViewController () <UIAlertViewDelegate>
{
    NSDictionary *actions;
    NSObject *thisAlert;
}
@end

@implementation UniversalAlertViewController

-(id)initAlertWithTitle:(NSString *)title andMessage:(NSString *)message withCancelButton:(NSString *)cancel buttonsAndActions:(NSDictionary *)actionDict {
    self = [super init];
    actions = actionDict;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:cancelAction];
        for (NSString *button in [actionDict allKeys]) {
            void (^actionBlock)(UIAlertAction *action) = [actionDict objectForKey:button];
            UIAlertAction *action = [UIAlertAction actionWithTitle:button style:UIAlertActionStyleDefault handler:actionBlock];
            [alert addAction:action];
        }
        thisAlert = alert;
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancel otherButtonTitles:nil];
        for (NSString *button in [actionDict allKeys]) {
            [alert addButtonWithTitle:button];
        }
        thisAlert = alert;
    }
    return self;
}

-(void)show {
    if ([thisAlert respondsToSelector:@selector(show)]) {
        [((UIAlertView *)thisAlert) show];
    } else {
        [self.vc presentViewController:((UIAlertController *)thisAlert) animated:YES completion:nil];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex > 0) {
        void (^myBlock)() = [actions objectForKey:[[actions allKeys] objectAtIndex:(buttonIndex - 1)]];
        [myBlock invoke];
    }
}

@end
