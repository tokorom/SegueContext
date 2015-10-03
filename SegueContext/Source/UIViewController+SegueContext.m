//
//  UIViewController+SegueContext.m
//
//  Created by ToKoRo on 2015-07-14.
//

#import "UIViewController+SegueContext.h"

@interface UIViewController ()
- (void)swc_prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
@end 

@implementation UIViewController (SegueContext)

#ifdef DISABLE_SWIZZLING

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self performSelector:@selector(swc_prepareForSegue:sender:) withObject:segue withObject:sender];
}

#pragma clang diagnostic pop

#endif

@end
