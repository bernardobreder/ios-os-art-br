//
//  GalleryAddViewController.m
//  iOs
//
//  Created by Bernardo Breder on 15/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "GalleryManagerCategoryAddViewController.h"

@interface GalleryManagerCategoryAddViewController ()

@end

@implementation GalleryManagerCategoryAddViewController

@synthesize category;
@synthesize managerViewController;

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
            UILabel* label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentRight;
            label.text = @"Nome :";
            label.tag = 311;
            [scrollView addSubview:label];
        }
        {
            UITextField* field = [[UITextField alloc] init];
            field.tag = 312;
            field.borderStyle = UITextBorderStyleRoundedRect;
            field.returnKeyType = UIReturnKeyNext;
            field.delegate = self;
            if (category) {
                field.text = category.name;
            }
            [scrollView addSubview:field];
        }
        {
            UILabel* label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentRight;
            label.text = @"Título :";
            label.tag = 321;
            [scrollView addSubview:label];
        }
        {
            UITextField* field = [[UITextField alloc] init];
            field.tag = 322;
            field.borderStyle = UITextBorderStyleRoundedRect;
            field.returnKeyType = UIReturnKeyDone;
            field.delegate = self;
            if (category) {
                field.text = category.title;
            }
            [scrollView addSubview:field];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self.view viewWithTag:312] becomeFirstResponder];
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
        [self.view viewWithTag:311].frame = CGRectMake(0, 10, frame.size.width/3, 30);
        [self.view viewWithTag:312].frame = CGRectMake(frame.size.width/3 + 10, 10, frame.size.width/3*2 - 20, 30);
        [self.view viewWithTag:321].frame = CGRectMake(0, 50, frame.size.width/3, 30);
        [self.view viewWithTag:322].frame = CGRectMake(frame.size.width/3 + 10, 50, frame.size.width/3*2 - 20, 30);
        UIScrollView* scrollView = (UIScrollView*)[self.view viewWithTag:3];
        scrollView.contentSize = CGSizeMake(frame.size.width, 170);
    }
}

#pragma mark - Actions

- (void)onCancelAction:(UIButton*)button
{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)onCreateAction:(UIButton*)button
{
    NSString* name = ((UITextField*)[self.view viewWithTag:312]).text;
    NSString* title = ((UITextField*)[self.view viewWithTag:322]).text;
    GalleryDatabase* database = self.managerViewController.mainViewController.database;
    [database begin];
    if (category) {
        if ([database.category update:category.Id name:name title:title]) {
            category.name = name;
            category.title = title;
            [database commit];
            [self.managerViewController updateCategory:category];
            [self dismissViewControllerAnimated:true completion:nil];
        } else {
            [database rollback];
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Editar" message:@"Não foi possível salvar as modificações da categoria." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
        }
    } else {
        int Id = [database.category create:name title:title];
        if (Id) {
            GalleryCategory* data = [[GalleryCategory alloc] initWithId:Id andName:name andTitle:title];
            [database commit];
            [self.managerViewController addCategory:data];
            [self dismissViewControllerAnimated:true completion:nil];
        } else {
            [database rollback];
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Criar" message:@"Não foi possível criar a categoria. Verifica se não possui um campo obrigatório ou um já existente." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
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

@end
