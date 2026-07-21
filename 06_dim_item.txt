// Query: Dim_Item
// Source: Derived from NBS_Price_List
// Purpose: Distinct item list with parent category
// Key steps: select & de-duplicate Item Label, derive Item Category via
//            Text.Contains logic, add Item_ID index

let
    Source = NBS_Price_List,
    #"Removed Other Columns" = Table.SelectColumns(Source,{"Item Label"}),
    #"Removed Duplicates" = Table.Distinct(#"Removed Other Columns"),
    #"Added Custom" = Table.AddColumn(#"Removed Duplicates", "Item Category", each if Text.Contains([Item Label], "Rice") then "Rice"
else if Text.Contains([Item Label], "Bean") then "Beans"
else if Text.Contains([Item Label], "Garri") then "Garri"
else if Text.Contains([Item Label], "Yam") then "Yam"
else "Other"),
    #"Reordered Columns" = Table.ReorderColumns(#"Added Custom",{"Item Category", "Item Label"}),
    #"Added Index" = Table.AddIndexColumn(#"Reordered Columns", "Index", 1, 1, Int64.Type),
    #"Renamed Columns1" = Table.RenameColumns(#"Added Index",{{"Index", "Item_ID"}}),
    #"Reordered Columns1" = Table.ReorderColumns(#"Renamed Columns1",{"Item_ID", "Item Label", "Item Category"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Reordered Columns1",{{"Item Category", type text}})
in
    #"Changed Type"
