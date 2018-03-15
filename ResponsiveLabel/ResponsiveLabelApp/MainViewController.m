//
//  MainViewController.m
//  ResponsiveLabel
//
//  Created by hsusmita on 15/07/15.
//  Copyright (c) 2015 hsusmita.com. All rights reserved.
//

#import "MainViewController.h"
#import "NSAttributedString+Processing.h"
@import HSResponsiveLabel;

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet ResponsiveLabel *responsiveLabel;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIButton *detectHashtagButton;
@property (weak, nonatomic) IBOutlet UIButton *detectUserHandleButton;
@property (weak, nonatomic) IBOutlet UIButton *detectURLButton;
@property (weak, nonatomic) IBOutlet UIButton *truncationEnableButton;
@property (weak, nonatomic) IBOutlet UIButton *labelEnableButton;
@property (weak, nonatomic) IBOutlet UIButton *highlightButton;

@end

@implementation MainViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self handleSegmentChange:nil];

  self.truncationEnableButton.selected = self.responsiveLabel.customTruncationEnabled;
  self.labelEnableButton.selected = self.responsiveLabel.enabled;
  
  PatternTapResponder stringTapAction = ^(NSString *tappedString) {
    NSLog(@"tapped string = %@",tappedString);
  };

  [self.responsiveLabel setHighlightedTextColor:[UIColor colorWithRed:229/255.0 green:120/255.0 blue:142/255.0 alpha:1]];

  // Add collapse token

  PatternTapResponder tap = ^(NSString *string) {
    self.responsiveLabel.numberOfLines = 1;
  };

  NSMutableAttributedString *finalString = [[NSMutableAttributedString alloc]initWithAttributedString:self.responsiveLabel.attributedText];
  [finalString appendAttributedString:[[NSAttributedString alloc] initWithString:@"... Less"
						   attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],
		  RLTapResponderAttributeName:tap}]];
  [self.responsiveLabel setAttributedText:finalString];

  NSError *error;
  NSRegularExpression *expression = [[NSRegularExpression alloc]initWithPattern:@"(\"\\w+\")" options:NSRegularExpressionCaseInsensitive error:&error];
  PatternDescriptor *descriptor = [[PatternDescriptor alloc]initWithRegex:expression
                                                           withSearchType:PatternSearchTypeAll withPatternAttributes:@{NSForegroundColorAttributeName:[UIColor brownColor],RLTapResponderAttributeName:stringTapAction}];
  [self.responsiveLabel enablePatternDetection:descriptor];
}

- (IBAction)enableHashTagButton:(UIButton *)sender {
  sender.selected = !sender.selected;
  if (sender.selected) {
  PatternTapResponder hashTagTapAction = ^(NSString *tappedString){
    self.messageLabel.text = [NSString stringWithFormat:@"You have tapped hashTag: %@",tappedString];
  };
  [self.responsiveLabel enableHashTagDetectionWithAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],
                                                               RLHighlightedBackgroundColorAttributeName:[UIColor blackColor],NSBackgroundColorAttributeName:[UIColor cyanColor],RLHighlightedBackgroundCornerRadius:@5,
                                                                  RLTapResponderAttributeName:hashTagTapAction}];
  }else {
    [self.responsiveLabel disableHashTagDetection];
  }
}

- (IBAction)enableUserhandleButton:(UIButton *)sender {
  sender.selected = !sender.selected;
  if (sender.selected) {
    PatternTapResponder userHandleTapAction = ^(NSString *tappedString){
      self.messageLabel.text = [NSString stringWithFormat:@"You have tapped user handle: %@",tappedString];
    };
    
    [self.responsiveLabel enableUserHandleDetectionWithAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor],
                                                         RLHighlightedForegroundColorAttributeName:[UIColor greenColor],
                                                         RLHighlightedBackgroundColorAttributeName:[UIColor blackColor],
                                                                       RLTapResponderAttributeName:userHandleTapAction}];
  }else {
    [self.responsiveLabel disableUserHandleDetection];
  }
  
}

- (IBAction)enableURLButton:(UIButton *)sender {
  sender.selected = !sender.selected;
  if (sender.selected) {
    PatternTapResponder URLTapAction = ^(NSString *tappedString){
      self.messageLabel.text = [NSString stringWithFormat:@"You have tapped URL: %@",tappedString];
    };
    [self.responsiveLabel enableURLDetectionWithAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor],
                                                             RLTapResponderAttributeName:URLTapAction}];
  }else {
    [self.responsiveLabel disableURLDetection];
  }
}

- (IBAction)enableResponsiveLabel:(UIButton *)sender {
  sender.selected = !sender.selected;
  self.responsiveLabel.enabled = sender.selected;
  self.messageLabel.enabled = sender.selected;
}

- (IBAction)highlightLabel:(UIButton *)sender {
  sender.selected = !sender.selected;
  [self.responsiveLabel setHighlighted:sender.selected];
  [self.messageLabel setHighlighted:sender.selected];
}

- (IBAction)handleSegmentChange:(UISegmentedControl*)sender {
  switch (self.segmentControl.selectedSegmentIndex) {
    case 0: {
      PatternTapResponder tap = ^(NSString *string) {
        self.responsiveLabel.numberOfLines = 0;
      };
      NSDictionary *attributes = @{NSFontAttributeName:self.responsiveLabel.font,
                                   NSForegroundColorAttributeName:[UIColor brownColor],
                                   RLTapResponderAttributeName:tap};
      NSAttributedString *truncationToken = [[NSAttributedString alloc] initWithString:@"... more" attributes:attributes];
      [self.responsiveLabel setAttributedTruncationToken:truncationToken];
      break;
    }
    case 1:{
      PatternTapResponder tap = ^(NSString *string) {
        self.responsiveLabel.numberOfLines = 0;
      };
      [self.responsiveLabel setTruncationIndicatorImage:[UIImage imageNamed:@"Add-Caption-Plus"]
                                               withSize:CGSizeMake(22,self.responsiveLabel.font.lineHeight)
                                              andAction:tap];
     break;
    }
    default:
      break;
  }
}

- (IBAction)enableTruncation:(UIButton *)sender {
  sender.selected = !sender.selected;
  self.responsiveLabel.customTruncationEnabled = sender.selected;
}

@end
