//
//  GalleryManagerPictureAddViewController.m
//  iOs
//
//  Created by Bernardo Breder on 18/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "GalleryManagerPictureAddViewController.h"
#import "GalleryDatabase.h"
#import "GalleryPicture.h"
#import "UIImage+Resize.h"
#import "UIImage+Extras.h"

@interface GalleryManagerPictureAddViewController ()

@end

@implementation GalleryManagerPictureAddViewController

@synthesize category;
@synthesize picture;
@synthesize pictureManagerViewController;
@synthesize picker;
@synthesize image;

#pragma mark - Component

- (id)init
{
    if (!(self = [super init])) return nil;
    return self;
}

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
            [button setTitle:@"Cancelar" forState:UIControlStateNormal];
            [button setTitleColor:([UIColor blueColor]) forState:UIControlStateNormal];
            [button addTarget:self action:@selector(onCancelAction:) forControlEvents:UIControlEventTouchUpInside];
            [[self.view viewWithTag:2] addSubview:button];
        }
        {
            UIButton* button = [[UIButton alloc] init];
            button.tag = 23;
            if (category) {
                [button setTitle:@"Salvar" forState:UIControlStateNormal];
            } else {
                [button setTitle:@"Criar" forState:UIControlStateNormal];
            }
            [button setTitleColor:([UIColor blueColor]) forState:UIControlStateNormal];
            [button setTitleColor:([UIColor grayColor]) forState:UIControlStateDisabled];
            [button addTarget:self action:@selector(onCreateAction:) forControlEvents:UIControlEventTouchUpInside];
            [[self.view viewWithTag:2] addSubview:button];
        }
    }
    {
        UIScrollView* scrollView = [[UIScrollView alloc] init];
        scrollView.tag = 3;
        scrollView.backgroundColor = [UIColor whiteColor];
        [[self.view viewWithTag:1] addSubview:scrollView];
		{
			UIImageView* imageView = [[UIImageView alloc] init];
			imageView.tag = 301;
            imageView.userInteractionEnabled = true;
            imageView.layer.borderWidth = 1.0;
            imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
            imageView.layer.cornerRadius = 5.0;
            if (picture) {
                imageView.image = picture.largeImage;
            }
			[scrollView addSubview:imageView];
        }
        {
            UILabel* label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentRight;
            label.text = @"Título :";
            label.tag = 311;
            [scrollView addSubview:label];
        }
        {
            UITextField* field = [[UITextField alloc] init];
            field.tag = 312;
            field.borderStyle = UITextBorderStyleRoundedRect;
            field.returnKeyType = UIReturnKeyNext;
            field.delegate = self;
            if (picture) {
                field.text = picture.title;
            }
            [scrollView addSubview:field];
        }
        {
            UILabel* label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentRight;
            label.text = @"Valor(R$) :";
            label.tag = 321;
            [scrollView addSubview:label];
        }
        {
            UITextField* field = [[UITextField alloc] init];
            field.tag = 322;
            field.borderStyle = UITextBorderStyleRoundedRect;
            field.keyboardType = UIKeyboardTypeDecimalPad;
            field.returnKeyType = UIReturnKeyDone;
            field.delegate = self;
            if (picture) {
                field.text = [NSString stringWithFormat:@"%.2f", picture.value];
            }
            [scrollView addSubview:field];
        }
        {
            UILabel* label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentRight;
            label.text = @"Descrição :";
            label.tag = 331;
            [scrollView addSubview:label];
        }
        {
            UITextView* field = [[UITextView alloc] init];
            field.tag = 332;
            field.layer.borderWidth = 1.0;
            field.layer.cornerRadius = 5.0;
            field.layer.borderColor = [[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0] CGColor];
            field.returnKeyType = UIReturnKeyDone;
            if (picture) {
                field.text = picture.describer;
            }
            [scrollView addSubview:field];
        }
        {
            UILabel* label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentRight;
            label.text = @"Largura(cm) :";
            label.tag = 341;
            [scrollView addSubview:label];
        }
        {
            UITextField* field = [[UITextField alloc] init];
            field.tag = 342;
            field.borderStyle = UITextBorderStyleRoundedRect;
            field.returnKeyType = UIReturnKeyDone;
            field.keyboardType = UIKeyboardTypeDecimalPad;
            field.delegate = self;
            if (picture) {
                field.text = [NSString stringWithFormat:@"%.2f", picture.width];
            }
            [scrollView addSubview:field];
        }
        {
            UILabel* label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentRight;
            label.text = @"Altura(cm) :";
            label.tag = 351;
            [scrollView addSubview:label];
        }
        {
            UITextField* field = [[UITextField alloc] init];
            field.tag = 352;
            field.borderStyle = UITextBorderStyleRoundedRect;
            field.returnKeyType = UIReturnKeyDone;
            field.keyboardType = UIKeyboardTypeDecimalPad;
            field.delegate = self;
            if (picture) {
                field.text = [NSString stringWithFormat:@"%.2f", picture.height];
            }
            [scrollView addSubview:field];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	{
		UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onChangeImage:)];
		[[self.view viewWithTag:301] addGestureRecognizer:tapRecognizer];
	}
    if (picture) {
        image = picture.largeImage;
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
    {
        CGRect frame = CGRectMake(0, 0, toRect.size.width, 0);
		CGFloat y = 0;
		[self.view viewWithTag:301].frame = CGRectMake(10, 10, frame.size.width-20, frame.size.width-20);
		y += frame.size.width;
        [self.view viewWithTag:311].frame = CGRectMake(0, y, frame.size.width/3, 30);
        [self.view viewWithTag:312].frame = CGRectMake(frame.size.width/3 + 10, y, frame.size.width/3*2 - 20, 30);
        [self.view viewWithTag:321].frame = CGRectMake(0, y+40, frame.size.width/3, 30);
        [self.view viewWithTag:322].frame = CGRectMake(frame.size.width/3 + 10, y+40, frame.size.width/3*2 - 20, 30);
        [self.view viewWithTag:331].frame = CGRectMake(0, y+80, frame.size.width/3, 110);
        [self.view viewWithTag:332].frame = CGRectMake(frame.size.width/3 + 10, y+80, frame.size.width/3*2 - 20, 110);
        [self.view viewWithTag:341].frame = CGRectMake(0, y+200, frame.size.width/3, 30);
        [self.view viewWithTag:342].frame = CGRectMake(frame.size.width/3 + 10, y+200, frame.size.width/3*2 - 20, 30);
        [self.view viewWithTag:351].frame = CGRectMake(0, y+240, frame.size.width/3, 30);
        [self.view viewWithTag:352].frame = CGRectMake(frame.size.width/3 + 10, y+240, frame.size.width/3*2 - 20, 30);
        UIScrollView* scrollView = (UIScrollView*)[self.view viewWithTag:3];
        scrollView.contentSize = CGSizeMake(frame.size.width, 280 + frame.size.width);
    }
    {
        if (picture) {
            UIImageView* imageView = (UIImageView*)[self.view viewWithTag:301];
            imageView.image = [picture.largeImage boxToSize:imageView.frame.size];
        }
    }
}

