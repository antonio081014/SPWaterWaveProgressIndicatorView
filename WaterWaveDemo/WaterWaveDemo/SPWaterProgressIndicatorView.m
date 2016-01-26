//
//  SPWaterProgressIndicatorView.m
//
//  Created by Antonio081014 on 9/4/15.
//  Copyright (c) 2015 antonio081014.com. All rights reserved.
//

#import "SPWaterProgressIndicatorView.h"

static const CGFloat kDefaultFrequency          = 1.5f;
static const CGFloat kDefaultAmplitude          = 1.0f;
static const CGFloat kDefaultIdleAmplitude      = 0.01f;
static const CGFloat kDefaultPhaseShift         = -0.15f;
static const CGFloat kDefaultDensity            = 5.0f;
static const NSUInteger kDefaultPercent         = 0;
static const NSUInteger kDefaultMaximumPercent  = 100;
static const CGFloat kDefaultPrimaryLineWidth   = 3.0f;
static const CGFloat kDefaultFontSize           = 20.f;
static const CGFloat kDefaultMinimumFontSize    = 12.f;

@interface SPWaterProgressIndicatorView ()
/*
 * Line width used for the proeminent wave
 * Default: 3.0f
 */
@property (nonatomic)  IBInspectable CGFloat primaryWaveLineWidth;

/*
 * The amplitude that is used when the incoming amplitude is near zero.
 * Setting a value greater 0 provides a more vivid visualization.
 * Default: 0.01
 */
@property (nonatomic) IBInspectable CGFloat idleAmplitude;

/*
 * The frequency of the sinus wave. The higher the value, the more sinus wave peaks you will have.
 * Default: 1.5
 */
@property (nonatomic) IBInspectable CGFloat frequency;

/*
 * The current amplitude
 */
@property (nonatomic) IBInspectable CGFloat amplitude;

/*
 * The lines are joined stepwise, the more dense you draw, the more CPU power is used.
 * Default: 5
 */
@property (nonatomic) IBInspectable CGFloat density;

/*
 * The phase shift that will be applied with each level setting
 * Change this to modify the animation speed or direction
 * Default: -0.15
 */
@property (nonatomic) IBInspectable CGFloat phaseShift;

@property (nonatomic) CGFloat phase;

@property (nonatomic) NSUInteger completionInPercent;

@property (nonatomic, strong) CADisplayLink *displaylink;

@property (nonatomic, strong) CATextLayer *textLayer;
@end

@implementation SPWaterProgressIndicatorView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    // Default background color is transparent.
    self.backgroundColor = [UIColor clearColor];
    self.waveColor = [UIColor cyanColor];
    
    self.completionInPercent = kDefaultPercent;
    
    self.frequency = kDefaultFrequency;
    
    self.amplitude = kDefaultAmplitude;
    self.idleAmplitude = kDefaultIdleAmplitude;
    
    self.phaseShift = kDefaultPhaseShift;
    self.density = kDefaultDensity;
    
    self.primaryWaveLineWidth = kDefaultPrimaryLineWidth;
    self.fontSize = kDefaultFontSize;
    
    UIBezierPath *progressPath = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    CAShapeLayer *layer = [CAShapeLayer layer];
    [layer setPath:progressPath.CGPath];
    layer.lineWidth = MIN(CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds)) / 10.f;
    self.layer.mask = layer;
    
    [self.layer addSublayer:self.textLayer];
    
    [self startAnimation];
}

/**
 * Ensure the size is always square.
 */
- (void)setFrame:(CGRect)frame {
    if (frame.size.width < frame.size.height) {
        frame.size.height = frame.size.width;
    } else {
        frame.size.width = frame.size.height;
    }
    
    [super setFrame:frame];
}


- (CATextLayer *)textLayer
{
    if (!_textLayer) {
        _textLayer = [CATextLayer layer];
        _textLayer.bounds = CGRectMake(0, 0, CGRectGetWidth(self.bounds), MIN(CGRectGetHeight(self.bounds), 40.f));
        _textLayer.position = self.center;
        _textLayer.alignmentMode = kCAAlignmentCenter;
        _textLayer.string = [NSString stringWithFormat:@"%zd %%", self.completionInPercent];
        _textLayer.fontSize = self.fontSize;
        _textLayer.foregroundColor = [UIColor grayColor].CGColor;
    }
    return _textLayer;
}

- (void)setFontSize:(CGFloat)fontSize
{
    _fontSize = MAX(fontSize, kDefaultMinimumFontSize);
    
    [self setNeedsDisplay];
}

- (void)updateWithPercentCompletion:(NSUInteger)percent
{
    self.completionInPercent = MAX(0, MIN(kDefaultMaximumPercent, percent));
    
    self.textLayer.string = [NSString stringWithFormat:@"%zd %%", self.completionInPercent];
    
    [self setNeedsDisplay];
}

/**
 * With phase shifts, the animation will prevail.
 */
- (void)update
{
    self.phase += self.phaseShift;
    
    [self setNeedsDisplay];
}

- (void)startAnimation
{
    self.displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeters)];
    [self.displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)updateMeters
{
    [self update];
}

- (void)stopAnimation
{
    [self.displaylink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [self.displaylink invalidate];
    self.displaylink = nil;
}

//  Great Thanks to Stefan Ceriu.
//  Ref: https://github.com/stefanceriu/SCSiriWaveformView
- (void)drawRect:(CGRect)rect
{
    // Get current Context.
    CGContextRef context = UIGraphicsGetCurrentContext();
    // Clear everything in the bounds drawed in the last phase,
    // otherwise, drawing will overlap on each other.
    CGContextClearRect(context, self.bounds);
    
    [self.backgroundColor set];
    CGContextFillRect(context, rect);
    
    CGContextSetLineWidth(context, self.primaryWaveLineWidth);
    
    CGFloat halfHeight = CGRectGetHeight(self.bounds) / 2.0f;
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat mid = width / 2.0f;
    
    const CGFloat maxAmplitude = fmax(halfHeight / 10 - 4.0f, 2.f * self.primaryWaveLineWidth); // 4 corresponds to twice the stroke width
    
    [[self.waveColor colorWithAlphaComponent:CGColorGetAlpha(self.waveColor.CGColor)] set];
    
    for (CGFloat x = 0; x<width + self.density; x += self.density) {
        // We use a parable to scale the sinus wave, that has its peak in the middle of the view.
        CGFloat scaling = -pow(1 / mid * (x - mid), 2) + 1;
        
        CGFloat y = scaling * maxAmplitude * self.amplitude * sinf(2 * M_PI *(x / width) * self.frequency + self.phase) + 1.0 * CGRectGetHeight(self.bounds) * (100 - self.completionInPercent) / 100.f;
        
        if (x == 0) {
            CGContextMoveToPoint(context, x, y);
        } else {
            CGContextAddLineToPoint(context, x, y);
        }
    }
    
    CGContextAddLineToPoint(context, width, CGRectGetHeight(self.bounds));
    CGContextAddLineToPoint(context, 0, CGRectGetHeight(self.bounds));
    CGContextClosePath(context);
    CGContextFillPath(context);
    CGContextStrokePath(context);
}

/**
 * Ensure nothing would happen when user touch out of the mask(circle)
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CAShapeLayer *layer = (CAShapeLayer *)self.layer.mask;
    if ([[UIBezierPath bezierPathWithCGPath:layer.path] containsPoint:point]){
        return self;
    }
    return nil;
}

@end
