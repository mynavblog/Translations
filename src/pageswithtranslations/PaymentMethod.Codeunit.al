codeunit 50410 "MNB Payment Method" implements "MNB ITranslation"
{
    procedure GetTranslationTable(var TranslationTableNo: Integer; var TranslationKeyFieldNo: Integer; var TranslationLangFieldNo: Integer; var TranslationTextFieldNo: Integer)
    var
        PaymentMethodTranslation: Record "Payment Method Translation";
    begin
        TranslationTableNo := Database::"Payment Method Translation";
        TranslationKeyFieldNo := PaymentMethodTranslation.FieldNo("Payment Method Code");
        TranslationLangFieldNo := PaymentMethodTranslation.FieldNo("Language Code");
        TranslationTextFieldNo := PaymentMethodTranslation.FieldNo(Description);
    end;

    procedure GetFieldNoToTranslate(): Integer;
    var
        PaymentMethod: Record "Payment Method";
    begin
        exit(PaymentMethod.FieldNo(Description));
    end;

    procedure GetKeyFieldForSelection(): Integer;
    var
        PaymentMethod: Record "Payment Method";
    begin
        exit(PaymentMethod.FieldNo(Code));
    end;
}