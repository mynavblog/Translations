codeunit 50401 "MNB Item Attribute Value" implements "MNB ITranslation"
{
    procedure GetTranslationTable(var TranslationTableNo: Integer; var TranslationKeyFieldNo: Integer; var TranslationKeySecondFieldNo: Integer; var TranslationLangFieldNo: Integer; var TranslationTextFieldNo: Integer)
    var
        ItemAttributeValueTranslation: Record "Item Attr. Value Translation";
    begin
        TranslationTableNo := Database::"Item Attr. Value Translation";
        TranslationKeyFieldNo := ItemAttributeValueTranslation.FieldNo("Attribute ID");
        TranslationKeySecondFieldNo := ItemAttributeValueTranslation.FieldNo(ID);
        TranslationLangFieldNo := ItemAttributeValueTranslation.FieldNo("Language Code");
        TranslationTextFieldNo := ItemAttributeValueTranslation.FieldNo(Name);
    end;

    procedure GetFieldNoToTranslate(): Integer;
    var
        ItemAttributeValue: Record "Item Attribute Value";
    begin
        exit(ItemAttributeValue.FieldNo(Value));
    end;

    procedure GetKeyFieldForSelection(): Integer;
    var
        ItemAttributeValue: Record "Item Attribute Value";
    begin
        exit(ItemAttributeValue.FieldNo("Attribute ID"));
    end;

    procedure GetKeySecondFieldForSelection(): Integer;
    var
        ItemAttributeValue: Record "Item Attribute Value";
    begin
        exit(ItemAttributeValue.FieldNo(ID));
    end;
}