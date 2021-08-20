codeunit 50402 "MNB Reminder Terms" implements "MNB ITranslation"
{
    procedure GetTranslationTable(var TranslationTableNo: Integer; var TranslationKeyFieldNo: Integer; var TranslationKeySecondFieldNo: Integer; var TranslationLangFieldNo: Integer; var TranslationTextFieldNo: Integer)
    var
        ReminderTermTranslation: Record "Reminder Terms Translation";
    begin
        TranslationTableNo := Database::"Reminder Terms Translation";
        TranslationKeyFieldNo := ReminderTermTranslation.FieldNo("Reminder Terms Code");
        TranslationKeySecondFieldNo := 0;
        TranslationLangFieldNo := ReminderTermTranslation.FieldNo("Language Code");
        TranslationTextFieldNo := ReminderTermTranslation.FieldNo("Note About Line Fee on Report");
    end;

    procedure GetFieldNoToTranslate(): Integer;
    var
        ReminderTerm: Record "Reminder Terms";
    begin
        exit(ReminderTerm.FieldNo("Note About Line Fee on Report"));
    end;

    procedure GetKeyFieldForSelection(): Integer;
    var
        ReminderTerm: Record "Reminder Terms";
    begin
        exit(ReminderTerm.FieldNo(Code));
    end;

    procedure GetKeySecondFieldForSelection(): Integer;
    begin
        exit(0);
    end;
}