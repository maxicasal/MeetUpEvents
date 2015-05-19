
#import "RootViewController.h"
#import "EventDetailsViewController.h"

@interface RootViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *meetUpEventsOriginal;
@property NSMutableArray *meetUpEvents;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.meetUpEvents = [[NSMutableArray alloc]init];
    self.meetUpEventsOriginal = [[NSMutableArray alloc]init];

    [self loadJSONFromURL];
}

- (void)loadJSONFromURL {
    NSURL *url = [NSURL URLWithString:@"https://api.meetup.com/2/open_events.json?zip=60604&text=mobile&time=,1w&key=4ed81302d697140674520113c742c"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSArray *objectAtKey =[jsonDictionary objectForKey:@"results"];
        for (id object in objectAtKey) {
            [self.meetUpEvents addObject: object];
            [self.meetUpEventsOriginal addObject: object];
        }
        [self.tableView reloadData];
    }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *meetUpEvent = [self.meetUpEvents objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCellID" forIndexPath:indexPath];
    cell.textLabel.text = [meetUpEvent objectForKey:@"name"];
    NSString *htmlString = [meetUpEvent objectForKey:@"description"];
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    cell.detailTextLabel.attributedText = attrStr;
    
    return cell;
}
- (IBAction)onSearchButtonPressed:(id)sender {
    if ([self.searchTextField.text isEqualToString:@""]) {
        self.meetUpEvents = self.meetUpEventsOriginal;
    }else{
        self.meetUpEvents = [[NSMutableArray alloc]init];
        NSString *searchText = [self.searchTextField.text lowercaseString];
        for (int i=0; i<self.meetUpEventsOriginal.count; i++) {
            NSDictionary *meetUpEvent = [self.meetUpEventsOriginal objectAtIndex:i];
            NSString *name =[[meetUpEvent objectForKey:@"name"] lowercaseString];
            if ([name containsString:searchText]) {
                [self.meetUpEvents addObject:meetUpEvent];
            }
        }
    }
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.meetUpEvents.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    EventDetailsViewController *detailVC = segue.destinationViewController;
    detailVC.meetUpEvent = [self.meetUpEvents objectAtIndex:indexPath.row];
}

@end
