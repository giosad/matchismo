// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "CardView.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SetCardShape) {
  SetCardShapeDiamond,
  SetCardShapeSquiggle,
  SetCardShapeOval,
  SetCardShapeCount
};

typedef NS_ENUM(NSUInteger, SetCardShading) {
  SetCardShadingStripes,
  SetCardShadingFull,
  SetCardShadingEmpty,
  SetCardShadingCount
};

typedef NS_ENUM(NSUInteger, SetCardColor) {
  SetCardColorRed,
  SetCardColorGreen,
  SetCardColorPurple,
  SetCardColorCount
};


/// UIView for representing Set game card of a specific kind
@interface SetCardView : CardView
@property (nonatomic, readonly) SetCardShape shape;
@property (nonatomic, readonly) SetCardShading shading;
@property (nonatomic, readonly) SetCardColor color;
@property (nonatomic, readonly) NSUInteger count;

- (instancetype) initWithShape:(SetCardShape)shape Shading:(SetCardShading)shading Color:(SetCardColor)color Count:(NSUInteger)count;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype) init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
