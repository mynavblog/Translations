/// <summary>
/// Add to enum all tables that would be translate. The value of the enum value need be exact the same as table number. For Example Payment Terms = 3.
/// </summary>
enum 50402 "MNB Tables To Translate" implements "MNB ITranslation"
{

    value(3; "Payment Terms")
    {
        Implementation = "MNB ITranslation" = "MNB Payment Terms";
    }
    value(10; "Shipment Method")
    {
        Implementation = "MNB ITranslation" = "MNB Shipment Method";
    }
    value(27; Item)
    {
        Implementation = "MNB ITranslation" = "MNB Item";
    }
    value(204; "Unit of Measure")
    {
        Implementation = "MNB ITranslation" = "MNB Unit of Measure";
    }
    value(289; "Payment Method")
    {
        Implementation = "MNB ITranslation" = "MNB Payment Method";
    }

    value(292; "Reminder Terms")
    {
        Implementation = "MNB ITranslation" = "MNB Reminder Terms";
    }

    value(7500; "Item Attribute")
    {
        Implementation = "MNB ITranslation" = "MNB Item Attribute";
    }
    value(7501; "Item Attribute Value")
    {
        Implementation = "MNB ITranslation" = "MNB Item Attribute Value";
    }
}