pageextension 50401 "MNB Item List" extends "Item List"
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
                Promoted = false;

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