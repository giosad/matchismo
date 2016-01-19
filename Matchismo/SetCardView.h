// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "CardView.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SetCardShape) {
  SetCardShapeCircle,
  SetCardShapeRectangle,
  SetCardShapeTriangle,
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
  SetCardColorBlue,
  SetCardColorCount
};

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
