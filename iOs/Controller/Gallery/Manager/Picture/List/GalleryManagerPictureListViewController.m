//
//  GalleryManagerPictureListViewController.m
//  iOs
//
//  Created by Bernardo Breder on 18/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "GalleryManagerPictureListViewController.h"
#import "GalleryManagerPictureAddViewController.h"
#import "UIImage+Resize.h"
#import "UIImage+Extras.h"

@interface GalleryManagerPictureListViewController ()

@end

@implementation GalleryManagerPictureListViewController

@synthesize category;
@synthesize categoryManagerViewController;
@synthesize array;

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
        UITableView* tableView = [[UITableView alloc] init];
        tableView.tag = 3;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.allowsSelectionDuringEditing = true;
        tableView.allowsSelection = false;
        [[self.view viewWithTag:1] addSubview:tableView];
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    array = [categoryManagerViewController.mainViewController.database.picture list:category.Id];
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

- (void)addPicture:(GalleryPicture*)picture;
{
    UITableView* tableView = (UITableView*)[self.view viewWithTag:3];
    [array addObject:picture];
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(array.count-1) inSection:0];
    [tableView beginUpdates];
    [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [tableView endUpdates];
}

- (void)updatePicture:(GalleryPicture*)picture;
{
    UITableView* tableView = (UITableView*)[self.view viewWithTag:3];
    NSInteger index = -1;
    for (int n = 0; n < array.count ; n++) {
        GalleryPicture* other = array[n];
        if (other.Id == picture.Id) {
            index = n;
            break;
        }
    }
    if (index < 0) {
        return;
    }
    [array setObject:picture atIndexedSubscript:index];
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
    GalleryPicture* picture = array[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = picture.title;
    cell.detailTextLabel.text = picture.description;
	if (picture.smallImage) {
		cell.imageView.image = [picture.smallImage imageByBestFitForSize:CGSizeMake(tableView.rowHeight, tableView.rowHeight)];
	} else {
		cell.imageView.image = [[UIImage imageNamed:([NSString stringWithFormat:@"pic%d.jpg", (int)(indexPath.row % 5) + 1])] imageByScalingAndCroppingForSize:CGSizeMake(tableView.rowHeight, tableView.rowHeight)];
	}
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
        [categoryManagerViewController.mainViewController.database begin];
        [categoryManagerViewController.mainViewController.database.picture remove:picture.Id];
        [categoryManagerViewController.mainViewController.database commit];
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
        [categoryManagerViewController.mainViewController.database begin];
        if ([categoryManagerViewController.mainViewController.database.picture order:category.Id pictureSourceId:sourceData.Id pictureTargetId:targetData.Id]) {
            [categoryManagerViewController.mainViewController.database commit];
        } else {
            [categoryManagerViewController.mainViewController.database rollback];
        }
    }
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableView* tableView = (UITableView*)[self.view viewWithTag:3];
    if ([tableView isEditing]) {
        NSIndexPath* indexPath = [tableView indexPathForSelectedRow];
        GalleryPicture* picture = array[indexPath.row];
        GalleryManagerPictureAddViewController* viewController = [[GalleryManagerPictureAddViewController alloc] init];
        viewController.pictureManagerViewController = self;
        viewController.category = category;
        viewController.picture = picture;
        viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:viewController animated:YES completion:nil];
    } else {
        NSLog(@"Open");
    }
}

#pragma mark - Actions

- (void)onBackAction:(UIButton*)button
{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)onAddAction:(UIButton*)button
{
    GalleryManagerPictureAddViewController* viewController = [[GalleryManagerPictureAddViewController alloc] init];
    viewController.pictureManagerViewController = self;
    viewController.category = category;
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
