interface "MNB ITranslation"
{
    /// <summary>
    /// Returns Key Field number for record that need to be translated. For example: Code in Payment Terms table.
    /// </summary>
    /// <returns>Field Number</returns>
    procedure GetKeyFieldForSelection(): Integer;
    /// <summary>
    /// Returns Key Second Field number for record that need to be translated. For example: Code in Payment Terms table.
    /// </summary>
    /// <returns>Field Number</returns>
    procedure GetKeySecondFieldForSelection(): Integer;
    /// <summary>
    /// Returns Text Field number for recrod that need to be translated. For example: Description in Payment Terms table.
    /// </summary>
    /// <returns>Field Number</returns>
    procedure GetFieldNoToTranslate(): Integer;
    /// <summary>
    /// Returns Number of table and felds that stores the translation. 
    /// </summary>
    /// <param name="TranslationTableNo">Number of Table that stores translation. For Example Payment Terms Translation</param>
    /// <param name="TranslationKeyFieldNo">Number of field with Key value. For Example Field Payment Term</param>
    /// <param name="TranslationLangFieldNo">Number of field with Language Code value. For Example Field Language Code</param>
    /// <param name="TranslationTextFieldNo">Number of field with Text value. For Example Field Description</param>
    procedure GetTranslationTable(var TranslationTableNo: Integer; var TranslationKeyFieldNo: Integer; var TranslationKeySecondFieldNo: Integer; var TranslationLangFieldNo: Integer; var TranslationTextFieldNo: Integer);
}