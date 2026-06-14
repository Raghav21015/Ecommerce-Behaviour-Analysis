show tables;
SELECT * 
FROM ecommerce_behavior 
LIMIT 5;

-- customer who have purchased same product more than 1 time 
select product_name,customer_id,count(order_id) from ecommerce_behavior 
group by product_name,customer_id
having count(order_id)>1;

-- insight:Certain products show repeat purchases from the same customers, indicating strong customer satisfaction.

-- add columnn revenue
alter table ecommerce_behavior add column revenue float;
update ecommerce_behavior set revenue=(quantity*final_price);


-- total revenue 
select sum(revenue) from ecommerce_behavior;

-- total quantity sold per product
select product_name,sum(quantity) from ecommerce_behavior
group by product_name;

-- Insight:Some products have higher sales than other product indicating higher demand.

-- revenue by region 
select region,sum(revenue) as total_revenue from ecommerce_behavior 
group by region
order by total_revenue desc;

-- insight: North region lead in revenue,indicating strong demand,while south underperform may required targeted marketing and promotional strategies.

-- revenue by category 
select category,sum(revenue) as revenue from ecommerce_behavior
group by category
order by revenue desc;

-- insight: Fashion leads in revenue, indicating high demand, while Technology underperforms and may require strategic improvement to increase sales.


-- top 5 product in revenue
select sum(revenue) as total_revenue,product_name from ecommerce_behavior
group by product_name
order by total_revenue desc limit 5;

-- Insight: A few top products contribute significantly to total revenue and most of them are of tech category, indicating that focusing on high-performing products can drive overall business growth.

-- revenue by payment type 
select sum(revenue),payment_type
from ecommerce_behavior
group by payment_type
order by sum(revenue) desc;

-- Insight: Cash on Delivery generates the highest revenue, indicating a strong customer preference for this payment method. This suggests that customers may prioritize trust in transactions, and the business should continue supporting and optimizing COD while encouraging digital payment adoption.

-- avg rating per category
select category,avg(rating) from ecommerce_behavior
group by category;

-- avg delivery days by each region 
select region,avg(delivery_days) from ecommerce_behavior
group by region;

-- insights:Some region have higher delivery days than other,require to improve delivery network to reduce delivery time and gain customer satisfaction.

-- revenue comparison when flash_sale and when not 
select 
case 
when is_flash_sale=1 then "flash_sale"
else
"non_flash_sale"
end as
sales_types,
sum(revenue) from ecommerce_behavior
group by is_flash_sale;

-- Insight: Revenue is higher during non-flash sale periods, indicating that regular pricing contributes more to overall revenue. While flash sales may boost short-term volume, they do not maximize total revenue.

-- total quantity sold based on flash_sale and non flash sale 
select 
case 
when is_flash_sale=1 then "flash_sale"
else
"non_flash_sale"
end as 
sales_type,
sum(quantity) as total_quantity
from ecommerce_behavior
group by is_flash_sale;

-- Insight: Higher quantity during non-flash sale periods suggests steady customer demand without reliance on promotions, while flash sales may drive short-term spikes but do not dominate total sales volume.

-- top product in each region 
SELECT product_name, region, total_revenue
FROM (
    SELECT 
        product_name,
        region,
        SUM(revenue) AS total_revenue,
        RANK() OVER (PARTITION BY region ORDER BY SUM(revenue) DESC) AS rnk
    FROM ecommerce_behavior
    GROUP BY region, product_name
) t
WHERE rnk = 1;

-- Insight: Different regions have different top products, showing customer preferences vary by region, so region-based strategy is needed.

-- total return per category 
select category,sum(returned) from ecommerce_behavior
group by category;

-- -- Insight: fashion categories have higher total returns, indicating possible issues in product quality or customer expectations.

-- return rate per category 
select 
category,sum(returned)/count(*) as return_rate
from ecommerce_behavior
group by category;

 -- return rate per payment type 
 select 
 payment_type,sum(returned) *1.0/count(*) as return_rate_per_payment_type
 from ecommerce_behavior
 group by payment_type;
 
 -- Insight: Return rate is different by payment type, suggesting customer behavior varies based on payment method.
 
 