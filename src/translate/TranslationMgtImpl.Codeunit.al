codeunit 50405 "MNB Translation Mgt. Impl."
{
    Access = Internal;

    var
        TranslationSetup: Record "MNB Translation Setup";
        TranslationServiceUrlTxt: Label 'https://api.cognitive.microsofttranslator.com/translate?api-version=3.0&to=%1', Locked = true, Comment = '%1 - List of languages to translate';


    #region do the translation

    /// <summary>
    /// Gets the selected records to be translated and gets translation for Azure Serive.
    /// </summary>
    /// <param name="RecordVariant">Record variant to be translated.\</param>
    procedure TranslateSelectedRecords(var RecordVariant: Variant)
    var
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        RecordRefToTranslate: RecordRef;
        ITranslation: Interface "MNB ITranslation";
    begin
        RecordRefToTranslate.GetTable(RecordVariant);
        ITranslation := Enum::"MNB Tables To Translate".FromInteger(RecordRefToTranslate.Number);
        SelectionFilterManagement.GetSelectionFilter(RecordRefToTranslate, ITranslation.GetKeyFieldForSelection());
        GetTranslations(RecordRefToTranslate);
    end;

    /// <summary>
    /// Gets translation for all records passed to the function. First step is to select the languages that should be translated.
    /// </summary>
    /// <param name="RecordRefToTranslate">Recors that need to translated.</param>
    local procedure GetTranslations(RecordRefToTranslate: RecordRef);
    var
        LanguagesToTranslate: Dictionary of [Code[10], Text[10]];
    begin
        GetTranslationSetup();
        LanguagesToTranslate := SelectLanguagesToTranslate();
        if LanguagesToTranslate.Count = 0 then
            exit;
        GetSingleRecordTranslation(RecordRefToTranslate, LanguagesToTranslate);

    end;

    /// <summary>
    /// Sends request to azure translation service and return translations.
    /// </summary>
    /// <param name="LanguageCodesString">Languages that need to be translated.</param>
    /// <param name="ValuesToTranslate">Valies that need to be translated</param>
    /// <param name="ResponseMsg">Return translation from azure translation service</param>
    [TryFunction]
    local procedure SendTranslationRequest(LanguageCodesString: Text; ValuesToTranslate: Text; var ResponseMsg: Text)
    var
        HttpRequestClient: HttpClient;
        HttpResponseMsg: HttpResponseMessage;
        HttpContent: HttpContent;
        HttpContentHeaders: HttpHeaders;
    begin
        HttpContent.WriteFrom(ValuesToTranslate);
        HttpContent.GetHeaders(HttpContentHeaders);
        HttpContentHeaders.Remove('Content-Type');

        HttpContentHeaders.Add('Ocp-Apim-Subscription-Key', TranslationSetup."Subscription Key");
        HttpContentHeaders.Add('Ocp-Apim-Subscription-Region', TranslationSetup."Subscription Region");
        HttpContentHeaders.Add('Content-Type', 'application/json');

        HttpRequestClient.Post(StrSubstNo(TranslationServiceUrlTxt, LanguageCodesString), HttpContent, HttpResponseMsg);
        HttpResponseMsg.Content().ReadAs(ResponseMsg);
        if (ResponseMsg = '') then begin
            Commit();
            HttpResponseMsg.Content().ReadAs(ResponseMsg);
        end;
        if not HttpResponseMsg.IsSuccessStatusCode() then
            Error('');
    end;

    /// <summary>
    /// Parses the translated values and return dictionary with language code and translated value
    /// </summary>
    /// <param name="ResponseMsg">Messages that has been sent by Azure Service</param>
    /// <returns>Dictionary with langauge code and translated value</returns>
    local procedure ParseTranslatedValues(ResponseMsg: Text): Dictionary of [Text[10], Text]
    var
        TranslatedLanguageCode: Text[10];
        JsonResponseArray: JsonArray;
        TranslatedValues: Dictionary of [Text[10], Text];
        TranslatedValue: Text;
        JsonResponseToken, JsonResponseToken2, JsonResponseToken3 : JsonToken;
        TranslateToken: JsonToken;
    begin
        JsonResponseArray.ReadFrom(ResponseMsg);
        foreach JsonResponseToken in JsonResponseArray do begin
            JsonResponseToken.AsObject().Get('translations', JsonResponseToken2);
            foreach JsonResponseToken3 in JsonResponseToken2.AsArray() do begin
                JsonResponseToken3.AsObject().Get('text', TranslateToken);
                TranslatedValue := TranslateToken.AsValue().AsText();
                JsonResponseToken3.AsObject().Get('to', TranslateToken);
                TranslatedLanguageCode := CopyStr(TranslateToken.AsValue().AsText(), 1, 10);
                TranslatedValues.Add(TranslatedLanguageCode, TranslatedValue);
            end;
        end;
        exit(TranslatedValues);
    end;

    /// <summary>
    /// Collects the dictionary of all languange codes which need to be translated. For Example ENU - en, PLK - pl.
    /// </summary>
    /// <returns>Dictionary: Code - Language Code, Text - Azure Service Language Code</returns>
    local procedure SelectLanguagesToTranslate(): Dictionary of [Code[10], Text[10]]
    var
        LangaugeMapping: Record "MNB Language Mapping";
        LanguageMappingPage: Page "MNB Language Mapping";
        SelectionFilter: Text;
        LanguagesToTranslate: Dictionary of [Code[10], Text[10]];
        NoLanguageHasBeenChoosenErr: Label 'No language has been choosen for the translation.';
    begin
        SelectionFilter := '';
        LangaugeMapping.SetFilter("Translation Code", '<>%1', '');
        LanguageMappingPage.SetTableView(LangaugeMapping);
        LanguageMappingPage.LookupMode(true);
        if LanguageMappingPage.RunModal() = Action::LookupOK then begin
            SelectionFilter := LanguageMappingPage.GetSelectionFilter();
            if SelectionFilter = '' then
                Error(NoLanguageHasBeenChoosenErr);
            LangaugeMapping.SetFilter(Code, SelectionFilter);
            LangaugeMapping.FindSet();
            repeat
                LanguagesToTranslate.Add(LangaugeMapping.Code, LangaugeMapping."Translation Code");
            until LangaugeMapping.Next() = 0;
        end;
        exit(LanguagesToTranslate);

    end;

    /// <summary>
    /// Creates a string with all Azure Service language codes that need to be sent to translation api. It remove duplicate values. For Example es,pl,en.
    /// </summary>
    /// <param name="LanguagesToTranslate">Dictionary of languages that need to be translated</param>
    /// <returns>Comma seperated string with languge codes</returns>
    local procedure BuildTranslateLanguageString(var LanguagesToTranslate: Dictionary of [Code[10], Text[10]]): Text
    var
        CodesString: Text;
        i: Integer;
        ThereIsNoLanguagesToTranslateErr: Label 'There is no languages to translate.';
    begin
        for i := 1 to LanguagesToTranslate.Count do
#pragma warning disable AA0217
            if not CodesString.Contains(StrSubstNo('%1,', LanguagesToTranslate.Get(LanguagesToTranslate.Keys.Get(i)))) then
                CodesString += StrSubstNo('%1,', LanguagesToTranslate.Get(LanguagesToTranslate.Keys.Get(i)));
#pragma warning restore AA0217
        if CodesString = '' then
            Error(ThereIsNoLanguagesToTranslateErr);

        exit(CodesString.TrimEnd(','));
    end;

    /// <summary>
    /// Add Value to the JsonArray that need to be translate.
    /// </summary>
    /// <param name="ValuesToTranslateArray">Array to which the object need to be added.</param>
    /// <param name="ValueToTranslate">String that need to be translated</param>
    local procedure AddValueToTraslate(var ValuesToTranslateArray: JsonArray; ValueToTranslate: Text)
    var
        JsonValueToTranslate: JsonObject;
    begin
        JsonValueToTranslate.Add('Text', ValueToTranslate);
        ValuesToTranslateArray.Add(JsonValueToTranslate);
    end;

    /// <summary>
    /// Collects value for record that need to be translated.
    /// </summary>
    /// <param name="RecordRefToTranslate">RecordRef with record that needs to be translated.</param>
    /// <returns>Text that will be passed to translation service.</returns>
    local procedure GetValueToTranslate(var RecordRefToTranslate: RecordRef): Text
    var
        ITranslation: Interface "MNB ITranslation";
        ValuesToTranslate: JsonArray;
        NoRecordsSelectedErr: Label 'No Records selected for translation';
    begin
        if RecordRefToTranslate.IsEmpty then
            Error(NoRecordsSelectedErr);

        ITranslation := Enum::"MNB Tables To Translate".FromInteger(RecordRefToTranslate.Number);
        AddValueToTraslate(ValuesToTranslate, RecordRefToTranslate.Field(ITranslation.GetFieldNoToTranslate()).Value);
        exit(Format(ValuesToTranslate));
    end;

    /// <summary>
    /// Inserts translation to translation table.
    /// </summary>
    /// <param name="RecordRefToTranslate">Records that has been translated</param>
    /// <param name="ITranslation">Interface that stores infromation which table is translated</param>
    /// <param name="LanguagesToTranslate">Languages that has been selected for translation</param>
    /// <param name="TranslatedValues">Translated values for all languages</param>
    local procedure InsertTranslation(var RecordRefToTranslate: RecordRef; var LanguagesToTranslate: Dictionary of [Code[10], Text[10]]; var TranslatedValues: Dictionary of [Text[10], Text]; var NumberTanslationInserted: Integer; var NumberTranslationSkipped: Integer)
    var
        RecordRefWithTranslation: RecordRef;
        ITranslation: Interface "MNB ITranslation";
        LanguageValue: Code[20];
        TranslatedValue: Text;
        i: Integer;
        TranslationTableNo, TranslationKeyFieldNo, TranslationLangFieldNo, TranslationTextFieldNo : Integer;

    begin
        ITranslation := Enum::"MNB Tables To Translate".FromInteger(RecordRefToTranslate.Number);
        ITranslation.GetTranslationTable(TranslationTableNo, TranslationKeyFieldNo, TranslationLangFieldNo, TranslationTextFieldNo);
        RecordRefWithTranslation.Open(TranslationTableNo);

        for i := 1 to LanguagesToTranslate.Count do
            if TranslatedValues.ContainsKey(LanguagesToTranslate.Values.Get(i)) then begin
                LanguageValue := LanguagesToTranslate.Keys.Get(i);
                TranslatedValues.Get(LanguagesToTranslate.Values.Get(i), TranslatedValue);
                RecordRefWithTranslation.Init();
                RecordRefWithTranslation.Field(TranslationLangFieldNo).Validate(LanguageValue);
                RecordRefWithTranslation.Field(TranslationKeyFieldNo).Validate(RecordRefToTranslate.Field(ITranslation.GetKeyFieldForSelection()).Value);
                RecordRefWithTranslation.Field(TranslationTextFieldNo).Validate(TranslatedValue);
                if RecordRefWithTranslation.Insert(true) then
                    NumberTanslationInserted += 1
                else
                    NumberTranslationSkipped += 1;
            end;
    end;
    /// <summary>
    /// Gets records to translation, sends request to translate and insert the translation to the corresponding table
    /// </summary>
    /// <param name="RecordRefToTranslate">Records that should be translated</param>
    /// <param name="LanguagesToTranslate">Lanaguages that should be translated</param>
    /// <param name="NumberTanslationInserted">Integer that specifed how many translations were inserted</param>
    /// <param name="NumberTranslationSkipped"></param>
    local procedure GetSingleRecordTranslation(var RecordRefToTranslate: RecordRef; var LanguagesToTranslate: Dictionary of [Code[10], Text[10]])
    var
        TranslatedValues: Dictionary of [Text[10], Text];
        ResponseMsg: Text;
        LanguageCodesString, ValueToTranslate : Text;
        NumberTanslationInserted, NumberTranslationSkipped : Integer;
        TranslationSummaryMsg: Label 'Number of translation inserted: %1. Number of translation skipped: %2.', Comment = '%1 - NoTanslationInsert, %2 - NoTranslationSkipped';

    begin
        LanguageCodesString := BuildTranslateLanguageString(LanguagesToTranslate);
        if RecordRefToTranslate.FindSet() then
            repeat
                ValueToTranslate := GetValueToTranslate(RecordRefToTranslate);
                if SendTranslationRequest(LanguageCodesString, ValueToTranslate, ResponseMsg) then begin
                    TranslatedValues := ParseTranslatedValues(ResponseMsg);
                    InsertTranslation(RecordRefToTranslate, LanguagesToTranslate, TranslatedValues, NumberTanslationInserted, NumberTranslationSkipped);
                end;

            until RecordRefToTranslate.Next() = 0;
        if GuiAllowed then
            Message(TranslationSummaryMsg, NumberTanslationInserted, NumberTranslationSkipped);
    end;
    #endregion

    /// <summary>
    /// Gets translation setup and check if all fields has values.
    /// </summary>
    local procedure GetTranslationSetup()
    begin
        TranslationSetup.Get();
        TranslationSetup.TestField("Subscription Key");
        TranslationSetup.TestField("Subscription Region");
        TranslationSetup.TestField(Endpoint);
    end;




}