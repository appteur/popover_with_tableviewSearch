//
//  PopoverViewController.h
//  popoverView
//
//  Created by Seth on 12/3/15.
//  Copyright © 2015 Seth Arnott. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopoverDelegate <NSObject>

-(void) dismissPopover;

@end


@interface PopoverViewController : UIViewController

@property (nonatomic, weak) id<PopoverDelegate>delegate;

@end
