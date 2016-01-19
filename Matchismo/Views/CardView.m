// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "CardView.h"

NS_ASSUME_NONNULL_BEGIN


@implementation CardView

#pragma mark - Properties

@synthesize faceCardScaleFactor = _faceCardScaleFactor;

#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.90



#pragma mark - Drawing

#define CORNER_RADIUS 12.0
- (void)drawCardInners
{
//stub, needs to be overriden
}


- (void)drawRect:(CGRect)rect
{
  // Drawing code
  UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:CORNER_RADIUS];
  
  [roundedRect addClip];
  
  [[UIColor whiteColor] setFill];
  UIRectFill(self.bounds);
  
  [self drawCardInners];
  
  [[UIColor blackColor] setStroke];
  [roundedRect stroke];
}

- (CGFloat)faceCardScaleFactor
{
  if (!_faceCardScaleFactor) _faceCardScaleFactor = DEFAULT_FACE_CARD_SCALE_FACTOR;
  return _faceCardScaleFactor;
}

- (void)setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor
{
  _faceCardScaleFactor = faceCardScaleFactor;
  [self setNeedsDisplay];
}


- (void)setChoosen:(BOOL)chosen
{
  _choosen = chosen;
  [self setNeedsDisplay];
}

- (void)pushContextAndRotateUpsideDown
{
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
  CGContextRotateCTM(context, M_PI);
}

- (void)popContext
{
  CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

#pragma mark - Gesture Handlers

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
  if ((gesture.state == UIGestureRecognizerStateChanged) ||
      (gesture.state == UIGestureRecognizerStateEnded)) {
    self.faceCardScaleFactor *= gesture.scale;
    gesture.scale = 1;
  }
}

#pragma mark - Initialization

- (void)setup
{
  // do initialization here
  self.opaque = NO;
}

- (void)awakeFromNib
{
  [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    [self setup];
  }
  return self;
}

@end


NS_ASSUME_NONNULL_END
