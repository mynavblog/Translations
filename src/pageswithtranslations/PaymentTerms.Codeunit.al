codeunit 50406 "MNB Payment Terms" implements "MNB ITranslation"
{
    procedure GetTranslationTable(var TranslationTableNo: Integer; var TranslationKeyFieldNo: Integer; var TranslationKeySecondFieldNo: Integer; var TranslationLangFieldNo: Integer; var TranslationTextFieldNo: Integer)
    var
        PaymentTermTranslation: Record "Payment Term Translation";
    begin
        TranslationTableNo := Database::"Payment Term Translation";
        TranslationKeyFieldNo := PaymentTermTranslation.FieldNo("Payment Term");
        TranslationKeySecondFieldNo := 0;
        TranslationLangFieldNo := PaymentTermTranslation.FieldNo("Language Code");
        TranslationTextFieldNo := PaymentTermTranslation.FieldNo(Description);
    end;

    procedure GetFieldNoToTranslate(): Integer;
    var
        PaymentTerms: Record "Payment Terms";
    begin
        exit(PaymentTerms.FieldNo(Description));
    end;

    procedure GetKeyFieldForSelection(): Integer;
    var
        PaymentTerms: Record "Payment Terms";
    begin
        exit(PaymentTerms.FieldNo(Code));
    end;

    procedure GetKeySecondFieldForSelection(): Integer;
    begin
        exit(0);
    end;
}