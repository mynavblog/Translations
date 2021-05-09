codeunit 50408 "MNB Translation Mgt."
{
    procedure TranslateSelectedRecords(var RecordVariant: Variant)
    var
        TranslationMgtImpl: Codeunit "MNB Translation Mgt. Impl.";
    begin
        TranslationMgtImpl.TranslateSelectedRecords(RecordVariant);
    end;
}