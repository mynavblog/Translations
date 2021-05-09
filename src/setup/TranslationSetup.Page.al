page 50403 "MNB Translation Setup"
{

    PageType = Card;
    SourceTable = "MNB Translation Setup";
    Caption = 'Translation Setup';
    InsertAllowed = false;
    DeleteAllowed = false;
    UsageCategory = Administration;
    ApplicationArea = All;


    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'Genaral';
                field(Endpoint; Rec.Endpoint)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the endpoint for the service.';
                }
                field("Subscription Region"; Rec."Subscription Region")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the region that the Translate service is set.';
                }
                field("Subscription Key"; Rec."Subscription Key")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the secret key which is set in Azure Portal.';
                }
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action(LanguageMapping)
            {
                ApplicationArea = All;
                Caption = 'Language Mapping';
                ToolTip = 'Show languages which can be translated.';
                Image = Language;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = page "MNB Language Mapping";
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.InsertIfNotExists();
    end;

}
