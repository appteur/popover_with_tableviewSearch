//
//  PopoverViewController.m
//  popoverView
//
//  Created by Seth on 12/3/15.
//  Copyright © 2015 Seth Arnott. All rights reserved.
//

#import "PopoverViewController.h"

@interface PopoverViewController ()

@end

@implementation PopoverViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // get the desired size for this popover and setup our header height
    CGSize viewSize      = self.preferredContentSize;
    CGFloat headerHeight = 44.0;
    
    // setup our desired frames
    CGRect headerFrame          = CGRectMake(0, 0, viewSize.width, headerHeight);
    CGRect searchContainerFrame = CGRectMake(0, headerHeight, viewSize.width, headerHeight);
    
    // for this frame I'm simply centering it, there's better ways to do it but this is an example
    CGRect searchBarFrame       = CGRectMake(5, 5, searchContainerFrame.size.width - 10, searchContainerFrame.size.height - 10);
    
    // set our tableview frame to be positioned below our header and search container frame
    CGRect tableviewFrame       = CGRectMake(0, headerHeight *2, viewSize.width, viewSize.height - (headerHeight * 2));
    
    // create our header view and set it's background color
    UIView *headerView = [[UIView alloc] initWithFrame:headerFrame];
    headerView.backgroundColor = [UIColor orangeColor];
    
    // create our container view to hold the search bar (not needed really, but if you want it contained in a view here's how)
    UIView *searchContainer = [[UIView alloc] initWithFrame:searchContainerFrame];
    searchContainer.backgroundColor = [UIColor greenColor];

    // instantiate our search bar
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:searchBarFrame];
    
    // add the search bar to the container view
    [searchContainer addSubview:searchBar];
    
    // create our tableview and position it below our header and search containers
    UITableView *tableview = [[UITableView alloc] initWithFrame:tableviewFrame];
    tableview.backgroundColor = [UIColor blueColor];
    
    [self.view addSubview:headerView];
    [self.view addSubview:searchContainer];
    [self.view addSubview:tableview];
}











- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonAction:(id)sender
{
    [self.delegate dismissPopover];
}


@end
