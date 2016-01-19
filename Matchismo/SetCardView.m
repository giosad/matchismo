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


- (void) drawCardInners //override
{
}

@end

NS_ASSUME_NONNULL_END
