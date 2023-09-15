//
//  StarRatingView.m
//  StarRatingDemo
//
//  Created by HengHong on 5/4/13.
//  Copyright (c) 2013 Fixel Labs Pte. Ltd. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "StarRatingView.h"
#define kLeftPadding 5.0f


@interface StarRatingView()
@property (nonatomic) int userRating;
@property (nonatomic) int maxrating;
@property (nonatomic) int rating;
@property (nonatomic) BOOL animated;
@property (nonatomic) float kLabelAllowance;
@property (nonatomic,strong) NSTimer* timer;
@property (nonatomic,strong) UILabel* label;
@property (nonatomic,strong) CALayer* tintLayer;

@end

@implementation StarRatingView
@synthesize timer;
@synthesize kLabelAllowance;
@synthesize tintLayer;
- (id)initWithFrame:(CGRect)frame andRating:(int)rating withLabel:(BOOL)label onImage:(UIImage*)image animated:(BOOL)animated
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        
        _maxrating = rating;
        self.animated = animated;
        
        
        if (label) {
            self.kLabelAllowance = 50.0f;
            self.label = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width-kLabelAllowance , 0,kLabelAllowance, frame.size.height)];
            self.label.font = [UIFont systemFontOfSize:18.0f];
            self.label.text = [NSString stringWithFormat:@"%d%%",rating];
            self.label.textAlignment = NSTextAlignmentRight;
            self.label.textColor = [UIColor clearColor];  ////// black
            self.label.backgroundColor = [UIColor clearColor];
            [self addSubview:self.label];
        }else{
            self.kLabelAllowance = 0.0f;
        }
        CGRect newrect = CGRectMake(0, 0, self.bounds.size.width-kLabelAllowance, self.bounds.size.height);
        CALayer* starBackground = [CALayer layer];
        starBackground.contents = (__bridge id)(image.CGImage);
        starBackground.frame = newrect;
        [self.layer addSublayer:starBackground];
        tintLayer = [CALayer layer];
        tintLayer.frame = CGRectMake(0, 0, 0, self.bounds.size.height);
        if (self.userRating >=20.0f) {
            //  [tintLayer setBackgroundColor:(__bridge CGColorRef _Nullable)(SIDE_TABLE_SELECTED_TINT_COLOR)]; //green
            [tintLayer setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:198.0/255.0 blue:81.0/255 alpha:1.0].CGColor];
        }else{
            // [tintLayer setBackgroundColor:(__bridge CGColorRef _Nullable)(SIDE_TABLE_SELECTED_TINT_COLOR)];
            [tintLayer setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:198.0/255.0 blue:81.0/255 alpha:1.0].CGColor];
        }
        [self.layer addSublayer:tintLayer];
        CALayer* starMask = [CALayer layer];
        starMask.contents = (__bridge id)(image.CGImage);
        starMask.frame = newrect;
        [self.layer addSublayer:starMask];
        tintLayer.mask = starMask;
        if (self.animated) {
            _rating = 0;
            timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(increaseRating) userInfo:nil repeats:YES];
            [self performSelector:@selector(ratingDidChange) withObject:nil afterDelay:0.0];
        }else{
            _rating = _maxrating;
            
        }
    }
    return self;
}
-(void)increaseRating
{
    if (_rating<_maxrating) {
        _rating = _rating + 1;
        if (self.label) {
            self.label.text = [NSString stringWithFormat:@"%d%%",self.rating];
        }
    }else{
        [timer invalidate];
    }
}
-(void)ratingDidChange
{
    if (self.userRating < 20.0f) {
        // [self.tintLayer setBackgroundColor:SIDE_TABLE_SELECTED_TINT_COLOR.CGColor];
        [tintLayer setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:198.0/255.0 blue:81.0/255 alpha:1.0].CGColor];
        float barWitdhPercentage = (_maxrating/5.0f) *  (self.bounds.size.width-kLabelAllowance);
        self.tintLayer.frame = CGRectMake(0, 0, barWitdhPercentage, self.frame.size.height);
    }else{
        //   [self.tintLayer setBackgroundColor:SIDE_TABLE_SELECTED_TINT_COLOR.CGColor];  //// green
        [tintLayer setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:198.0/255.0 blue:81.0/255 alpha:1.0].CGColor];
        float barWitdhPercentage = (_rating/100.0f) *  (self.bounds.size.width-kLabelAllowance);
        self.tintLayer.frame = CGRectMake(0, 0, barWitdhPercentage, self.frame.size.height);
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (CGRectContainsPoint(self.bounds, [[[touches allObjects]lastObject] locationInView:self])) {
        
        float xpos = [[[touches allObjects]lastObject] locationInView:self].x - kLeftPadding;
        int star = MIN(4,xpos/((self.bounds.size.width-kLabelAllowance-kLeftPadding)/5.0f));
        //  delegate.strStar = [NSString stringWithFormat:@"%i",star];
        if (xpos < kLeftPadding) {
            if (self.userRating == 20.0f) {
                self.userRating = 0.0f;
                if (self.animated) {
                    self.rating = 0;
                    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(increaseRating) userInfo:nil repeats:YES];
                }else{
                    self.rating = self.maxrating;
                    if (self.label) {
                        self.label.text = [NSString stringWithFormat:@"%d%%",self.rating];
                    }
                }
            }
        }else{
            self.userRating = (star+1)*20.0f;
            self.rating = self.userRating;
            if (self.label) {
                self.label.text = [NSString stringWithFormat:@"%d%%",self.rating];
            }
        }
        [self ratingDidChange];
        
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (CGRectContainsPoint(self.bounds, [[[touches allObjects]lastObject] locationInView:self])) {
        
        float xpos = [[[touches allObjects]lastObject] locationInView:self].x - kLeftPadding;
        int star = MIN(4,xpos/((self.bounds.size.width-kLabelAllowance-kLeftPadding)/5.0f));
        //   delegate.strStar = [NSString stringWithFormat:@"%i",star+1];
        if (star == 0) {
            if (self.userRating == 20.0f) {
                self.userRating = 0.0f;
                self.rating = self.maxrating;
            }else{
                self.userRating = (star+1)*20.0f;
                self.rating = self.userRating;
            }
        }else{
            self.userRating = (star+1)*20.0f;
            self.rating = self.userRating;
        }
        [self ratingDidChange];
        
        if (self.label) {
            self.label.text = [NSString stringWithFormat:@"%d%%",self.rating];
        }
    }
}


@end
