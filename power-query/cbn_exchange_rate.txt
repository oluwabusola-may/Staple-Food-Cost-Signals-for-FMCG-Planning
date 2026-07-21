// Query: CBN Exchange Rate
// Source: CBN_Exchange_Rate(USD).csv
// Purpose: Monthly Naira/USD central rate
// Key steps: type columns, group by year-month, take latest rate per month
//            (daily -> monthly), rebuild Date as start-of-month, drop helper columns

let
    Source = Csv.Document(File.Contents("C:\Users\Oyenuga Opeyemi\Desktop\Portfolio projects\Foodprice aalysis\CBN_Exchange_Rate(USD).csv"),[Delimiter=",", Columns=3, Encoding=65001, QuoteStyle=QuoteStyle.None]),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"Currency", type text}, {"Date", type date}, {"Central Rate", type number}}),
    #"Added Custom" = Table.AddColumn(#"Changed Type", "Year Month", each Text.From(Date.Year([Date])) & "-" & Text.From(Date.Month([Date]))),
    #"Sorted Rows" = Table.Sort(#"Added Custom",{{"Date", Order.Descending}}),
    #"Grouped Rows" = Table.Group(#"Sorted Rows", {"Year Month"}, {{"Central_R", each _, type table [Currency=nullable text, Date=nullable date, Central Rate=nullable number, Year Month=text]}}),
    #"Added Custom1" = Table.AddColumn(#"Grouped Rows", "Latest_Rate", each [Central_R]{0}[Central Rate]),
    #"Renamed Columns" = Table.RenameColumns(#"Added Custom1",{{"Central_R", "Central_Rate"}}),
    #"Added Custom2" = Table.AddColumn(#"Renamed Columns", "Date", each [Central_Rate]{0}[Date]),
    #"Added Custom3" = Table.AddColumn(#"Added Custom2", "Date.1", each Date.StartOfMonth([Central_Rate]{0}[Date])),
    #"Renamed Columns1" = Table.RenameColumns(#"Added Custom3",{{"Date", "Previousss"}, {"Date.1", "Date"}}),
    #"Removed Columns" = Table.RemoveColumns(#"Renamed Columns1",{"Central_Rate"}),
    #"Renamed Columns2" = Table.RenameColumns(#"Removed Columns",{{"Latest_Rate", "Central_Rate"}}),
    #"Removed Columns1" = Table.RemoveColumns(#"Renamed Columns2",{"Previousss", "Year Month"}),
    #"Changed Type1" = Table.TransformColumnTypes(#"Removed Columns1",{{"Central_Rate", type number}, {"Date", type date}})
in
    #"Changed Type1"
