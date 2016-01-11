//
//  GameHistoryController.m
//  Matchismo
//
//  Created by Gennadi Iosad on 11/01/2016.
//  Copyright © 2016 LightricksNoobsDepartment. All rights reserved.
//

#import "GameHistoryViewController.h"
@interface GameHistoryViewController()
@property (weak, nonatomic) IBOutlet UITextView *historyTextView;
@end
@implementation GameHistoryViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.historyTextView.attributedText = self.gameHistory;
}
@end
