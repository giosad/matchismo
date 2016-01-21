// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "SetCardView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SetCardView()
@property (nonatomic, readwrite) SetCardShape shape;
@property (nonatomic, readwrite) SetCardShading shading;
@property (nonatomic, readwrite) SetCardColor color;
@property (nonatomic, readwrite) NSUInteger count;
@end
@implementation SetCardView
- (instancetype) initWithShape:(SetCardShape)shape Shading:(SetCardShading)shading Color:(SetCardColor)color Count:(NSUInteger)count
{
  if (self = [super init]) {
    self.shape = shape;
    self.shading = shading;
    self.color = color;
    self.count = count;
  }
  return self;

}



#define SYMBOL_PERCENT_OF_CARD_HEIGHT (0.2)
#define SYMBOL_PERCENT_OF_CARD_WIDTH  (0.6)
#define SYMBOL_GAP (1.2)
#define SET_CARD_OPEN_LINE_WIDTH (1.2f)

#define STRIPE_WIDTH (1.0)
#define STRIPE_EVERY_N_PERCENT (0.04f)

#define SET_CARD_SQUIGGLE_WIDTH_ADJUST_FOR_CURVES (0.9f)
#define SET_CARD_SQUIGGLE_HEIGHT_ADJUST_FOR_CURVES (0.66f)

// how much the squiggle's parallelogram is pushed over in the x direction
// ex: p3 is to the right of p1 by TWICE this pshift value
#define SET_CARD_SQUIGGLE_PARALLELOGRAM_HALF_SHIFT_PERCENT (0.05f)

#define SET_CARD_SQUIGGLE_PARALLELOGRAM_CONTROL_POINT_SCALE_PERCENT (0.3f)

#define CORNER_RADIUS (12.0)

#pragma mark - Drawing Functions
- (void) drawCardInners //override
{
  // figure out how many shapes to draw
  NSMutableArray *shapeHeightDelta = [[NSMutableArray alloc] init];
  
  if (self.count == 0) // draw in the middle - VIOLATION of MVC - Why should view know model is zero based
    [shapeHeightDelta addObject:[NSNumber numberWithFloat:0.0f]];
  
  if (self.count == 1) { // draw on either end of the center
    [shapeHeightDelta addObject:[NSNumber numberWithFloat:-[self halfShapeHeight]*SYMBOL_GAP]];
    [shapeHeightDelta addObject:[NSNumber numberWithFloat:+[self halfShapeHeight]*SYMBOL_GAP]];
  }
  
  if (self.count == 2) { // draw on either side of the center plus the center
    [shapeHeightDelta addObject:[NSNumber numberWithFloat:-[self shapeHeight]*SYMBOL_GAP]];
    [shapeHeightDelta addObject:[NSNumber numberWithFloat:0.0f]];
    [shapeHeightDelta addObject:[NSNumber numberWithFloat:+[self shapeHeight]*SYMBOL_GAP]];
  }
  
  for (NSNumber *num in shapeHeightDelta) {
    CGPoint centerPoint = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2 - [num floatValue]);
    
    // the shape
    if (self.shape == SetCardShapeDiamond) [self drawDiamondAtPoint:centerPoint];
    if (self.shape == SetCardShapeSquiggle) [self drawSquiggleAtPoint:centerPoint];
    if (self.shape == SetCardShapeOval) [self drawOvalAtPoint:centerPoint];
  }
}

- (void)drawDiamondAtPoint:(CGPoint)centerPoint
{
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
  
  UIBezierPath *path = [[UIBezierPath alloc] init];
  
  [path moveToPoint:CGPointMake(-[self halfShapeWidth],        0)];
  [path addLineToPoint:CGPointMake(      0, -[self halfShapeHeight])];
  [path addLineToPoint:CGPointMake( [self halfShapeWidth],        0)];
  [path addLineToPoint:CGPointMake(      0,  [self halfShapeHeight])];
  [path closePath];
  
  [self paintPath:path];
  CGContextRestoreGState(context);
}

