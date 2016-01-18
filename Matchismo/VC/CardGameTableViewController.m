// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "CardGameTableViewController.h"

#import "Grid.h"
NS_ASSUME_NONNULL_BEGIN
@interface CardGameTableViewController()
@property (strong, nonatomic) NSMutableArray<CardView*> *cardViewsInternal;
@property (strong, nonatomic) Grid *grid;


@end
@implementation CardGameTableViewController
- (void) addCardView:(CardView*)cardView
{
  [self.cardViewsInternal addObject:cardView];
  cardView.frame = [self.grid frameOfCellAtRow:0 inColumn:0];
  [self.view addSubview:cardView];
  UITapGestureRecognizer *singleFingerTap =
  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCardTap:)];
  [cardView addGestureRecognizer:singleFingerTap ];
 // [cardView setNeedsDisplay];
  
  //todo animation
}

- (void) removeCardView:(CardView*)cardView
{
  //todo animation
  [self.cardViewsInternal removeObject:cardView];
  [cardView removeFromSuperview];
}
-(NSArray<CardView*>*) cardViews
{
  return [self.cardViewsInternal copy];
}


- (void)handleCardTap:(UITapGestureRecognizer *)sender
{
  if (sender.state == UIGestureRecognizerStateEnded)
  {
    self.cardTapEventHandler((CardView*)sender.view);
  }
}

-(void) viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  self.grid = [[Grid alloc] init];
  self.grid.size = self.view.bounds.size;
  self.grid.cellAspectRatio = 0.7;
  self.grid.minimumNumberOfCells = 20;
  NSLog(@"CardGameTableViewController::viewDidAppear");
 //todo implement the reordering
  
}
@end

NS_ASSUME_NONNULL_END
