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
- (void) selectCardView:(CardView*)cardView
{
    NSLog(@"selectCardView");
  [UIView transitionWithView:cardView
                    duration:0.5
                     options:UIViewAnimationOptionTransitionFlipFromLeft
                  animations:^{
                    cardView.choosen = !cardView.choosen;
                  }
                  completion:NULL];
  
}
- (Grid*) grid
{
  if (!_grid) {
    _grid = [[Grid alloc] init];
  }
  return _grid;
}
- (void) addCardView:(CardView*)cardView
{
  [self.cardViewsInternal addObject:cardView];
  CGRect fr = CGRectMake(-100, -100, 0, 0);
  cardView.frame = fr;
  
  [self.view addSubview:cardView];
  UITapGestureRecognizer *singleFingerTap =
  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCardTap:)];
  [cardView addGestureRecognizer:singleFingerTap];
 // [cardView setNeedsDisplay];
  //[self alignCardsToViewSize:self.view.bounds.size];
  [self positionCardView:cardView atPosition:[self.cardViewsInternal count] - 1];
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
  [UIView animateWithDuration:2.0 animations:^{
    cardView.frame = CGRectMake(-100, -100, 0, 0);
    
  }];
  [cardView removeFromSuperview];
}
- (NSArray<CardView*> *)cardViews
{
  return [self.cardViewsInternal copy];
}
- (NSMutableArray<CardView*> *)cardViewsInternal
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

- (void) positionCardView:(CardView *)cardView atPosition:(NSUInteger)position
{

    NSUInteger row = position / self.grid.columnCount;
    NSUInteger col = position % self.grid.columnCount;
    //    cardView.frame = [self.grid frameOfCellAtRow:row inColumn:col];
    
    [UIView animateWithDuration:2.0 animations:^{
      
      cardView.frame = [self.grid frameOfCellAtRow:row inColumn:col];

    }];
  NSLog(@"cardView newPos %0.1f, %0.1f", cardView.frame.origin.x, cardView.frame.origin.y);
  
    // [cardView setNeedsDisplay];
}

- (void) alignCardsToViewSize:(CGSize)newSize
{
  NSLog(@"CardGameTableViewController::alignCardsToViewSize newSize %.1fx%.1f ", newSize.height, newSize.width);
  if (CGSizeEqualToSize(self.grid.size, newSize)) {
      NSLog(@"CardGameTableViewController::alignCardsToViewSize nothing to do");
    return; //nothing to do
  }
	 // self.grid = nil;
  self.grid.cellAspectRatio = 0.7;
  self.grid.minimumNumberOfCells = 30;
  self.grid.size = newSize;
  NSLog(@"grid.resolved %d", self.grid.inputsAreValid);
  NSLog(@"grid: %@", [self.grid description]);
  int pos = 0;
  for (CardView *cardView in self.cardViewsInternal) {
    [self positionCardView:cardView atPosition:pos++];
  }

}

-(void) viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  [self alignCardsToViewSize:self.view.bounds.size];
  NSLog(@"CardGameTableViewController::viewDidLayoutSubviews");
}

- (void)traitCollectionDidChange:(UITraitCollection * _Nullable)previousTraitCollection
{
  [super traitCollectionDidChange: previousTraitCollection];
  NSLog(@"CardGameTableViewController::traitCollectionDidChange");
//  [self alignCardsToViewSize:self.view.bounds.size];
}

-(void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
  [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    NSLog(@"CardGameTableViewController::viewWillTransitionToSize");
//  [self alignCardsToViewSize:size];
}

-(void) viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  NSLog(@"CardGameTableViewController::viewDidAppear animated=%d", animated);
//  [self alignCardsToViewSize:self.view.bounds.size];
  
}

-(void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];

  NSLog(@"CardGameTableViewController::viewWillAppear");
}
@end

NS_ASSUME_NONNULL_END
