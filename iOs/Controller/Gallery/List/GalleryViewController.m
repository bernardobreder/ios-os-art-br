//
//  GalleryCategoryListViewController.m
//  iOs
//
//  Created by Bernardo Breder on 05/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

@import UIKit;
@import MediaPlayer;
@import QuartzCore;
#import "GalleryViewController.h"
#import "WallPictureView.h"
#import "PictureView.h"
#import "CategoryPictureView.h"
#import "PictureScrollView.h"
#import "UIHorizontalFillScrollView.h"
#import "WallView.h"
#import "WallScrollView.h"
#import "PunchedLayout.h"
#import "Utility.h"
#import "ReflectingView.h"
#import "PunchedLayout.h"
#import "GalleryManagerCategoryListViewController.h"
#import "CategoryScrollView.h"
#import "UIImage+Extras.h"

@interface GalleryViewController ()

@end

@implementation GalleryViewController

@synthesize secondWindow;
@synthesize imageSecondWindow;
@synthesize database;
@synthesize categorys;
@synthesize category;
@synthesize pictures;
@synthesize categoryView;

- (id)init
{
    if (!(self = [super init])) return nil;
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    //    UIView* bgView = [[UIView alloc] init];
    //    {
    //        bgView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    //        bgView.tag = 1;
    //        [self.view addSubview:bgView];
    //        [bgView setTranslatesAutoresizingMaskIntoConstraints:NO];
    //        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bgView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    //        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bgView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    //        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    //        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    //    }
    UIView* menuView = [[UIView alloc] init];
    {
        menuView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
        menuView.tag = 2;
        [self.view addSubview:menuView];
        [menuView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:menuView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:menuView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:menuView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:menuView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:0.0 constant:70]];
        {
            UIButton* button = [[UIButton alloc] init];
            button.tag = 21;
            [button setTitle:@"Comprar" forState:UIControlStateNormal];
            [button setTitleColor:([UIColor blueColor]) forState:UIControlStateNormal];
            [button setTitleColor:([UIColor lightGrayColor]) forState:UIControlStateDisabled];
            [button addTarget:self action:@selector(onBuyAction:) forControlEvents:UIControlEventTouchUpInside];
            button.enabled = false;
            [[self.view viewWithTag:2] addSubview:button];
        }
        {
            UIButton* button = [[UIButton alloc] init];
            button.tag = 22;
            [button setTitle:@"Detalhar" forState:UIControlStateNormal];
            [button setTitleColor:([UIColor blueColor]) forState:UIControlStateNormal];
            [button setTitleColor:([UIColor lightGrayColor]) forState:UIControlStateDisabled];
            [button addTarget:self action:@selector(onDetailAction:) forControlEvents:UIControlEventTouchUpInside];
            button.enabled = false;
            [[self.view viewWithTag:2] addSubview:button];
        }
        {
            UIButton* button = [[UIButton alloc] init];
            button.tag = 23;
            [button setTitle:@"Gerenciar" forState:UIControlStateNormal];
            [button setTitleColor:([UIColor blueColor]) forState:UIControlStateNormal];
            [button setTitleColor:([UIColor lightGrayColor]) forState:UIControlStateDisabled];
            [button addTarget:self action:@selector(onManagerAction:) forControlEvents:UIControlEventTouchUpInside];
            [[self.view viewWithTag:2] addSubview:button];
        }
    }
    PictureScrollView* pictureScrollView = [[PictureScrollView alloc] init];
    {
        pictureScrollView.tag = 3;
        pictureScrollView.delegate = self;
        pictureScrollView.lazyPageDataSource = self;
        pictureScrollView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:pictureScrollView];
        [pictureScrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pictureScrollView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pictureScrollView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pictureScrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:menuView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:1]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pictureScrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-100]];
    }
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
        layout.minimumLineSpacing = 10.0f;
        layout.minimumInteritemSpacing = 10.0f;
        layout.itemSize = CGSizeMake(80.0f, 80.0f);
        categoryView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        categoryView.tag = 4;
        categoryView.dataSource = self;
        categoryView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
        [self.view addSubview:categoryView];
        [categoryView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:categoryView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:categoryView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:categoryView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:pictureScrollView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:1]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:categoryView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
        [categoryView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    {
        categorys = [self.database.category list];
        if (categorys.count > 0) {
            category = categorys[0];
        }
    }
    {
        if (categorys.count == 0) {
            pictures = @[];
        } else {
            GalleryCategory *firstCategory = categorys[0];
            pictures = [self.database.picture list:firstCategory.Id];
        }
    }
    if (secondWindow) {
        UIViewController* viewController = [[UIViewController alloc] init];
        {
            viewController.view = [[UIView alloc] initWithFrame:secondWindow.bounds];
            viewController.view.backgroundColor = [UIColor whiteColor];
        }
        {
            imageSecondWindow = [[PictureView alloc] initWithFrame:secondWindow.bounds];
            [viewController.view addSubview:imageSecondWindow];
        }
        if (pictures.count > 0) {
            GalleryPicture *picture = pictures[0];
            UIImage *image = [self.database.picture largeImage:picture.Id];
            if (!image) {
                image = [UIImage imageNamed:@"noimage.jpg"];
            }
            imageSecondWindow.image = image;
        }
        secondWindow.rootViewController = viewController;
        secondWindow.hidden = NO;
    }
}

