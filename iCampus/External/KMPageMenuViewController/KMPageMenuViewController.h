//
//  KMPageMenuViewController.h
//  KMPageMenuViewControllerDemo
//
//  Created by Kwei Ma on 14-8-27.
//  Copyright (c) 2014年 KWEIMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KMPageMenuViewController;
@protocol KMPageMenuViewControllerDataSource;

#pragma mark - KMPageMenuItem Object

@interface KMPageMenuItem : UIButton

/**
 *  Icon for item
 */
@property (copy, nonatomic) UIImage *icon;

/**
 *  Title below the icon
 */
@property (copy, nonatomic) NSString *title;

/**
 *  Init an object with icon and title
 *
 *  @param icon  Icon image
 *  @param title Title below icon
 *
 *  @return A instant of KMPageMenuItem
 */
- (id)initWithIcon:(UIImage *)icon title:(NSString *)title;

@end

#pragma mark - KMPageMenuViewController Data Source

@protocol KMPageMenuViewControllerDataSource <NSObject>

@required

/**
 *  Asks the data source to return the number of pages in the table view.
 *
 *  @param pageMenuViewController
 *      An object representing the page-menu-view-controller requesting this information.
 *
 *  @return
 *      The number of pages in page-menu-view-controller. The default value is 1.
 */
- (int)numberOfPagesInPageMenuViewController:(KMPageMenuViewController *)pageMenuViewController;

/**
 *  Tells the data source to return the number of items in a given pageIndex of a page-menu-view-controller.
 *
 *  @param pageMenuViewController
 *      The page-menu-view-controller object requesting this information.
 *  @param page
 *      An index number identifying a page in page-menu-view-controller.
 *
 *  @return
 *      The number of items in pageIndex
 */
- (int)pageMenuViewController:(KMPageMenuViewController *)pageMenuViewController
                numberOfItemsInPage:(NSInteger)pageIndex;

/**
 *  Asks the data source for a item to insert in a particular location of the page-menu-view-controller.
 *
 *  @param pageMenuViewController 
 *      A page-menu-view-controller object requesting the item.
 *  @param indexPath
 *      An index path locating a item in page-menu-view-controller.
 *
 *  @return
 *      An object inheriting from KMPageMenuItem that the page-menu-view-controller can use for the specified item. 
 *      An assertion is raised if you return nil.
 */
- (KMPageMenuItem *)pageMenuViewController:(KMPageMenuViewController *)pageMenuViewController
                                itemAtPage:(int)page
                                  position:(int)position;

@end

#pragma mark - KMPageMenuViewController Delegate

@protocol KMPageMenuViewControllerDelegate <NSObject>

@optional

/**
 *  Tells the delegate that the specified item is now selected.
 *
 *  @param pageMenuViewController
 *      A page-menu-view-controller object informing the delegate about the new item selection.
 *  @param indexPath
 *      An index path locating the new selected item in page-menu-view-controller.
 */
- (void)pageMenuViewController:(KMPageMenuViewController *)pageMenuViewController
           didSelectItemAtPage:(int)page
                      position:(int)position;

/**
 *  Tells the delegate that the page-menu-view-controller did scroll to specified page
 *
 *  @param pageMenuViewController
 *      A page-menu-view-controller object informing the delegate about the page did scroll to.
 *  @param index
 *      An index locating the page did scroll to.
 */
- (void)pageMenuViewController:(KMPageMenuViewController *)pageMenuViewController
               didScrollToPage:(NSInteger)index;

@end

#pragma mark - KMPageMenuViewController

#import "ICLoginViewController.h"

@interface KMPageMenuViewController : UIViewController
{
    int _numberOfPages;
    int _itemsPerPage;
    int _itemsPerRow;
}

- (id)initWithPageCount:(int)numberOfPages
            itemsPerRow:(int)itemsPerRow;

@property (weak, nonatomic) id<KMPageMenuViewControllerDataSource> dataSource;
@property (weak, nonatomic) id<KMPageMenuViewControllerDelegate> delegate;

@end
