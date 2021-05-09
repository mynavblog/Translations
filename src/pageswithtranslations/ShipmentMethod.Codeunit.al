codeunit 50411 "MNB Shipment Method" implements "MNB ITranslation"
{
    procedure GetTranslationTable(var TranslationTableNo: Integer; var TranslationKeyFieldNo: Integer; var TranslationLangFieldNo: Integer; var TranslationTextFieldNo: Integer)
    var
        ShipmentMethodTranslation: Record "Shipment Method Translation";
    begin
        TranslationTableNo := Database::"Shipment Method Translation";
        TranslationKeyFieldNo := ShipmentMethodTranslation.FieldNo("Shipment Method");
        TranslationLangFieldNo := ShipmentMethodTranslation.FieldNo("Language Code");
        TranslationTextFieldNo := ShipmentMethodTranslation.FieldNo(Description);
    end;

    procedure GetFieldNoToTranslate(): Integer;
    var
        ShipmentMethod: Record "Shipment Method";
    begin
        exit(ShipmentMethod.FieldNo(Description));
    end;

    procedure GetKeyFieldForSelection(): Integer;
    var
        ShipmentMethod: Record "Shipment Method";
    begin
        exit(ShipmentMethod.FieldNo(Code));
    end;
}