codeunit 50400 "MNB Item Attribute" implements "MNB ITranslation"
{
    procedure GetTranslationTable(var TranslationTableNo: Integer; var TranslationKeyFieldNo: Integer; var TranslationKeySecondFieldNo: Integer; var TranslationLangFieldNo: Integer; var TranslationTextFieldNo: Integer)
    var
        ItemAttributeTranslation: Record "Item Attribute Translation";
    begin
        TranslationTableNo := Database::"Item Attribute Translation";
        TranslationKeyFieldNo := ItemAttributeTranslation.FieldNo("Attribute ID");
        TranslationKeySecondFieldNo := 0;
        TranslationLangFieldNo := ItemAttributeTranslation.FieldNo("Language Code");
        TranslationTextFieldNo := ItemAttributeTranslation.FieldNo(Name);
    end;

    procedure GetFieldNoToTranslate(): Integer;
    var
        ItemAttribute: Record "Item Attribute";
    begin
        exit(ItemAttribute.FieldNo(Name));
    end;

    procedure GetKeyFieldForSelection(): Integer;
    var
        ItemAttribute: Record "Item Attribute";
    begin
        exit(ItemAttribute.FieldNo(ID));
    end;

    procedure GetKeySecondFieldForSelection(): Integer;
    begin
        exit(0);
    end;
}