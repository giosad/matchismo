// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "PlayingCardView.h"

NS_ASSUME_NONNULL_BEGIN
@interface PlayingCardView()
@property (nonatomic, readwrite) NSUInteger rank;
@property (strong, nonatomic, readwrite) NSString *suit;
@end

@implementation PlayingCardView


#define PIP_FONT_SCALE_FACTOR 0.20
#define CORNER_OFFSET 2.0


- (instancetype) initWithSuit:(NSString*)suit Rank:(NSUInteger)rank
{
  if (self = [super init]) {
    self.rank = rank;
    self.suit = suit;
  }
  return self;
}


- (NSMutableAttributedString *)suitAttrString
{
  UIColor *suitColor = [@[ @"♦︎", @"♥︎"] containsObject:self.suit] ? [UIColor redColor] : [UIColor blackColor];
  NSMutableAttributedString *suitStr = [[NSMutableAttributedString alloc]
                                        initWithString:self.suit
                                        attributes: @{NSForegroundColorAttributeName: suitColor}];
  return suitStr;
}
-(NSMutableAttributedString *)cornerText
{
  NSMutableAttributedString *title = [[NSMutableAttributedString alloc] init];
  
  //"♣︎", @"♠︎", @"♦︎", @"♥︎"
  
  NSMutableAttributedString *rankStr = [[NSMutableAttributedString alloc]
                                        initWithString:[self rankAsString]
                                        attributes: @{NSForegroundColorAttributeName: [UIColor blackColor]}];
  
  [title appendAttributedString: rankStr];
  [title appendAttributedString: [[NSMutableAttributedString alloc] initWithString:@"\n"]];
  [title appendAttributedString: [self suitAttrString]];

  
  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  paragraphStyle.alignment = NSTextAlignmentCenter;
  UIFont *cornerFont = [UIFont systemFontOfSize:self.bounds.size.width * PIP_FONT_SCALE_FACTOR];

                                                      

  [title addAttributes:@{ NSParagraphStyleAttributeName : paragraphStyle,
                                    NSFontAttributeName : cornerFont }
                 range:NSMakeRange(0, [title length])];

  //
  //    [title addAttribute:NSFontAttributeName
  //                 value:[UIFont systemFontOfSize:11]
  //                  range:NSMakeRange(0, [title length])];
  return title;
}

- (NSString *)rankAsString
{
  return @[@"?", @"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"][self.rank];
}

- (void) drawCardInners //override
{
  if (self.choosen) {
    [self drawFace];
  } else {
    [[UIImage imageNamed:@"cardback.png"] drawInRect:self.bounds];
  }
}


- (void) drawFace
{
  UIImage *faceImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@",
                                            [self rankAsString], self.suit]];
  if (faceImage) {
    CGRect imageRect = CGRectInset(self.bounds,
                                   self.bounds.size.width * (1.0 - self.faceCardScaleFactor),
                                   self.bounds.size.height * (1.0 - self.faceCardScaleFactor));
    [faceImage drawInRect:imageRect];
  } else {
    [self drawPips];
  }
  [self drawCorners];

}


- (void)drawCorners
{
  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  paragraphStyle.alignment = NSTextAlignmentCenter;
  
  UIFont *cornerFont = [UIFont systemFontOfSize:self.bounds.size.width * PIP_FONT_SCALE_FACTOR];
  
  NSMutableAttributedString *cornerText = [self cornerText];
  [cornerText addAttributes:@{NSParagraphStyleAttributeName : paragraphStyle,
                                        NSFontAttributeName : cornerFont }
                      range: NSMakeRange(0, [cornerText length])];
  
  CGRect textBounds;
  textBounds.origin = CGPointMake(CORNER_OFFSET, CORNER_OFFSET);
  textBounds.size = [cornerText size];
  [cornerText drawInRect:textBounds];
  
  [self pushContextAndRotateUpsideDown];
  [cornerText drawInRect:textBounds];
  [self popContext];
}



#pragma mark - Draw Pips

#define PIP_HOFFSET_PERCENTAGE 0.165
#define PIP_VOFFSET1_PERCENTAGE 0.090
#define PIP_VOFFSET2_PERCENTAGE 0.175
#define PIP_VOFFSET3_PERCENTAGE 0.270

- (void)drawPips
{
  if ((self.rank == 1) || (self.rank == 5) || (self.rank == 9) || (self.rank == 3)) {
    [self drawPipsWithHorizontalOffset:0
                        verticalOffset:0
                    mirroredVertically:NO];
  }
  if ((self.rank == 6) || (self.rank == 7) || (self.rank == 8)) {
    [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                        verticalOffset:0
                    mirroredVertically:NO];
  }
  if ((self.rank == 2) || (self.rank == 3) || (self.rank == 7) || (self.rank == 8) || (self.rank == 10)) {
    [self drawPipsWithHorizontalOffset:0
                        verticalOffset:PIP_VOFFSET2_PERCENTAGE
                    mirroredVertically:(self.rank != 7)];
  }
  if ((self.rank == 4) || (self.rank == 5) || (self.rank == 6) || (self.rank == 7) || (self.rank == 8) || (self.rank == 9) || (self.rank == 10)) {
    [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                        verticalOffset:PIP_VOFFSET3_PERCENTAGE
                    mirroredVertically:YES];
  }
  if ((self.rank == 9) || (self.rank == 10)) {
    [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                        verticalOffset:PIP_VOFFSET1_PERCENTAGE
                    mirroredVertically:YES];
  }
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                      verticalOffset:(CGFloat)voffset
                          upsideDown:(BOOL)upsideDown
{
  if (upsideDown) [self pushContextAndRotateUpsideDown];
  CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
  UIFont *pipFont = [UIFont systemFontOfSize:self.bounds.size.width * PIP_FONT_SCALE_FACTOR];
  NSMutableAttributedString *attributedSuit = [self suitAttrString];
  
  [attributedSuit addAttribute:NSFontAttributeName value:pipFont range:NSMakeRange(0, [attributedSuit length])];
  CGSize pipSize = [attributedSuit size];
  CGPoint pipOrigin = CGPointMake(
                                  middle.x-pipSize.width/2.0-hoffset*self.bounds.size.width,
                                  middle.y-pipSize.height/2.0-voffset*self.bounds.size.height
                                  );
  [attributedSuit drawAtPoint:pipOrigin];
  if (hoffset) {
    pipOrigin.x += hoffset*2.0*self.bounds.size.width;
    [attributedSuit drawAtPoint:pipOrigin];
  }
  if (upsideDown) [self popContext];
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                      verticalOffset:(CGFloat)voffset
                  mirroredVertically:(BOOL)mirroredVertically
{
  [self drawPipsWithHorizontalOffset:hoffset
                      verticalOffset:voffset
                          upsideDown:NO];
  if (mirroredVertically) {
    [self drawPipsWithHorizontalOffset:hoffset
                        verticalOffset:voffset
                            upsideDown:YES];
  }
}

@end

NS_ASSUME_NONNULL_END
