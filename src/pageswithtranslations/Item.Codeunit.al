codeunit 50409 "MNB Item" implements "MNB ITranslation"
{
    procedure GetTranslationTable(var TranslationTableNo: Integer; var TranslationKeyFieldNo: Integer; var TranslationKeySecondFieldNo: Integer; var TranslationLangFieldNo: Integer; var TranslationTextFieldNo: Integer)
    var
        ItemTranslation: Record "Item Translation";
    begin
        TranslationTableNo := Database::"Item Translation";
        TranslationKeyFieldNo := ItemTranslation.FieldNo("Item No.");
        TranslationKeySecondFieldNo := 0;
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

    procedure GetKeySecondFieldForSelection(): Integer;
    begin
        exit(0);
    end;
}