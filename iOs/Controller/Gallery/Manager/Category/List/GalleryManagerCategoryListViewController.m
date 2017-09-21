//
//  GalleryManagerViewController.m
//  iOs
//
//  Created by Bernardo Breder on 15/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "GalleryManagerCategoryListViewController.h"
#import "GalleryManagerPictureListViewController.h"
#import "GalleryManagerCategoryAddViewController.h"
#import "UIImage+Resize.h"
#import "UIImage+Extras.h"

@interface GalleryManagerCategoryListViewController ()

@end

@implementation GalleryManagerCategoryListViewController

@synthesize mainViewController;
@synthesize array;
@synthesize firsts;

- (id)init
{
    if (!(self = [super init])) return nil;
    return self;
}

#pragma mark - Load

- (void)loadView
{
    self.view = [[UIView alloc] init];
    {
        UIView* bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
        bgView.tag = 1;
        [self.view addSubview:bgView];
    }
    {
        UIView* menuView = [[UIView alloc] init];
        menuView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
        menuView.tag = 2;
        [[self.view viewWithTag:1] addSubview:menuView];
        {
            UIButton* button = [[UIButton alloc] init];
            button.tag = 21;
            [button setTitle:@"Voltar" forState:UIControlStateNormal];
            [button setTitleColor:([UIColor blueColor]) forState:UIControlStateNormal];
            [button addTarget:self action:@selector(onBackAction:) forControlEvents:UIControlEventTouchUpInside];
            [[self.view viewWithTag:2] addSubview:button];
        }
        {
            UIButton* button = [[UIButton alloc] init];
            button.tag = 22;
            [button setTitle:@"Adicionar" forState:UIControlStateNormal];
            [button setTitleColor:([UIColor blueColor]) forState:UIControlStateNormal];
            [button addTarget:self action:@selector(onAddAction:) forControlEvents:UIControlEventTouchUpInside];
            [[self.view viewWithTag:2] addSubview:button];
        }
        {
            UIButton* button = [[UIButton alloc] init];
            button.tag = 23;
            [button setTitle:@"Editar" forState:UIControlStateNormal];
            [button setTitleColor:([UIColor blueColor]) forState:UIControlStateNormal];
            [button addTarget:self action:@selector(onEditAction:) forControlEvents:UIControlEventTouchUpInside];
            [[self.view viewWithTag:2] addSubview:button];
        }
    }
    {
        UIView* view = [[UIView alloc] init];
        view.tag = 4;
        [[self.view viewWithTag:1] addSubview:view];
        {
            UILabel* label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"Categoria";
            [view addSubview:label];
        }
    }
    {
        UITableView* tableView = [[UITableView alloc] init];
        tableView.tag = 3;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.allowsSelectionDuringEditing = true;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        [[self.view viewWithTag:1] addSubview:tableView];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    array = [mainViewController.database.category list];
    firsts = [[NSMutableArray alloc] init];
    for (GalleryCategory *category in array) {
        GalleryPicture *picture = [mainViewController.database.picture first:category.Id];
        if (picture) {
            [firsts addObject:picture.smallImage];
        } else {
            [firsts addObject:[UIImage imageNamed:@"noimage.jpg"]];
        }
    }
}

- (void)layoutSubviewsFromRect:(CGRect)fromRect toRect:(CGRect)toRect
{
    [self.view viewWithTag:1].frame = CGRectMake(0, 0, toRect.size.width, toRect.size.height);
    {
        CGRect frame = toRect;
        [self.view viewWithTag:2].frame = CGRectMake(0, 0, frame.size.width, 70);
        [self.view viewWithTag:3].frame = CGRectMake(0, 71, frame.size.width, frame.size.height - 71);
    }
    {
        CGRect frame = toRect;
        [self.view viewWithTag:21].frame = CGRectMake(0, 20, frame.size.width/3, 50);
        [self.view viewWithTag:22].frame = CGRectMake(frame.size.width/3, 20, frame.size.width/3, 50);
        [self.view viewWithTag:23].frame = CGRectMake(frame.size.width/3*2, 20, frame.size.width/3, 50);
    }
}

#pragma mark - Api

- (void)addCategory:(GalleryCategory*)category;
{
    UITableView* tableView = (UITableView*)[self.view viewWithTag:3];
    [array addObject:category];
    [firsts addObject:[UIImage imageNamed:@"noimage.jpg"]];
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(array.count-1) inSection:0];
    [tableView beginUpdates];
    [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [tableView endUpdates];
}

- (void)updateCategory:(GalleryCategory*)category;
{
    UITableView* tableView = (UITableView*)[self.view viewWithTag:3];
    NSInteger index = -1;
    for (int n = 0; n < array.count ; n++) {
        GalleryCategory* other = array[n];
        if (other.Id == category.Id) {
            index = n;
            break;
        }
    }
    if (index < 0) {
        return;
    }
    [array setObject:category atIndexedSubscript:index];
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [tableView beginUpdates];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [tableView endUpdates];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GalleryCategory* category = array[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = category.title;
    cell.detailTextLabel.text = category.description;
    UIImage *image = firsts[indexPath.row];
    cell.imageView.image = [image imageByBestFitForSize:CGSizeMake(tableView.rowHeight, tableView.rowHeight)];
	return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        GalleryPicture* picture = array[indexPath.row];
        [array removeObjectAtIndex:indexPath.row];
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [tableView endUpdates];
        [mainViewController.database begin];
        [mainViewController.database.category remove:picture.Id];
        [mainViewController.database commit];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if (sourceIndexPath.row == destinationIndexPath.row) return;
	GalleryPicture* sourceData = [array objectAtIndex:sourceIndexPath.row];
    GalleryPicture* targetData = [array objectAtIndex:destinationIndexPath.row];
    {
        [array removeObjectAtIndex:sourceIndexPath.row];
        [array insertObject:sourceData atIndex:destinationIndexPath.row];
    }
    {
        [mainViewController.database begin];
        if ([mainViewController.database.category order:sourceData.Id withId:targetData.Id]) {
            [mainViewController.database commit];
        } else {
            [mainViewController.database rollback];
        }
    }
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableView* tableView = (UITableView*)[self.view viewWithTag:3];
    if ([tableView isEditing]) {
        NSIndexPath* indexPath = [tableView indexPathForSelectedRow];
        GalleryCategory* category = array[indexPath.row];
        GalleryManagerCategoryAddViewController* viewController = [[GalleryManagerCategoryAddViewController alloc] init];
        viewController.managerViewController = self;
        viewController.category = category;
        viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:viewController animated:YES completion:nil];
    } else {
        NSIndexPath* indexPath = [tableView indexPathForSelectedRow];
        GalleryCategory* category = array[indexPath.row];
        GalleryManagerPictureListViewController* viewController = [[GalleryManagerPictureListViewController alloc] init];
        viewController.categoryManagerViewController = self;
        viewController.category = category;
        viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:viewController animated:YES completion:nil];
    }
}

#pragma mark - Actions

- (void)onBackAction:(UIButton*)button
{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)onAddAction:(UIButton*)button
{
    GalleryManagerCategoryAddViewController* viewController = [[GalleryManagerCategoryAddViewController alloc] init];
    viewController.managerViewController = self;
    viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)onEditAction:(UIButton*)button
{
    UITableView* tableView = (UITableView*)[self.view viewWithTag:3];
    UIButton* editButton = (UIButton*)[self.view viewWithTag:23];
    if ([tableView isEditing]) {
        [editButton setTitle:@"Editar" forState:UIControlStateNormal];
        [editButton setTitleColor:([UIColor blueColor]) forState:UIControlStateNormal];
        [tableView setEditing:NO animated:YES];
    } else {
        [editButton setTitle:@"Concluir" forState:UIControlStateNormal];
        [editButton setTitleColor:([UIColor redColor]) forState:UIControlStateNormal];
        [tableView setEditing:YES animated:YES];
    }
}

@end
