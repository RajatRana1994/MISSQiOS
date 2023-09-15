//
//  MessageView.m
//  StudentServe
//
//  Created by Ankit Kumar on 16/02/16.
//  Copyright © 2016 Sunfocus Solutions. All rights reserved.
//

//
#import "MessageView.h"
#import <QuartzCore/QuartzCore.h>

#define kFontName @"Helvetica"
#define kFontSize 14
#define kAnimationDuration 1


@implementation MessageView


+ (void) showInView: (UIView *) view withMessage: (NSString *) message
{
    NSUInteger length = [message length]+2;
    CGFloat width = length * kFontSize;
    CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width /* 0.75*/;
    CGFloat height;
    
    if (width > maxWidth)
    {
        height = ((width/maxWidth) * kFontSize) + kFontSize;
        width = maxWidth;
    }
    else 
    {
        height = kFontSize * 2.0;
    }
    
    MessageView *HUD = [[MessageView alloc] initWithFrame:CGRectMake(40, 225, [UIScreen mainScreen].bounds.size.width-80, height + 10)];
    HUD.text = [NSString stringWithFormat:@" %@ ", message];
    HUD.backgroundColor = [UIColor colorWithRed: 11.0/255.0 green: 185.0/255.0 blue:196.0/255.0 alpha:1.0];
    HUD.layer.cornerRadius = 5;
    HUD.layer.masksToBounds = YES;
    HUD.textColor = [UIColor whiteColor];
    HUD.font = [UIFont fontWithName:kFontName size:kFontSize];
    HUD.textAlignment = NSTextAlignmentCenter;
    HUD.numberOfLines = 0;
    HUD.center = view.window.center;
    HUD.frame = CGRectMake(40,
                           /*HUD.frame.origin.y - (view.window.frame.size.height/4)*/ 160.0,
                           HUD.frame.size.width,
                           HUD.frame.size.height);
    
    [view.window addSubview: HUD];
    [NSTimer scheduledTimerWithTimeInterval:kAnimationDuration
                                     target:self
                                   selector:@selector(startAnimation:)
                                   userInfo:HUD
                                    repeats:NO];
}


+ (void) startAnimation: (NSTimer *) timer
{
    MessageView *HUD = (MessageView *)[timer userInfo];
    [UIView beginAnimations:nil context:(__bridge void *)(HUD)];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView setAnimationDuration:kAnimationDuration];
    HUD.alpha = 0.0;
    [UIView commitAnimations];
    
}

+ (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if (finished.integerValue==1) {
        @try {
            MessageView *HUD = (__bridge MessageView *)context;
            [HUD removeFromSuperview];
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
 
    }
}

-(void)closePressed:(id)sender{
     MessageView *HUD = (MessageView *)[sender superview];
    [HUD removeFromSuperview];
}


@end
