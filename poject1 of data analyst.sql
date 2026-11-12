select * from customer limit 20

--1. what is the total revenue generate by the male vs female customers.
SELECT  "Gender", SUM("Purchase Amount (USD)") AS revenue
from customer
group by "Gender"

--2. Which customer used a discount but still spent more than the average purchase amount?

SELECT "Customer ID", "Purchase Amount (USD)"
FROM customer
WHERE "Discount Applied" = 'Yes'
AND "Purchase Amount (USD)" >= (
    SELECT AVG("Purchase Amount (USD)")
    FROM customer
);

--3. which are the top 5 products with the highest average review rating?
SELECT "Item Purchased",AVG("Review Rating") AS Average
FROM customer
Group by "Item Purchased" 
order by AVG("Review Rating") Desc
limit 5;

--4. compare the average Purchase amounts between standard and express shipping.
SELECT "Shipping Type", AVG("Purchase Amount (USD)") AS Average_Purchase_Amount
FROM customer
WHERE "Shipping Type" in ('Express','Standard')
group by "Shipping Type"

--5. Do Subcribed customers spend more? compare average spend total revenue between Subcribed and non-subcribed
SELECT "Subscription Status",
COUNT("Customer ID") AS total_customer,
ROUND(AVG("Purchase Amount (USD)"),2) AS average_spend,
ROUND(SUM("Purchase Amount (USD)"),2) AS total_revenue
FROM customer
group by "Subscription Status"
order by average_spend,total_revenue desc;

--6. which 5 product have  the highest percentage of purchases with discount apllied.
SELECT "Item Purchased",
ROUND(100 * SUM(CASE WHEN "Discount Applied" = 'Yes' THEN 1 ELSE 0 END)/COUNT(*),2) AS discount_rate
FROM customer
group by "Item Purchased"
order by discount_rate desc
limit 5;

--7. segment coustomer into new , Returning, and loyal based on their total number of previous purchase,
--and show the count of each segment.
With Customer_type AS(
SELECT "Customer ID", "Previous Purchases",
CASE
    WHEN "Previous Purchases" = 1 THEN 'NEW'
	WHEN "Previous Purchases" BETWEEN 2 And 10 THEN 'Returning'
	ELSE 'loyal'
	END AS customer_segment 
FROM customer	
)

SELECT customer_segment, count(*) AS "Number of customer"
FROM Customer_type
group by customer_segment;

--8. what are the top 3 product most purchased product within in each category.
With item_counts AS(
SELECT "Category",
"Item Purchased",
COUNT("Customer ID") AS total_order,
ROW_NUMBER() OVER(partition by "Category" order by COUNT("Customer ID") desc) AS item_rank
FROM customer
group by "Category","Item Purchased"
)

SELECT item_rank,"Category", "Item Purchased",total_order
FROM item_counts
WHERE item_rank <= 3;


--9. Are customer who are repeat buyers (more then previous purchases) also likely to subcsribe?
SELECT "Subscription Status",
COUNT("Customer ID") AS repeat
FROM customer
WHERE "Previous Purchases" > 5
group by "Subscription Status"

--10. what is the revenue contributed of each age group.
SELECT "Age",
SUM("Purchase Amount (USD)") AS revenue
FROM customer
group by "Age"
order by revenue desc;

 



