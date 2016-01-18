// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.
#import "CardView.h"
NS_ASSUME_NONNULL_BEGIN

@interface PlayingCardView : CardView

@property (nonatomic, readonly) NSUInteger rank;
@property (strong, nonatomic, readonly) NSString *suit;


- (instancetype) initWithSuit:(NSString*)suit Rank:(NSUInteger)rank;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype) init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
