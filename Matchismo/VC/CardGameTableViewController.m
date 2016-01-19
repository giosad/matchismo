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

-(Grid*) grid
{
  if (!_grid) {
    _grid = [[Grid alloc] init];
  }
  return _grid;
}
- (void) addCardView:(CardView*)cardView
{
  [self.cardViewsInternal addObject:cardView];
//  cardView.frame = [self.grid frameOfCellAtRow:0 inColumn:0];
  [self.view addSubview:cardView];
  UITapGestureRecognizer *singleFingerTap =
  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCardTap:)];
  [cardView addGestureRecognizer:singleFingerTap ];
 // [cardView setNeedsDisplay];
  
  //todo animation
}

- (void) removeCardView:(CardView*)cardView
{

  NSUInteger i = [self.cardViewsInternal indexOfObject:cardView];
  if(i == NSNotFound) {
    return;
  }

  CardView* lastView = [self.cardViewsInternal lastObject];
  if (lastView != cardView) {
    self.cardViewsInternal[i] = [self.cardViewsInternal lastObject];
    [self.cardViewsInternal removeLastObject];
  }
  //todo animation
  
  [cardView removeFromSuperview];
}
-(NSArray<CardView*> *)cardViews
{
  return [self.cardViewsInternal copy];
}
-(NSMutableArray<CardView*> *)cardViewsInternal
{
  if (!_cardViewsInternal) {
    _cardViewsInternal = [[NSMutableArray<CardView*> alloc] init];
  }
  return _cardViewsInternal;
}

- (void)handleCardTap:(UITapGestureRecognizer *)sender
{
  if (sender.state == UIGestureRecognizerStateEnded)
  {
    self.cardTapEventHandler((CardView*)sender.view);
  }
}

-(void) alignCardsToViewSize:(CGSize)newSize
{
  if ((self.grid.size.height == newSize.height) &&
      (self.grid.size.width == newSize.width)){
    return; //nothing to do
  }
  self.grid.size = newSize;
  self.grid.cellAspectRatio = 0.7;
  self.grid.minimumNumberOfCells = 30;
    
  int pos = 0;
  for (CardView *cardView in self.cardViewsInternal) {
    NSUInteger row = pos / self.grid.columnCount;
    NSUInteger col = pos % self.grid.columnCount;
    [UIView animateWithDuration:2.0 animations:^{
      
      cardView.frame = [self.grid frameOfCellAtRow:row inColumn:col];
      
    }];
    
    pos++;
    //  [cardView setNeedsDisplay];
    
  }
  
}

-(void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
  [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    NSLog(@"CardGameTableViewController::viewWillTransitionToSize");
  [self alignCardsToViewSize:size];
}

-(void) viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  NSLog(@"CardGameTableViewController::viewDidAppear %d", animated);
  [self alignCardsToViewSize:self.view.bounds.size];
}


-(void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];


  NSLog(@"CardGameTableViewController::viewWillAppear");
}
@end

NS_ASSUME_NONNULL_END
