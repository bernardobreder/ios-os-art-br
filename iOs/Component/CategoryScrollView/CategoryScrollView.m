////
////  CategoryScrollView.m
////  iOs
////
////  Created by Bernardo Breder on 21/03/14.
////  Copyright (c) 2014 Bernardo Breder. All rights reserved.
////
//
//#import "CategoryScrollView.h"
//#import "CategoryPictureView.h"
//
//@implementation CategoryScrollView
//
//- (id)init
//{
//    self = [super init];
//    self.pagingEnabled = TRUE;
//    self.showsHorizontalScrollIndicator = false;
//    return self;
//}
//
//- (CategoryPictureView*)currentCategoryPictureView
//{
//    NSInteger index = [self pageIndex];
//    return self.array[index];
//}
//
//- (void)layoutSubviewsFromRect:(CGRect)fromRect toRect:(CGRect)toRect
//{
//    CGRect rect = self.frame;
//    if (self.subviews.count == 0 && array != 0) {
//        for (int n = 0; n < array.count ; n++) {
//            PictureView* view = (PictureView*)[array objectAtIndex:n];
//            [self addSubview:view];
//        }
//    }
//    if (self.contentSize.width != rect.size.width * self.array.count) {
//        self.contentSize = CGSizeMake(rect.size.width * self.array.count, rect.size.height);
//        for (int n = 0; n < array.count ; n++) {
//            PictureView* view = (PictureView*)[array objectAtIndex:n];
//            int x = (0.5 + n) * rect.size.width - rect.size.width * 0.4;
//            int y = rect.size.height * 0.1;
//            int w = rect.size.width * 0.8;
//            int h = rect.size.height * 0.6;
//            view.frame = CGRectMake(x, y, w, h);
//            [view setNeedsDisplay];
//        }
//    }
//    [super layoutSubviews];
//}
//
//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//    CGSize size = UIInterfaceOrientationIsPortrait(toInterfaceOrientation) ? CGSizeMake(MIN(self.frame.size.width,self.frame.size.height), MAX(self.frame.size.width,self.frame.size.height)) : CGSizeMake(MAX(self.frame.size.width,self.frame.size.height), MIN(self.frame.size.width,self.frame.size.height));
//    CGSize oldSize = UIInterfaceOrientationIsPortrait(toInterfaceOrientation) ? CGSizeMake(MAX(self.frame.size.width,self.frame.size.height), MIN(self.frame.size.width,self.frame.size.height)) : CGSizeMake(MIN(self.frame.size.width,self.frame.size.height), MAX(self.frame.size.width,self.frame.size.height));
//    int pageIndex = self.contentOffset.x / oldSize.width;
//    [self scrollRectToVisible:CGRectMake(pageIndex * size.width, 0, size.width, size.height) animated:YES];
//}
//
//@end
