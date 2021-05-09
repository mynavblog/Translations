codeunit 50412 "MNB Unit of Measure" implements "MNB ITranslation"
{
    procedure GetTranslationTable(var TranslationTableNo: Integer; var TranslationKeyFieldNo: Integer; var TranslationLangFieldNo: Integer; var TranslationTextFieldNo: Integer)
    var
        UnitOfMeasureTranslation: Record "Unit of Measure Translation";
    begin
        TranslationTableNo := Database::"Unit of Measure Translation";
        TranslationKeyFieldNo := UnitOfMeasureTranslation.FieldNo(Code);
        TranslationLangFieldNo := UnitOfMeasureTranslation.FieldNo("Language Code");
        TranslationTextFieldNo := UnitOfMeasureTranslation.FieldNo(Description);
    end;

    procedure GetFieldNoToTranslate(): Integer;
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        exit(UnitOfMeasure.FieldNo(Description));
    end;

    procedure GetKeyFieldForSelection(): Integer;
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        exit(UnitOfMeasure.FieldNo(Code));
    end;
}