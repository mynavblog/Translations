codeunit 50409 "MNB Item" implements "MNB ITranslation"
{
    procedure GetTranslationTable(var TranslationTableNo: Integer; var TranslationKeyFieldNo: Integer; var TranslationLangFieldNo: Integer; var TranslationTextFieldNo: Integer)
    var
        ItemTranslation: Record "Item Translation";
    begin
        TranslationTableNo := Database::"Item Translation";
        TranslationKeyFieldNo := ItemTranslation.FieldNo("Item No.");
        TranslationLangFieldNo := ItemTranslation.FieldNo("Language Code");
        TranslationTextFieldNo := ItemTranslation.FieldNo(Description);
    end;

    procedure GetFieldNoToTranslate(): Integer;
    var
        Item: Record Item;
    begin
        exit(Item.FieldNo(Description));
    end;

    procedure GetKeyFieldForSelection(): Integer;
    var
        Item: Record Item;
    begin
        exit(Item.FieldNo("No."));
    end;
}