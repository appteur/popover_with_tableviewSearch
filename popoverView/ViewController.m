//
//  ViewController.m
//  popoverView
//
//  Created by Seth on 12/3/15.
//  Copyright © 2015 Seth Arnott. All rights reserved.
//

#import "ViewController.h"
#import "PopoverViewController.h"

@interface ViewController ()<UIPopoverPresentationControllerDelegate, PopoverDelegate>

@property (nonatomic, weak) PopoverViewController *popoverVC;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *launchBtn;
@property (nonatomic, weak) UIView *activePopoverSourceBtn;
@property (weak, nonatomic) IBOutlet UIToolbar *lowerToolbar;
@property (nonatomic, weak) UIView *activePopoverSourceView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor grayColor];
}


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    NSLog(@"viewWillTransitionToSize [%@]", NSStringFromCGSize(size));
    
    // resizes popover to new size and arrow location on orientation change
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context)
     {
         CGRect viewframe = self.activePopoverSourceBtn ? self.activePopoverSourceBtn.frame : CGRectZero;
         
         // update our source rect so the arrow will move on the popover
         self.popoverVC.popoverPresentationController.sourceRect = viewframe;
         
         if (self.popoverVC)
         {
             CGSize newSize = [self popoverSize];
             
             // update our popover content size for the new layout
             self.popoverVC.preferredContentSize = newSize;
         }
         
     } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
         
     }];
}



- (IBAction)actionShowPopover:(id)sender withEvent:(UIEvent*)event
{
    UIView *buttonView          = [[event.allTouches anyObject] view];
    CGRect btnRect              = buttonView.frame;
    CGSize popoverSize          = [self popoverSize];
    

    NSLog(@"ButtonView: %@ --btnRect: [%@] --popoverSize:[%@]", buttonView, NSStringFromCGRect(btnRect), NSStringFromCGSize(popoverSize));
    
    PopoverViewController *vc   =  [self setupPopover:@"PopoverVC"];
    vc.modalPresentationStyle   = UIModalPresentationPopover;
    
    UIPopoverPresentationController *pc = [vc popoverPresentationController];
    pc.barButtonItem            = self.launchBtn;
    pc.delegate                 = self;
    pc.permittedArrowDirections = UIPopoverArrowDirectionDown;
    pc.backgroundColor          = [UIColor greenColor];
    
    vc.delegate                 = self;
    vc.preferredContentSize     = popoverSize;
    
    NSLog(@"setPreferredSize: [%@]", NSStringFromCGSize(vc.popoverPresentationController.preferredContentSize));
    
    [self presentViewController:vc animated:YES completion:nil];
}





#pragma mark - Popover Presentation Controller Delegate

- (void)prepareForPopoverPresentation:(UIPopoverPresentationController *)popoverPresentationController
{
    NSLog(@"prepareForPopoverPresentation.. preferred content size: [%@]", NSStringFromCGSize(popoverPresentationController.preferredContentSize));
}

- (void)popoverPresentationController:(UIPopoverPresentationController *)popoverPresentationController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView *__autoreleasing *)view
{
    NSLog(@"willRepositionPopoverToRect - controller: %@  rect: [%@] inView: %@", popoverPresentationController, NSStringFromCGRect(*rect), *view);
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController
{
    NSLog(@"popoverPresentationControllerShouldDismissPopover");
    return YES;
}

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController
{
    NSLog(@"popoverPresentationControllerDidDismissPopover");
    self.popoverVC = nil;
}





- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller traitCollection:(UITraitCollection *)traitCollection
{
    NSLog(@"adaptivePresentationStyleForPresentationController:traitCollection: %@", controller);
    return UIModalPresentationNone; //You have to specify this particular value in order to make it work on iPhone6+ in landscape.
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    NSLog(@"adaptivePresentationStyleForPresentationController: %@", controller);
    return UIModalPresentationNone; //You have to specify this particular value in order to make it work on iPhone.
}




-(void) dismissPopover
{
    [self dismissViewControllerAnimated:YES completion:nil];
}







-(PopoverViewController*) setupPopover:(NSString*)popoverName 
{
    UIStoryboard *storyboard            = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    PopoverViewController *popover      = nil;

    @try {
        popover = [storyboard instantiateViewControllerWithIdentifier:popoverName];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception loading vc: [%@] -- %@", popoverName, exception);
    }
    
    return popover;
}



-(CGSize) popoverSize
{
    // create a shortcut variable
    CGSize viewSize     = self.view.bounds.size;
    NSLog(@"CURRENT VIEW SIZE: [%@]", NSStringFromCGSize(viewSize));

    // is view wider than it is tall?
    BOOL isWideView     = viewSize.height <= viewSize.width;
    CGFloat multiplier  = 0.5;
    CGFloat width;
    CGFloat height;


    if (isWideView) // landscape
    {
        width  = viewSize.width * multiplier;
        height = viewSize.height - 80;

        // set min values
        width  = width < 380 ? 380 : width;
        height = height < 280 ? 280 : height;

        // set max values
        width  = width > 480 ? 480 : width;   // limit landscape width
        height = height > 600 ? 600 : height; // limit landscape height

    }
    else // portrait
    {
        width  = viewSize.width = viewSize.width - 20;
        height = viewSize.height * multiplier;

        // set min values
        width  = width < 280 ? 280 : width;
        height = height < 300 ? 300 : height;

        // set max values
        width  = width > 414 ? 414 : width;     // limit portrait width to 600
        height = height > 600 ? 600 : height;   // limit portrait height to 600
    }

    NSLog(@"Popover width: [%f] height: [%f]", width, height);

    return CGSizeMake(width, height);
}



@end
