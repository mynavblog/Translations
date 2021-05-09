table 50402 "MNB Language Mapping"
{
    DataClassification = SystemMetadata;
    Caption = 'Language Mapping';
    LookupPageId = "MNB Language Mapping";
    DrillDownPageId = "MNB Language Mapping";
    Access = Internal;

    fields
    {
        field(1; "Code"; Code[10])
        {
            DataClassification = SystemMetadata;
            Caption = 'Code';
            TableRelation = Language.Code;
            trigger OnValidate()
            begin
                CalcFields(Name);
            end;
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Language.Name where(Code = field(Code)));
            Editable = false;
        }
        field(3; "Translation Code"; Text[10])
        {
            DataClassification = SystemMetadata;
            Caption = 'Translation Code';
        }

    }

    keys
    {
        key(Key1; Code)
        {
            Clustered = true;
        }
    }
}