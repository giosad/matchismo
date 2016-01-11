//
//  SetCard.h
//  Matchismo
//
//  Created by Gennadi Iosad on 11/01/2016.
//  Copyright © 2016 LightricksNoobsDepartment. All rights reserved.
//

#import "Card.h"
#import <UIKit/UIColor.h>

typedef NS_ENUM(NSUInteger, SetCardShape) {
    SetCardShapeCircle,
    SetCardShapeRectangle,
    SetCardShapeTriangle,
    SetCardShapeCount
};

typedef NS_ENUM(NSUInteger, SetCardShading) {
    SetCardShadingStripes,
    SetCardShadindFull,
    SetCardShadingEmpty,
    SetCardShadingCount
};

typedef NS_ENUM(NSUInteger, SetCardColor) {
    SetCardColorRed,
    SetCardColorGreen,
    SetCardColorBlue,
    SetCardColorCount
};

@interface SetCard : Card
@property (nonatomic) SetCardShape shape;
@property (nonatomic) SetCardShading shading;
@property (nonatomic) SetCardColor color;
@property (nonatomic) NSUInteger count;
+(int)maxCount;
@end
