
#import "EventDetailsViewController.h"
#import "WebViewController.h"

@interface EventDetailsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rsvpCountLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property NSDictionary *hostingGroup;
@end

@implementation EventDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadInformation];
}

//This method load data from the meetUpEvent to the EventDetailViewController
- (void)loadInformation {
    if (self.meetUpEvent != nil) {
        self.nameLabel.text = [self.meetUpEvent objectForKey:@"name"];
        NSString *rsvpCount =[self.meetUpEvent objectForKey:@"rsvp_limit"];
        self.rsvpCountLabel.text = [NSString stringWithFormat: @"%@", rsvpCount];
        NSString *htmlString = [self.meetUpEvent objectForKey:@"description"];
        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        
        self.descriptionLabel.attributedText = attrStr;
        self.hostingGroup = [self.meetUpEvent objectForKey:@"group"];
    }
}
- (IBAction)onHomePagePressed:(id)sender {
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    WebViewController *webVC = segue.destinationViewController;
    webVC.eventURL = [self.meetUpEvent objectForKey:@"event_url"];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.hostingGroup.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSArray *keys = [self.hostingGroup allKeys];
    id aKey = [keys objectAtIndex:indexPath.row];
    NSString *descriptionText = self.hostingGroup[aKey];
    cell.textLabel.text = aKey;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", descriptionText];
    return cell;
}
@end
