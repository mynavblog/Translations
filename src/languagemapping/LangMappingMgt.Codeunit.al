codeunit 50407 "MNB Lang. Mapping Mgt."
{
    Access = Internal;

    #region import the list of languages
    var
        TranslationDictionaryUrlTxt: Label 'https://api.cognitive.microsofttranslator.com/languages?api-version=3.0&scope=translation', Locked = true;

    /// <summary>
    /// Imports list of available languages in Azure Service and map it to language codes in Business Central
    /// </summary>
    procedure ImportListOfLanguageCodes()
    var
        ResponseMsg: Text;
        ResponseHasErrorErr: Label 'The list is not retrieved correctly. Please check the issue: %1', Comment = '%1 - ResponseMsg';
    begin
        if GetLanguageList(ResponseMsg) then
            ParseListOfLanguages(ResponseMsg)
        else
            Error(ResponseHasErrorErr, ResponseMsg);
    end;

    /// <summary>
    /// Gets all languages in the Azure Service
    /// </summary>
    /// <param name="ResponseMsg">Stores the response from call</param>
    /// <returns></returns>
    [TryFunction]
    local procedure GetLanguageList(var ResponseMsg: Text)
    var
        HttpRequestClient: HttpClient;
        HttpResponseMsg: HttpResponseMessage;
        HttpContent: HttpContent;
    begin
        HttpContent.WriteFrom('content-type: application/json');

        HttpRequestClient.Get(TranslationDictionaryUrlTxt, HttpResponseMsg);
        HttpResponseMsg.Content().ReadAs(ResponseMsg);
        if (ResponseMsg = '') then begin
            Commit();
            HttpResponseMsg.Content().ReadAs(ResponseMsg);
        end;
        if not HttpResponseMsg.IsSuccessStatusCode() then
            Error('');
    end;


    /// <summary>
    /// Parses the response from the Azure Service and insert the mapping for langugages.
    /// </summary>
    /// <param name="ResponseMsg"></param>
    local procedure ParseListOfLanguages(ResponseMsg: Text)
    var
        LanguageMapping: Record "MNB Language Mapping";
        JsonResObject, JsonObjectTranslation : JsonObject;
        JsonResToken, JsonResToken2 : JsonToken;
        LanguageCode, LanguageDescription : Text;
        i: Integer;
    begin
        if ResponseMsg = '' then
            exit;

        LanguageMapping.DeleteAll();

        JsonResObject.ReadFrom(ResponseMsg);
        JsonResObject.Get('translation', JsonResToken);
        JsonObjectTranslation := JsonResToken.AsObject();

        for i := 1 to JsonObjectTranslation.Keys.Count() do begin
            LanguageCode := JsonObjectTranslation.Keys.Get(i);
            JsonObjectTranslation.Get(JsonObjectTranslation.Keys.Get(i), JsonResToken2);
            JsonResToken2.AsObject().Get('name', JsonResToken);
            LanguageDescription := JsonResToken.AsValue().AsText();
            InsertLanguageMapping(LanguageCode, LanguageDescription);
        end;
    end;

    /// <summary>
    /// Inserts the mapping to table.
    /// </summary>
    /// <param name="LanguageCode">Azure Service Lanugage Code</param>
    /// <param name="LanguageDescription">Business Central Language Description. The code will be added for all langauges which description starts from the value </param>
    local procedure InsertLanguageMapping(LanguageCode: Text; LanguageDescription: Text)
    var
        Language: Record Language;
        LanguageMapping: Record "MNB Language Mapping";
    begin
        if (LanguageCode = '') or (LanguageDescription = '') then
            exit;
        LanguageDescription := LanguageDescription.Replace('(', '@').Replace(')', '@');
#pragma warning disable AA0217
        Language.SetFilter(Name, StrSubstNo('%1*', LanguageDescription));
#pragma warning restore AA0217
        if Language.FindSet() then
            repeat
                if not LanguageMapping.Get(Language.Code) then begin
                    LanguageMapping.Init();
                    LanguageMapping.Code := Language.Code;
                    LanguageMapping."Translation Code" := CopyStr(LanguageCode, 1, MaxStrLen(LanguageMapping."Translation Code"));
                    LanguageMapping.Insert(true);
                end;
            until Language.Next() = 0;
    end;
    #endregion

}