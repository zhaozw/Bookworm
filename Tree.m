//
//  Tree.m
//  MyLauncher
//
//  Created by ramonqlee on 10/15/12.
//
//

#import "Tree.h"


@implementation Tree

@dynamic name;
@dynamic author;
@dynamic image;
@dynamic summary;
@dynamic url;
@dynamic filename;
@dynamic filesize;
@dynamic category;
@dynamic time;
@dynamic subcategory;
@dynamic index;

#define get(name) -(NSString*) name\
{\
    return _##name;\
}

//getter
get(name)
get(author)
get(image)
get(summary);
get(url);
get(filename);
get(filesize);
get(category);
get(subcategory);
get(index);

-(NSDate*)time
{
    return _time;
}

//setter
-(void)setTime:(NSDate *)time
{
    _time = time;
}
-(void)setCategory:(NSString *)category
{
    _category = category;
}
-(void)setFilesize:(NSString *)filesize
{
    _filesize=filesize;
}
-(void)setFilename:(NSString *)filename
{
    _filename = filename;
}
-(void)setUrl:(NSString *)url
{
    _url = url;
}
-(void)setSummary:(NSString *)summary
{
    _summary = summary;
}
-(void)setImage:(NSString *)image
{
    _image = image;
}
-(void)setAuthor:(NSString *)author
{
    _author = author;
}
-(void)setName:(NSString*)name
{
    _name = name;
}
-(void)setIndex:(NSString *)index
{
    _index = index;
}


//



@end