#pragma mark - Actions

- (void)onCancelAction:(UIButton*)button
{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)onCreateAction:(UIButton*)button
{
    NSString* title = ((UITextField*)[self.view viewWithTag:312]).text;
    double value = [((UITextField*)[self.view viewWithTag:322]).text doubleValue];
    NSString* describer = ((UITextField*)[self.view viewWithTag:332]).text;
    double width = [((UITextField*)[self.view viewWithTag:342]).text doubleValue];
    double height = [((UITextField*)[self.view viewWithTag:352]).text doubleValue];
    GalleryDatabase* database = self.pictureManagerViewController.categoryManagerViewController.mainViewController.database;
    [database begin];
    if (picture) {
        if ([database.picture update:picture.Id title:title describer:describer value:value width:width height:height image:image]) {
            picture.title = title;
            picture.describer = describer;
            picture.value = value;
            picture.width = width;
            picture.height = height;
            picture.smallImage = [image scaledProporcionalToSize:CGSizeMake(100, 100)];
            picture.largeImage = [image scaledProporcionalToSize:CGSizeMake(2000, 2000)];
            [database commit];
            [self.pictureManagerViewController updatePicture:picture];
            [self dismissViewControllerAnimated:true completion:nil];
        } else {
            [database rollback];
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Editar" message:@"Não foi possível salvar as modificações do quadro." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
        }
    } else {
        NSInteger Id = [database.picture create:title describer:describer value:value width:width height:height image:image];
        if (Id) {
            if ([database.category addChild:category.Id picture:Id]) {
                GalleryPicture* data = [[GalleryPicture alloc] initWithId:Id andTitle:title];
                data.describer = describer;
                data.value = value;
                data.width = width;
                data.height = height;
                data.smallImage = [image scaledProporcionalToSize:CGSizeMake(100, 100)];
                data.largeImage = [image scaledProporcionalToSize:CGSizeMake(2000, 2000)];
                [database commit];
                [self.pictureManagerViewController addPicture:data];
                [self dismissViewControllerAnimated:true completion:nil];
            } else {
                [database rollback];
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Criar" message:@"Não foi possível criar a hierarquia pai e filho da categoria com o quadro." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alertView show];
            }
        } else {
            [database rollback];
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Criar" message:@"Não foi possível criar o quadro. Verifica se não possui um campo obrigatório ou um já existente." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([[self.view viewWithTag:312] isFirstResponder]) {
        UITextField* field = (UITextField*)[self.view viewWithTag:312];
        if (field.text.length == 0) {
            return NO;
        }
        [[self.view viewWithTag:322] becomeFirstResponder];
        return YES;
    } else if ([[self.view viewWithTag:322] isFirstResponder]) {
        UITextField* field = (UITextField*)[self.view viewWithTag:322];
        if (field.text.length == 0) {
            return NO;
        }
        [[self.view viewWithTag:332] becomeFirstResponder];
        return YES;
    } else if ([[self.view viewWithTag:332] isFirstResponder]) {
        UITextField* field = (UITextField*)[self.view viewWithTag:332];
        if (field.text.length == 0) {
            return NO;
        }
        [[self.view viewWithTag:342] becomeFirstResponder];
        return YES;
    } else if ([[self.view viewWithTag:342] isFirstResponder]) {
        UITextField* field = (UITextField*)[self.view viewWithTag:342];
        if (field.text.length == 0) {
            return NO;
        }
        [[self.view viewWithTag:352] becomeFirstResponder];
        return YES;
    } else if ([[self.view viewWithTag:352] isFirstResponder]) {
        UITextField* field = (UITextField*)[self.view viewWithTag:352];
        if (field.text.length == 0) {
            return NO;
        }
        [field resignFirstResponder];
        [self onCreateAction:nil];
        return YES;
    }
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self.view viewWithTag:312] resignFirstResponder];
    [[self.view viewWithTag:322] resignFirstResponder];
    [[self.view viewWithTag:332] resignFirstResponder];
    [[self.view viewWithTag:342] resignFirstResponder];
    [[self.view viewWithTag:352] resignFirstResponder];
}

#pragma mark UIImagePickeerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {    
	UIImageView *imageView = (UIImageView*)[self.view viewWithTag:301];
    image = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
	imageView.image = [image boxToSize:imageView.frame.size];
	picture.smallImage = [image boxToSize:CGSizeMake(100, 100)];
	picture.largeImage = [image boxToSize:CGSizeMake(2000, 2000)];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Actions

- (void)onChangeImage:(UIImageView*)imageView
{
	if (!picker) {
        picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
    }
    [self presentViewController:picker animated:YES completion:nil];
}

@end