- (void)layoutSubviewsFromRect:(CGRect)fromRect toRect:(CGRect)toRect
{
    //    {
    //        CGRect frame = toRect;
    //        [self.view viewWithTag:2].frame = CGRectMake(0, 0, frame.size.width, 70);
    //        [self.view viewWithTag:4].frame = CGRectMake(0, frame.size.height - 101, frame.size.width, 100);
    //        [self.view viewWithTag:3].frame = CGRectMake(0, 71+51, frame.size.width, frame.size.height - 101 - 71 - 51 - 1);
    //    }
    {
        CGRect frame = toRect;
        [self.view viewWithTag:21].frame = CGRectMake(0, 20, frame.size.width/3, 50);
        [self.view viewWithTag:22].frame = CGRectMake(frame.size.width/3, 20, frame.size.width/3, 50);
        [self.view viewWithTag:23].frame = CGRectMake(frame.size.width/3*2, 20, frame.size.width/3, 50);
    }
    {
        {
            [self.view viewWithTag:5].frame = CGRectMake(0, 71, toRect.size.width, 50);
            [self.view viewWithTag:51].frame = CGRectMake(0, 0, toRect.size.width, 50);
        }
//        {
//            CGRect frame = toRect;
//            UIScrollView* scrollView = (UIScrollView*)[self.view viewWithTag:41];
//            scrollView.frame = CGRectMake(0, 0, frame.size.width, 100);
//            scrollView.contentSize = CGSizeMake(categorys.count * 80, 100);
//            for (int n = 0; n < categorys.count ; n++) {
//                [self.view viewWithTag:41*100+n].frame = CGRectMake(n * 80, 10, 80, 80);
//            }
//        }
    }
}

#pragma mark - UILazyPageViewDataSource

- (NSInteger)numberOfPages:(UILazyPageView*)lazyPageView
{
    return pictures.count;
}

