-- Create a function to analyze winter sales
CREATE OR REPLACE FUNCTION get_winter_sales_analysis()
RETURNS JSON AS $$
DECLARE
    result JSON;
    summary TEXT;
    chart_data JSON;
    table_data JSON;
    total_winter_sales DECIMAL;
    best_selling_product TEXT;
    best_selling_amount DECIMAL;
BEGIN
    -- Get the analysis data
    WITH product_sales AS (
        SELECT 
            s.item,
            st.nm as product_name,
            COUNT(*) as sale_count,
            SUM(s.amt) as total_sales,
            AVG(s.temp_celsius) as avg_temp
        FROM DATA_2023_SALES s
        JOIN stuff st ON s.item = st.thing_id
        WHERE s.season = 'Winter'
        GROUP BY s.item, st.nm
    ),
    best_product AS (
        SELECT product_name, total_sales
        FROM product_sales
        ORDER BY total_sales DESC
        LIMIT 1
    )
    SELECT 
        bp.product_name,
        bp.total_sales,
        (
            SELECT SUM(total_sales) 
            FROM product_sales
        )
    INTO best_selling_product, best_selling_amount, total_winter_sales
    FROM best_product bp;

    -- Create the summary text
    summary := format(
        'the best-selling product is %s with total sales of $%s. Total winter sales across all products reached $%s. ' ||
        'This analysis is based on sales data during winter months, considering factors like temperature and weather conditions.',
        best_selling_product,
        ROUND(best_selling_amount::numeric, 2),
        ROUND(total_winter_sales::numeric, 2)
    );

    -- Prepare chart and table data
    SELECT json_agg(row_to_json(t))
    INTO chart_data
    FROM (
        SELECT 
            st.nm as "productName",
            SUM(s.amt) as "totalSales",
            COUNT(*) as "quantity"
        FROM DATA_2023_SALES s
        JOIN stuff st ON s.item = st.thing_id
        WHERE s.season = 'Winter'
        GROUP BY st.nm
        ORDER BY "totalSales" DESC
    ) t;

    -- Prepare detailed table data
    SELECT json_agg(row_to_json(t))
    INTO table_data
    FROM (
        SELECT 
            st.nm as "productName",
            SUM(s.amt) as "totalSales",
            COUNT(*) as "quantity",
            ROUND(AVG(s.temp_celsius)::numeric, 1) as "avgTemp"
        FROM DATA_2023_SALES s
        JOIN stuff st ON s.item = st.thing_id
        WHERE s.season = 'Winter'
        GROUP BY st.nm
        ORDER BY "totalSales" DESC
    ) t;

    -- Construct the final JSON result
    SELECT json_build_object(
        'summary', summary,
        'chartData', chart_data,
        'tableData', table_data
    ) INTO result;

    RETURN result;
END;
$$ LANGUAGE plpgsql; 