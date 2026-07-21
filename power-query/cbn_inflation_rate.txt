// Query: CBN Inflation Rate
// Source: CBN_Inflation_Rate_National.csv
// Purpose: National benchmark — Food YoY, Food Average, All-Items YoY
// Key steps: promote headers, type columns, rename period to Date

let
    Source = Csv.Document(File.Contents("C:\Users\Oyenuga Opeyemi\Desktop\Portfolio projects\Foodprice aalysis\CBN_Inflation_Rate_National.csv"),[Delimiter=",", Columns=4, Encoding=65001, QuoteStyle=QuoteStyle.None]),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"period", type date}, {"foodYearOn", type number}, {"foodAverage", type number}, {"allItemsYearOn", type number}}),
    #"Renamed Columns" = Table.RenameColumns(#"Changed Type",{{"period", "Date"}}),
    #"Changed Type1" = Table.TransformColumnTypes(#"Renamed Columns",{{"Date", type date}})
in
    #"Changed Type1"