- (UIView*)lazyPageView:(UILazyPageView*)lazyPageView pageForIndex:(NSInteger)index
{
    GalleryPicture *picture = pictures[index];
    UIImage *image = [self.database.picture largeImage:picture.Id];
    if (!image) {
        image = [UIImage imageNamed:@"noimage.jpg"];
    }
    PictureView* pictureView = [[PictureView alloc] initWithImage:image];
    return pictureView;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return categorys.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [categoryView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (![cell viewWithTag:41]) {
        CategoryPictureView* categoryPictureView = [[CategoryPictureView alloc] init];
        categoryPictureView.tag = 41;
        [cell.contentView addSubview:categoryPictureView];
        [categoryPictureView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:categoryPictureView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:categoryPictureView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:categoryPictureView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:categoryPictureView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    }
    CategoryPictureView* categoryPictureView = (CategoryPictureView*)[cell viewWithTag:41];
    [categoryPictureView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCategoryAction:)]];
    GalleryCategory *categoryItem = categorys[indexPath.row];
    UIImage* image = [self.database.picture first:categoryItem.Id].smallImage;
    if (!image) {
        image = [UIImage imageNamed:@"noimage.jpg"];
    }
    categoryPictureView.image = image;
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)refreshImageSecondWindow
{
    @autoreleasepool {
        PictureScrollView* wallScrollView = (PictureScrollView*)[self.view viewWithTag:3];
        NSInteger pageIndex = [wallScrollView pageIndex];
        GalleryPicture *picture = pictures[pageIndex];
        if (picture) {
            UIImage *image = [self.database.picture largeImage:picture.Id];
            if (!image) {
                image = [UIImage imageNamed:@"noimage.jpg"];
            }
            imageSecondWindow.image = image;
            [imageSecondWindow setNeedsDisplay];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self refreshImageSecondWindow];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self refreshImageSecondWindow];
}

#pragma mark - Actions

- (void)onDetailAction:(UIButton*)button
{
    //    CGRect frame = self.view.bounds;
    //    [UIView beginAnimations:Nil context:nil];
    //    [UIView setAnimationDuration:0.4];
    //    categoryScrollView.frame = CGRectMake(0, frame.size.height - CATEGORY_HEIGHT, frame.size.width, CATEGORY_HEIGHT);
    //    [UIView commitAnimations];
}

- (void)onBuyAction:(UIButton*)button
{
    //    CGRect frame = self.view.bounds;
    //    [UIView beginAnimations:Nil context:nil];
    //    [UIView setAnimationDuration:0.4];
    //    categoryScrollView.frame = CGRectMake(0, frame.size.height, frame.size.width, CATEGORY_HEIGHT);
    //    [UIView commitAnimations];
}

- (void)onManagerAction:(UIButton*)button
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Gerenciar" message:@"Senha" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Ok", nil];
    alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
    //    [alertView show];
    [alertView show];
    [alertView textFieldAtIndex:0].text = @"gg22";
    [alertView dismissWithClickedButtonIndex:1 animated:true];
    [self alertView:alertView clickedButtonAtIndex:1];
}

- (void)onCategoryAction:(UITapGestureRecognizer*)recognizer
{
    CGPoint point = [recognizer locationOfTouch:0 inView:[self.view viewWithTag:4]];
    int categoryIndex = floor(point.x / 100);
    if (categoryIndex < 0 || categoryIndex >= categorys.count) {
        return;
    }
    PictureScrollView* pictureScrollView = (PictureScrollView*)[self.view viewWithTag:3];
    category = categorys[categoryIndex];
    pictures = [self.database.picture list:category.Id];
    [pictureScrollView reloadData];
    NSLog(@"%@ %d", NSStringFromCGPoint(point), categoryIndex);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:@"Gerenciar"]) {
        if (buttonIndex == 1) {
            if ([[alertView textFieldAtIndex:0].text isEqualToString:@"gg22"]) {
                GalleryManagerCategoryListViewController* viewController = [[GalleryManagerCategoryListViewController alloc] init];
                viewController.mainViewController = self;
                viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                [self presentViewController:viewController animated:YES completion:nil];
            } else {
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Inválido" message:@"Senha inválida" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alertView show];
            }
        }
    } else if ([alertView.title isEqualToString:@"Comprar"]) {
        if (buttonIndex == 1) {
            if ([[alertView textFieldAtIndex:0].text isEqualToString:@"gg22"]) {
                GalleryManagerCategoryListViewController* viewController = [[GalleryManagerCategoryListViewController alloc] init];
                viewController.mainViewController = self;
                viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                [self presentViewController:viewController animated:YES completion:nil];
            } else {
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Inválido" message:@"Senha inválida" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alertView show];
            }
        }
    } else if ([alertView.title isEqualToString:@"Inválido"]) {
        [self onManagerAction:nil];
    }
}

@end
