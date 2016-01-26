//
//  ViewController.m
//  WaterWaveDemo
//
//  Created by Antonio081014 on 9/4/15.
//  Copyright (c) 2015 antonio081014.com. All rights reserved.
//

#import "ViewController.h"
#import "SPWaterProgressIndicatorView.h"

@interface ViewController ()
@property (nonatomic, strong) SPWaterProgressIndicatorView *waterView;
@property (nonatomic) BOOL isAnimating;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.waterView = [[SPWaterProgressIndicatorView alloc] initWithFrame:self.view.bounds];
    self.waterView.center = self.view.center;
    [self.view addSubview:self.waterView];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateAnimation)];
    [self.waterView addGestureRecognizer:gesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(updatePercent:)];
    [self.waterView addGestureRecognizer:panGesture];
    
    self.isAnimating = YES;
    
}

- (void)updatePercent:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [gesture locationInView:self.waterView];
        NSUInteger percent = 100 - 100 * location.y / CGRectGetHeight(self.waterView.bounds);
        [self.waterView updateWithPercentCompletion:percent];
    }
}

- (void)updateAnimation
{
    self.isAnimating = !self.isAnimating;
    if (self.isAnimating) {
        [self.waterView startAnimation];
    } else {
        [self.waterView stopAnimation];
    }
}


@end
