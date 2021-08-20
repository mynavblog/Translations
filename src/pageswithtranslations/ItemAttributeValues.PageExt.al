pageextension 50406 "MNB Item Attribute Values" extends "Item Attribute Values"
{
    actions
    {
        addlast(processing)
        {
            action(MNBTranslate)
            {
                ApplicationArea = All;
                Caption = 'Translate';
                ToolTip = 'translate the selected records';
                Image = Translate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    TranslateSelectedRecords();
                end;
            }
        }
    }

    local procedure TranslateSelectedRecords()
    var
        TranslationMgt: Codeunit "MNB Translation Mgt.";
        RecordVariant: Variant;
    begin
        RecordVariant := Rec;
        CurrPage.SetSelectionFilter(RecordVariant);
        TranslationMgt.TranslateSelectedRecords(RecordVariant);
    end;
}