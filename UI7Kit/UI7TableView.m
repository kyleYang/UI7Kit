//
//  UI7TableView.m
//  FoundationExtension
//
//  Created by Jeong YunWon on 13. 6. 12..
//  Copyright (c) 2013 youknowone.org. All rights reserved.
//

#import "UI7Font.h"
#import "UI7Color.h"

#import "UI7TableView.h"

//NSMutableDictionary *UI7TableViewStyleIsGrouped = nil;

@implementation UITableView (Patch)

- (id)__initWithCoder:(NSCoder *)aDecoder { assert(NO); return nil; }
- (id)__initWithFrame:(CGRect)frame { assert(NO); return nil; }
- (void)__setDelegate:(id<UITableViewDelegate>)delegate { assert(NO); return; }
- (UITableViewStyle)__style { assert(NO); return 0; }

- (void)_tableViewInit {

}

- (void)__dealloc { assert(NO); }
- (void)_dealloc {
//    if ([UI7TableViewStyleIsGrouped containsKey:self.pointerString]) {
//        [UI7TableViewStyleIsGrouped removeObjectForKey:self.pointerString];
//    }
    [self __dealloc];
}

@end


@implementation NSCoder (UI7TableView)

- (NSInteger)__decodeIntegerForKey:(NSString *)key { assert(NO); }

- (NSInteger)_UI7TableView_decodeIntegerForKey:(NSString *)key {
    if ([key isEqualToString:@"UIStyle"]) {
        return (NSInteger)UITableViewStylePlain;
    }
    return [self __decodeIntegerForKey:key];
}

@end


@protocol UI7TableViewDelegate

- (UIView *)__tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
- (UIView *)__tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;
- (CGFloat)__tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)__tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;

@end


@implementation UI7TableView

// TODO: implement 'setAccessoryType' to fake accessories.

+ (void)initialize {
    if (self == [UI7TableView class]) {
//        UI7TableViewStyleIsGrouped = [[NSMutableDictionary alloc] init];

        Class target = [UITableView class];

        [target copyToSelector:@selector(__dealloc) fromSelector:@selector(dealloc)];
        [target copyToSelector:@selector(__initWithCoder:) fromSelector:@selector(initWithCoder:)];
        [target copyToSelector:@selector(__initWithFrame:) fromSelector:@selector(initWithFrame:)];
        [target copyToSelector:@selector(__setDelegate:) fromSelector:@selector(setDelegate:)];
        [target copyToSelector:@selector(__style) fromSelector:@selector(style)];
    }
}

