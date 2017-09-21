//
//  MainViewController.m
//  iOSMovie
//
//  Created by Bernardo Breder on 22/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

@import UIKit;
@import QuartzCore;
@import MobileCoreServices;
@import MediaPlayer;
#import "MainViewController.h"

@interface MainViewController ()

@property (nonatomic, strong) UIButton* addButton;
@property (nonatomic, strong) UIButton* editButton;
@property (nonatomic, strong) UIButton* playButton;
@property (nonatomic, strong) UIView* navView;
@property (nonatomic, strong) UITableView* videoTableView;
@property (nonatomic, strong) NSMutableArray* videos;
@property (nonatomic, strong) UIPopoverController* popover;
@property (nonatomic, assign) NSInteger videoIndex;
@property (nonatomic, assign) bool playing;

@end

@implementation MainViewController

@synthesize navView;
@synthesize addButton;
@synthesize editButton;
@synthesize playButton;
@synthesize videoTableView;
@synthesize videos;
@synthesize popover;
@synthesize videoIndex;
@synthesize playing;
@synthesize secondWindow;

- (id)init
{
    if (!(self = [super init])) return nil;
    videos = [[NSMutableArray alloc] init];
    videoIndex = 0;
    playing = false;
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor darkGrayColor];
    {
        navView = [[UIView alloc] init];
        navView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
        [self.view addSubview:navView];
        [navView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:navView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:navView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:navView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:navView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:0.0 constant:70]];
    }
    {
        videoTableView = [[UITableView alloc] init];
        videoTableView.dataSource = self;
        [self.view addSubview:videoTableView];
        [videoTableView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:videoTableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:videoTableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:videoTableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:navView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:1.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:videoTableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:70]];
        [videoTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    }
    {
        addButton = [[UIButton alloc] init];
        [addButton setTitle:@"Adicionar" forState:UIControlStateNormal];
        [addButton setTitleColor:([UIColor blueColor]) forState:UIControlStateNormal];
        [addButton setTitleColor:([UIColor lightGrayColor]) forState:UIControlStateDisabled];
        [addButton addTarget:self action:@selector(onAddAction:) forControlEvents:UIControlEventTouchUpInside];
        [navView addSubview:addButton];
        [addButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [navView addConstraint:[NSLayoutConstraint constraintWithItem:addButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:navView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
        [navView addConstraint:[NSLayoutConstraint constraintWithItem:addButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:navView attribute:NSLayoutAttributeWidth multiplier:0.0 constant:100.0]];
        [navView addConstraint:[NSLayoutConstraint constraintWithItem:addButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:navView attribute:NSLayoutAttributeBottom multiplier:0.0 constant:20.0]];
        [navView addConstraint:[NSLayoutConstraint constraintWithItem:addButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:navView attribute:NSLayoutAttributeHeight multiplier:0.0 constant:50.0]];
    }
    {
        editButton = [[UIButton alloc] init];
        [editButton setTitle:@"Editar" forState:UIControlStateNormal];
        [editButton setTitleColor:([UIColor blueColor]) forState:UIControlStateNormal];
        [editButton setTitleColor:([UIColor lightGrayColor]) forState:UIControlStateDisabled];
        [editButton addTarget:self action:@selector(onEditAction:) forControlEvents:UIControlEventTouchUpInside];
        [navView addSubview:editButton];
        [editButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [navView addConstraint:[NSLayoutConstraint constraintWithItem:editButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:navView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:100.0]];
        [navView addConstraint:[NSLayoutConstraint constraintWithItem:editButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:navView attribute:NSLayoutAttributeWidth multiplier:0.0 constant:100.0]];
        [navView addConstraint:[NSLayoutConstraint constraintWithItem:editButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:navView attribute:NSLayoutAttributeBottom multiplier:0.0 constant:20.0]];
        [navView addConstraint:[NSLayoutConstraint constraintWithItem:editButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:navView attribute:NSLayoutAttributeHeight multiplier:0.0 constant:50.0]];
    }
    {
        playButton = [[UIButton alloc] init];
        [playButton setTitle:@"Tocar" forState:UIControlStateNormal];
        [playButton setTitleColor:([UIColor blueColor]) forState:UIControlStateNormal];
        [playButton setTitleColor:([UIColor lightGrayColor]) forState:UIControlStateDisabled];
        [playButton addTarget:self action:@selector(onPlayAction:) forControlEvents:UIControlEventTouchUpInside];
        [navView addSubview:playButton];
        [playButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [navView addConstraint:[NSLayoutConstraint constraintWithItem:playButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:navView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
        [navView addConstraint:[NSLayoutConstraint constraintWithItem:playButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:navView attribute:NSLayoutAttributeWidth multiplier:0.0 constant:100.0]];
        [navView addConstraint:[NSLayoutConstraint constraintWithItem:playButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:navView attribute:NSLayoutAttributeBottom multiplier:0.0 constant:20.0]];
        [navView addConstraint:[NSLayoutConstraint constraintWithItem:playButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:navView attribute:NSLayoutAttributeHeight multiplier:0.0 constant:50.0]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    playButton.enabled = false;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [videos removeObjectAtIndex:indexPath.row];
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [tableView endUpdates];
        if (videos.count == 0) {
            playButton.enabled = false;
        }
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if (sourceIndexPath.row == destinationIndexPath.row) return;
	NSURL* sourceData = [videos objectAtIndex:sourceIndexPath.row];
    //    NSURL* targetData = [videos objectAtIndex:destinationIndexPath.row];
    {
        [videos removeObjectAtIndex:sourceIndexPath.row];
        [videos insertObject:sourceData atIndex:destinationIndexPath.row];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return videos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [videoTableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    //    NSURL *mediaURL = videos[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"Video %ld", indexPath.row+1];
    return cell;
}

#pragma mark - UIPopoverControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (IS_IPHONE) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [popover dismissPopoverAnimated:YES];
        popover = nil;
    }
	NSURL *mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
    if (mediaURL) {
        [videos addObject:mediaURL];
        [videoTableView beginUpdates];
        [videoTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:videos.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
        [videoTableView endUpdates];
        playButton.enabled = true;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (IS_IPHONE) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [popover dismissPopoverAnimated:YES];
        popover = nil;
    }
}

#pragma mark - Actions

- (void)onAddAction:(UIButton*)button
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
	picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
    picker.mediaTypes = @[(NSString *)kUTTypeMovie];
    picker.delegate = self;
    if (IS_IPHONE) {
        [self presentViewController:picker animated:YES completion:nil];
	} else {
        popover = [[UIPopoverController alloc] initWithContentViewController:picker];
        popover.delegate = self;
        [popover presentPopoverFromRect:addButton.frame inView:addButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
}

- (void)onEditAction:(UIButton*)button
{
    if ([videoTableView isEditing]) {
        [videoTableView setEditing:NO animated:YES];
        [editButton setTitleColor:([UIColor blueColor]) forState:UIControlStateNormal];
    } else {
        [videoTableView setEditing:YES animated:YES];
        [editButton setTitleColor:([UIColor redColor]) forState:UIControlStateNormal];
    }
}

- (void)onPlayAction:(UIButton*)button
{
    if (playing) {
        playing = false;
        [playButton setTitle:@"Tocar" forState:UIControlStateNormal];
    } else {
        playing = true;
        [playButton setTitle:@"Parar" forState:UIControlStateNormal];
        [self play];
    }
}

- (void)play
{
    if (!playing) {
        return;
    }
    if (videoIndex >= videos.count) {
        videoIndex = 0;
    }
    NSURL *mediaURL = videos[videoIndex];
    videoIndex = (videoIndex + 1) % videos.count;
    MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc] initWithContentURL:mediaURL];
    player.moviePlayer.allowsAirPlay = YES;
    player.moviePlayer.fullscreen = YES;
    player.moviePlayer.shouldAutoplay = YES;
    player.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
    [self presentMoviePlayerViewControllerAnimated:player];
    [[NSNotificationCenter defaultCenter] addObserverForName:MPMoviePlayerPlaybackDidFinishNotification object:player.moviePlayer queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
        if (playing) {
            [self performSelector:@selector(play) withObject:self afterDelay:1.0];
        }
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:MPMoviePlayerLoadStateDidChangeNotification object:player.moviePlayer queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
        if ((player.moviePlayer.loadState & MPMovieLoadStatePlayable) != 0) {
            [player.moviePlayer performSelector:@selector(play) withObject:nil afterDelay:1.0f];
        }
    }];
}

@end