- (void)drawSquiggleAtPoint:(CGPoint)centerPoint
{
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
  UIBezierPath *path = [[UIBezierPath alloc] init];
  
  // for a squiggle, we have four points, arranged in a parallelogram
  // clockwise, from top left, top right, bottom right, bottom left, they're called p1 p2 p3 p4
  // the parallelogram has a width and a height, but because our origin is in the centre
  // we often need half these values: let's call these half values pwidth and pheight
  
  CGFloat pwidth  = [self halfShapeWidth] * SET_CARD_SQUIGGLE_WIDTH_ADJUST_FOR_CURVES;
  CGFloat pheight = [self halfShapeHeight]* SET_CARD_SQUIGGLE_HEIGHT_ADJUST_FOR_CURVES;
  
  // the parallelogram has another value - pshift - which is how much it is slanted
  // i.e. how much it is pushed over in the x direction
  //    e.g. p3 is to the right of p1 by TWICE this pshift value
  
  CGFloat pshift = [self halfShapeWidth] * SET_CARD_SQUIGGLE_PARALLELOGRAM_HALF_SHIFT_PERCENT;
  
  CGPoint p1, p2, p3, p4;
  p1 = CGPointMake(-pwidth-pshift, -pheight);
  p2 = CGPointMake( pwidth-pshift, -pheight);
  
  p3 = CGPointMake( pwidth+pshift,  pheight);
  p4 = CGPointMake(-pwidth+pshift,  pheight);
  
  // then we have the control points for the curves (cp1, cp2, ...)
  // there are two kinds of curves: the horizontal waves
  //                                and the vertical ends
  
  // horizontal wave: the control points for p1 is 45 degrees up   and right of p1
  // horizontal wave: the control points for p2 is 45 degrees down and left  of p2
  
  // vertical end: the control points for p2 is 45 degrees right and up of p2
  // vertical end: the control points for p3 is 45 degrees right and up of p3
  
  // the length of the control point vector (between p1 and cp1) is proportional to the height/width
  // this is the same value for both x and the y because we're using 45 degrees
  CGFloat controlPointOffset = [self halfShapeWidth] * SET_CARD_SQUIGGLE_PARALLELOGRAM_CONTROL_POINT_SCALE_PERCENT;
  
  [path moveToPoint:p1];
  // top
  [path addCurveToPoint:p2
          controlPoint1:CGPointMake(p1.x+controlPointOffset, p1.y-controlPointOffset)
          controlPoint2:CGPointMake(p2.x-controlPointOffset, p2.y+controlPointOffset)];
  // rhs
  [path addCurveToPoint:p3
          controlPoint1:CGPointMake(p2.x+controlPointOffset, p2.y-controlPointOffset)
          controlPoint2:CGPointMake(p3.x+controlPointOffset, p3.y-controlPointOffset)];
  // bottom
  [path addCurveToPoint:p4
          controlPoint1:CGPointMake(p3.x-controlPointOffset, p3.y+controlPointOffset)
          controlPoint2:CGPointMake(p4.x+controlPointOffset, p4.y-controlPointOffset)];
  // lhs
  [path addCurveToPoint:p1
          controlPoint1:CGPointMake(p4.x-controlPointOffset, p4.y+controlPointOffset)
          controlPoint2:CGPointMake(p1.x-controlPointOffset, p1.y+controlPointOffset)];
  [path closePath];
  
  [self paintPath:path];
  
  CGContextRestoreGState(context);
}


- (void)drawOvalAtPoint:(CGPoint)centerPoint
{
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
  UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(-[self halfShapeWidth], -[self halfShapeHeight],
                                                                          [self shapeWidth],      [self shapeHeight])
                                                  cornerRadius:[self halfShapeWidth]];
  [self paintPath:path];
  
  CGContextRestoreGState(context);
}

- (void)paintPath:(UIBezierPath *)path
{
  // shade fill-type
  if (self.shading == SetCardShadingFull) {
    [[self symbolUIColor] setFill];
    [path fill];
  }
  else if (self.shading == SetCardShadingEmpty)
    [path setLineWidth:SET_CARD_OPEN_LINE_WIDTH];
  
  // draw the outline for both open and stripped
  [[self symbolUIColor] setStroke];
  [path stroke];
  
  if (self.shading == SetCardShadingStripes) {
    [path addClip];
    // we're going to draw a single dashed line from left to right, as wide as our height
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *stripes = [[UIBezierPath alloc] init];
    
    CGFloat dashes[] = {STRIPE_WIDTH, roundl(self.bounds.size.width*STRIPE_EVERY_N_PERCENT) };
    CGContextSetLineDash(context, 0.0, dashes, 2); // 0 is 'phase', 2 is num elements in dashes array
    
    [stripes setLineWidth:path.bounds.size.height];
    
    [stripes moveToPoint:CGPointMake(-path.bounds.size.width, 0)];
    [stripes addLineToPoint:CGPointMake(path.bounds.size.width, 0)];
    
    [stripes stroke];
  }
}


#pragma mark - Helper Functions

-(UIColor *)symbolUIColor
{
  if (self.color == SetCardColorRed)
    return [UIColor colorWithRed:1.0   green:0.0  blue:0.23 alpha:1.0];
  else if (self.color == SetCardColorPurple)
    return [UIColor colorWithRed:0.6   green:0.1  blue:0.6  alpha:1.0];
  else if (self.color == SetCardColorGreen)
    return [UIColor colorWithRed:0.262 green:0.83 blue:0.3  alpha:1.0];
  else return [UIColor blackColor]; // default color
}

-(CGFloat) shapeHeight
{
  return self.bounds.size.height * SYMBOL_PERCENT_OF_CARD_HEIGHT;
}

-(CGFloat) halfShapeHeight
{
  return [self shapeHeight]/2;
}

-(CGFloat) shapeWidth
{
  return self.bounds.size.width * SYMBOL_PERCENT_OF_CARD_WIDTH;
}

-(CGFloat) halfShapeWidth
{
  return [self shapeWidth]/2;
}
@end

NS_ASSUME_NONNULL_END
