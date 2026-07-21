// Query: NBS Price Regional Zone
// Source: NBS_Price_Regional_Zone.csv
// Purpose: Regional (6-zone) price breakdown per item
// Key steps: promote headers, type columns, add Zone_Price_ID index,
//            unpivot 6 zone columns into Region/Price rows, capitalize region names

let
    Source = Csv.Document(File.Contents("C:\Users\Oyenuga Opeyemi\Desktop\Portfolio projects\Foodprice aalysis\NBS_Price_Regional_Zone.csv"),[Delimiter=",", Columns=10, Encoding=65001, QuoteStyle=QuoteStyle.None]),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"Item Label", type text}, {"Year", Int64.Type}, {"Month", type text}, {"NORTH CENTRAL", type number}, {"NORTH EAST", type number}, {"NORTH WEST", type number}, {"SOUTH EAST", type number}, {"SOUTH SOUTH", type number}, {"SOUTH WEST", type number}, {"Date", type date}}),
    #"Added Index" = Table.AddIndexColumn(#"Changed Type", "Index", 1, 1, Int64.Type),
    #"Reordered Columns" = Table.ReorderColumns(#"Added Index",{"Index", "Item Label", "Year", "Month", "NORTH CENTRAL", "NORTH EAST", "NORTH WEST", "SOUTH EAST", "SOUTH SOUTH", "SOUTH WEST", "Date"}),
    #"Renamed Columns" = Table.RenameColumns(#"Reordered Columns",{{"Index", "Zone_Price_ID"}}),
    #"Unpivoted Columns" = Table.UnpivotOtherColumns(#"Renamed Columns", {"Zone_Price_ID", "Item Label", "Year", "Month", "Date"}, "Attribute", "Value"),
    #"Renamed Columns1" = Table.RenameColumns(#"Unpivoted Columns",{{"Attribute", "Region"}, {"Value", "Price"}}),
    #"Capitalized Each Word" = Table.TransformColumns(#"Renamed Columns1",{{"Region", Text.Proper, type text}})
in
    #"Capitalized Each Word"
