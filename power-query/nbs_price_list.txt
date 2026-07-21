// Query: NBS Price List
// Source: NBS_Price_List.csv
// Purpose: National item-level prices, MoM/YoY, highest/lowest state prices
// Key steps: promote headers, type columns, round numerics, add Price_ID index,
//            derive Item Category from Item Label

let
    Source = Csv.Document(File.Contents("C:\Users\Oyenuga Opeyemi\Desktop\Portfolio projects\Foodprice aalysis\NBS_Price_List.csv"),[Delimiter=",", Columns=14, Encoding=65001, QuoteStyle=QuoteStyle.None]),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"Item Label", type text}, {"Year", Int64.Type}, {"Month", type text}, {"Avg_Price_LastYear", type number}, {"Avg_Price_PrevMonth", type number}, {"Avg_Price_Current", type number}, {"MoM", type number}, {"YoY", type number}, {"Highest_State", type text}, {"Highest_Price", type number}, {"Lowest_State", type text}, {"Lowest_Price", type number}, {"Date", type date}, {"Data_Complete", type text}}),
    #"Rounded Off" = Table.TransformColumns(#"Changed Type",{{"Avg_Price_LastYear", each Number.Round(_, 2), type number}}),
    #"Rounded Off1" = Table.TransformColumns(#"Rounded Off",{{"Avg_Price_PrevMonth", each Number.Round(_, 2), type number}, {"Avg_Price_Current", each Number.Round(_, 2), type number}, {"MoM", each Number.Round(_, 2), type number}, {"YoY", each Number.Round(_, 2), type number}}),
    #"Added Index" = Table.AddIndexColumn(#"Rounded Off1", "Index", 1, 1, Int64.Type),
    #"Reordered Columns" = Table.ReorderColumns(#"Added Index",{"Index", "Item Label", "Year", "Month", "Avg_Price_LastYear", "Avg_Price_PrevMonth", "Avg_Price_Current", "MoM", "YoY", "Highest_State", "Highest_Price", "Lowest_State", "Lowest_Price", "Date", "Data_Complete"}),
    #"Renamed Columns" = Table.RenameColumns(#"Reordered Columns",{{"Index", "Price_ID"}}),
    #"Added Custom" = Table.AddColumn(#"Renamed Columns", "Item Category", each if Text.Contains([Item Label], "Rice") then "Rice"
else if Text.Contains([Item Label], "Bean") then "Beans"
else if Text.Contains([Item Label], "Garri") then "Garri"
else if Text.Contains([Item Label], "Yam") then "Yam"
else "Other")
in
    #"Added Custom"
