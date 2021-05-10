codeunit 50408 "MNB Translation Mgt."
{
    /// <summary>
    /// Translates the marked records to choosen languages
    /// </summary>
    /// <param name="RecordVariant">Record Variant that need to be translated.</param>
    procedure TranslateSelectedRecords(var RecordVariant: Variant)
    var
        TranslationMgtImpl: Codeunit "MNB Translation Mgt. Impl.";
    begin
        TranslationMgtImpl.TranslateSelectedRecords(RecordVariant);
    end;
}