table 50401 "MNB Translation Setup"
{
    Caption = 'MyNAVBlog.com Translation Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {

        }

        field(2; "Subscription Region"; Text[50])
        {
            DataClassification = SystemMetadata;
            Caption = 'Subscription Region';
        }
        field(3; "Subscription Key"; Text[80])
        {
            DataClassification = SystemMetadata;
            Caption = 'Subscription Key';
            ExtendedDatatype = Masked;
        }
        field(4; "Endpoint"; Text[250])
        {
            DataClassification = SystemMetadata;
            Caption = 'Endpoint';
        }

    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    var
        RecordHasBeenRead: Boolean;

    procedure GetRecordOnce()
    begin
        if RecordHasBeenRead then
            exit;
        Get();
        RecordHasBeenRead := true;
    end;

    procedure InsertIfNotExists()
    var
    begin
        Reset();
        if not Get() then begin
            Init();
            Insert(true);
        end;
    end;


}