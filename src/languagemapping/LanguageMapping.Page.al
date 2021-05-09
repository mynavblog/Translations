page 50404 "MNB Language Mapping"
{
    Caption = 'Language Mapping';
    PageType = List;
    UsageCategory = None;
    SourceTable = "MNB Language Mapping";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for a language.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the language.';
                    DrillDown = false;
                }
                field("Translation Code"; Rec."Translation Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code in azure service.';
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(GetLangaugeCodes)
            {
                ApplicationArea = All;
                Caption = 'Get Language Codes';
                ToolTip = 'Import language codes from azure service.';
                Image = ImportCodes;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    LangugageMappingMgt: Codeunit "MNB Lang. Mapping Mgt.";
                    DoYouWantToImportQst: Label 'Do you want to import the list of languages? It will remove existing records.';
                begin
                    if Confirm(DoYouWantToImportQst, true) then
                        LangugageMappingMgt.ImportListOfLanguageCodes();
                end;
            }
        }
    }
    procedure GetSelectionFilter(): Text
    var
        LangaugeMapping: Record "MNB Language Mapping";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        RecRef: RecordRef;
    begin
        CurrPage.SetSelectionFilter(LangaugeMapping);
        RecRef.GetTable(LangaugeMapping);
        exit(SelectionFilterManagement.GetSelectionFilter(RecRef, LangaugeMapping.FieldNo(Code)));
    end;
}