+ (void)patch {
    Class target = [UITableView class];

    [self exportSelector:@selector(dealloc) toClass:target];
    [self exportSelector:@selector(initWithCoder:) toClass:target];
    [self exportSelector:@selector(initWithFrame:) toClass:target];
    [self exportSelector:@selector(setDelegate:) toClass:target];
    [self exportSelector:@selector(style) toClass:target];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
//    UITableViewStyle style = UITableViewStylePlain;
//    if ([aDecoder containsValueForKey:@"UIStyle"]) {
//        style = [aDecoder decodeIntegerForKey:@"UIStyle"];
//        if (style == UITableViewStyleGrouped) {
//            NSAMethod *decode = [aDecoder.class methodForSelector:@selector(decodeIntegerForKey:)];
//            [aDecoder.class methodForSelector:@selector(__decodeIntegerForKey:)].implementation = decode.implementation;
//            decode.implementation = [aDecoder.class methodForSelector:@selector(_UI7TableView_decodeIntegerForKey:)].implementation;
//        }
//    }
    self = [self __initWithCoder:aDecoder];
//    if (style == UITableViewStyleGrouped) {
//        NSAMethod *decode = [aDecoder.class methodForSelector:@selector(decodeIntegerForKey:)];
//        decode.implementation = [aDecoder.class methodImplementationForSelector:@selector(__decodeIntegerForKey:)];
//        if (self) {
//            [UI7TableViewStyleIsGrouped setObject:@(YES) forKey:self.pointerString];
//        }
//    }
    if (self) {
        if (self.__style == UITableViewStyleGrouped) {
            self.backgroundColor = [UIColor clearColor];
            self.backgroundView = nil;
            if (self.separatorStyle == UITableViewCellSeparatorStyleSingleLineEtched) {
                self.separatorStyle = UITableViewCellSeparatorStyleNone;
            }
        }
        [self _tableViewInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [self __initWithFrame:frame];
    if (self) {
        [self _tableViewInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [self __initWithFrame:frame];
    if (self) {
//        [UI7TableViewStyleIsGrouped setObject:@(YES) forKey:self.pointerString];
        [self _tableViewInit];
    }
    return self;
}

- (void)dealloc {
    [self _dealloc];
    return;
    [super dealloc];
}

- (UITableViewStyle)style {
    return UITableViewStylePlain;
}

CGFloat _UI7TableViewDelegateNoHeightForHeaderFooterInSection(id self, SEL _cmd, UITableView *tableView, NSUInteger section) {
    return -1.0f;
}

CGFloat _UI7TableViewDelegateHeightForHeaderInSection(id self, SEL _cmd, UITableView *tableView, NSUInteger section) {
    CGFloat height = [self __tableView:tableView heightForHeaderInSection:section];
    if (height != -1.0f) {
        return height;
    }
    height = .0f;
    NSString *title = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
//    if ([UI7TableViewStyleIsGrouped containsKey:tableView.pointerString]) {
    if (tableView.__style == UITableViewStyleGrouped) {
        if (title) {
            height = 55.0f;
        } else {
            height = 30.0f;
        }
    } else {
        if (title) {
            height = tableView.sectionHeaderHeight;
        }
    }
    return height;
}

CGFloat _UI7TableViewDelegateHeightForFooterInSection(id self, SEL _cmd, UITableView *tableView, NSUInteger section) {
    CGFloat height = [self __tableView:tableView heightForFooterInSection:section];
    if (height != -1.0f) {
        return height;
    }
    NSString *title = [tableView.dataSource tableView:tableView titleForFooterInSection:section];
    if (title) {
        return tableView.sectionFooterHeight;
    }
    return .0;
}

UIView *_UI7TableViewDelegateNilViewForHeaderFooterInSection(id self, SEL _cmd, UITableView *tableView, NSUInteger section) {
    return nil;
}

UIView *_UI7TableViewDelegateViewForHeaderInSection(id self, SEL _cmd, UITableView *tableView, NSUInteger section) {
    UIView *view = [self __tableView:tableView viewForHeaderInSection:section];
    if (view) {
        return view;
    }
    BOOL grouped = tableView.__style == UITableViewStyleGrouped;
    CGFloat height = [tableView.delegate tableView:tableView heightForHeaderInSection:section];
    NSString *title = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
    if (title == nil) {
        if (grouped) {
            UIView *header = [[[UIView alloc] initWithFrame:CGRectMake(.0, .0, tableView.frame.size.width, 30.0f)] autorelease];
            header.backgroundColor = [UI7Color groupedTableViewSectionBackgroundColor];
            return header;
        } else {
            return [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        }
    }

    CGFloat groupHeight = grouped ? 30.0f : .0f;
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(.0, groupHeight, tableView.frame.size.width, height - groupHeight)] autorelease];
    if (grouped) {
        label.backgroundColor = [UI7Color groupedTableViewSectionBackgroundColor];
    } else {
        label.backgroundColor = [UI7Kit kit].backgroundColor;
    }

    if (grouped) {
        label.text = [@"   " stringByAppendingString:[title uppercaseString]];
        label.font = [UI7Font systemFontOfSize:14.0 attribute:UI7FontAttributeLight];
        label.textColor = [UIColor darkGrayColor];
    } else {
        label.text = [@"    " stringByAppendingString:title];
        label.font = [UI7Font systemFontOfSize:14.0 attribute:UI7FontAttributeBold];
    }

    if (grouped) {
        view = [[[UIView alloc] initWithFrame:CGRectMake(.0, .0, tableView.frame.size.width, height)] autorelease];
        [view addSubview:label];
        view.backgroundColor = label.backgroundColor;
    } else {
        view = label;
    }
    return view;
}

UIView *_UI7TableViewDelegateViewForFooterInSection(id self, SEL _cmd, UITableView *tableView, NSUInteger section) {
    UIView *view = [self __tableView:tableView viewForFooterInSection:section];
    if (view) {
        return view;
    }
    CGFloat height = [tableView.delegate tableView:tableView heightForFooterInSection:section];
    NSString *title = [tableView.dataSource tableView:tableView titleForFooterInSection:section];
    if (title == nil) {
        return [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    }
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(.0, .0, tableView.frame.size.width, height)] autorelease];
    label.backgroundColor = [UI7Kit kit].backgroundColor;
    if (tableView.__style == UITableViewStyleGrouped) {
        label.text = [@"   " stringByAppendingString:[title uppercaseString]];
        label.font = [UI7Font systemFontOfSize:14.0 attribute:UI7FontAttributeLight];
        label.textColor = [UIColor darkGrayColor];
    } else {
        label.text = [@"    " stringByAppendingString:title]; // TODO: do this pretty later
        label.font = [UI7Font systemFontOfSize:14.0 attribute:UI7FontAttributeBold];
    }
    return label;
}

- (void)setDelegate:(id<UITableViewDelegate>)delegate {
    if (self.delegate) {
//        Class delegateClass = [(NSObject *)self.delegate class];
//        if ([delegateClass methodImplementationForSelector:@selector(tableView:viewForHeaderInSection:)] == (IMP)UI7TableViewDelegateViewForHeaderInSection) {
//            // TODO: probably we should remove this methods.
//            //            class_removeMethods(￼, ￼)
//        }
    }
    if (delegate) {
        Class delegateClass = [(NSObject *)delegate class];
        if ([self.dataSource respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
            if ([delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)] && ![delegate respondsToSelector:@selector(__tableView:viewForHeaderInSection:)]) {
                [delegateClass addMethodForSelector:@selector(__tableView:viewForHeaderInSection:) fromMethod:[delegateClass methodForSelector:@selector(tableView:viewForHeaderInSection:)]];
                [delegateClass methodForSelector:@selector(tableView:viewForHeaderInSection:)].implementation = (IMP)_UI7TableViewDelegateViewForHeaderInSection;
            } else {
                [delegateClass addMethodForSelector:@selector(__tableView:viewForHeaderInSection:) implementation:(IMP)_UI7TableViewDelegateNilViewForHeaderFooterInSection types:@"@16@0:4@8i12"];
                [delegateClass addMethodForSelector:@selector(tableView:viewForHeaderInSection:) implementation:(IMP)_UI7TableViewDelegateViewForHeaderInSection types:@"@16@0:4@8i12"];
            }
            if ([delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)] && ![delegate respondsToSelector:@selector(__tableView:heightForHeaderInSection:)]) {
                [delegateClass addMethodForSelector:@selector(__tableView:heightForHeaderInSection:) fromMethod:[delegateClass methodForSelector:@selector(tableView:heightForHeaderInSection:)]];
                [delegateClass methodForSelector:@selector(tableView:heightForHeaderInSection:)].implementation = (IMP)_UI7TableViewDelegateHeightForHeaderInSection;
            } else {
                [delegateClass addMethodForSelector:@selector(__tableView:heightForHeaderInSection:) implementation:(IMP)_UI7TableViewDelegateNoHeightForHeaderFooterInSection types:@"f16@0:4@8i12"];
                [delegateClass addMethodForSelector:@selector(tableView:heightForHeaderInSection:) implementation:(IMP)_UI7TableViewDelegateHeightForHeaderInSection types:@"f16@0:4@8i12"];
            }
        }
        if ([self.dataSource respondsToSelector:@selector(tableView:titleForFooterInSection:)]) {
            if ([delegate respondsToSelector:@selector(tableView:viewForFooterInSection:)] && ![delegate respondsToSelector:@selector(__tableView:viewForFooterInSection:)]) {
                NSAMethod *method = [delegateClass methodForSelector:@selector(tableView:viewForFooterInSection:)];
                [delegateClass addMethodForSelector:@selector(__tableView:viewForFooterInSection:) fromMethod:method];
                method.implementation = (IMP)_UI7TableViewDelegateViewForHeaderInSection;
            } else {
                [delegateClass addMethodForSelector:@selector(__tableView:viewForFooterInSection:) implementation:(IMP)_UI7TableViewDelegateNilViewForHeaderFooterInSection types:@"@16@0:4@8i12"];
                [delegateClass addMethodForSelector:@selector(tableView:viewForFooterInSection:) implementation:(IMP)_UI7TableViewDelegateViewForFooterInSection types:@"@16@0:4@8i12"];
            }
            if ([delegate respondsToSelector:@selector(tableView:heightForFooterInSection:)] && ![delegate respondsToSelector:@selector(__tableView:heightForFooterInSection:)]) {
                [delegateClass addMethodForSelector:@selector(__tableView:heightForFooterInSection:) fromMethod:[delegateClass methodForSelector:@selector(tableView:heightForFooterInSection:)]];
                [delegateClass methodForSelector:@selector(tableView:heightForFooterInSection:)].implementation = (IMP)_UI7TableViewDelegateHeightForFooterInSection;
            } else {
                [delegateClass addMethodForSelector:@selector(__tableView:heightForFooterInSection:) implementation:(IMP)_UI7TableViewDelegateNoHeightForHeaderFooterInSection types:@"f16@0:4@8i12"];
                [delegateClass addMethodForSelector:@selector(tableView:heightForFooterInSection:) implementation:(IMP)_UI7TableViewDelegateHeightForFooterInSection types:@"f16@0:4@8i12"];
            }
        }
    }
    [self __setDelegate:delegate];
}

// TODO: ok.. do this next time.
//- (BOOL)_delegateWantsHeaderViewForSection:(NSUInteger)section {
//    return YES;
//}
//
//- (BOOL)_delegateWantsHeaderTitleForSection:(NSUInteger)section {
//    return YES;
//}
//
//- (UITableViewHeaderFooterView *)headerViewForSection:(NSInteger)section {
//    UITableViewHeaderFooterView *view = [super headerViewForSection:section];
//    
//    return view;
//}

@end


@interface UITableViewCell (Patch)

// backup
- (id)__initWithCoder:(NSCoder *)aDecoder;
- (id)__initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end


@implementation UITableViewCell (Patch)

- (id)__initWithCoder:(NSCoder *)aDecoder { assert(NO); return nil; }
- (id)__initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier { assert(NO); return nil; }

- (void)_tableViewCellInit {
    self.textLabel.font = [UI7Font systemFontOfSize:18.0 attribute:UI7FontAttributeLight];
    self.detailTextLabel.font = [UI7Font systemFontOfSize:17.0 attribute:UI7FontAttributeLight]; // FIXME: not sure
    self.textLabel.highlightedTextColor = self.textLabel.textColor;
    self.detailTextLabel.highlightedTextColor = self.detailTextLabel.textColor; // FIXME: not sure
    self.selectedBackgroundView = [UIColor colorWith8bitWhite:217 alpha:255].image.view;
}

@end


@implementation UI7TableViewCell

+ (void)initialize {
    if (self == [UI7TableViewCell class]) {
        Class target = [UITableViewCell class];

        [target copyToSelector:@selector(__initWithCoder:) fromSelector:@selector(initWithCoder:)];
        [target copyToSelector:@selector(__initWithStyle:reuseIdentifier:) fromSelector:@selector(initWithStyle:reuseIdentifier:)];
    }
}

+ (void)patch {
    Class target = [UITableViewCell class];

    [self exportSelector:@selector(initWithCoder:) toClass:target];
    [self exportSelector:@selector(initWithStyle:reuseIdentifier:) toClass:target];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [self __initWithCoder:aDecoder];
    if (self != nil) {
        [self _tableViewCellInit];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [self __initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        [self _tableViewCellInit];
    }
    return self;
}

@end


@implementation UI7TableViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = [super tableView:tableView heightForHeaderInSection:section];
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [super tableView:tableView viewForHeaderInSection:section];
    return view;
}

@end
