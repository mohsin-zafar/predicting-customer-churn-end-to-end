-- Data Exploration – Check Distinct Values
SELECT gender, Count(gender) as TotalCount,
Count(gender) * 1.0 / (Select Count(*) from customer_data)  as Percentage
from customer_data
Group by gender

SELECT contract, Count(contract) as TotalCount,
Count(contract) * 1.0 / (Select Count(*) from customer_data)  as Percentage
from customer_data
Group by contract


SELECT customer_status, Count(customer_status) as TotalCount, Sum(Total_Revenue) as TotalRev,
Sum(Total_Revenue) / (Select sum(Total_Revenue) from customer_data) * 100  as RevPercentage
from customer_data
Group by customer_status

SELECT state, Count(state) as TotalCount,
Count(state) * 1.0 / (Select Count(*) from customer_data)  as Percentage
from customer_data
Group by state
Order by Percentage desc
-- Data Exploration – Check Nulls
select 
    sum(case when customer_id is null then 1 else 0 end) as customer_id_null_count,
    sum(case when gender is null then 1 else 0 end) as gender_null_count,
    sum(case when age is null then 1 else 0 end) as age_null_count,
    sum(case when married is null then 1 else 0 end) as married_null_count,
    sum(case when state is null then 1 else 0 end) as state_null_count,
    sum(case when number_of_referrals is null then 1 else 0 end) as number_of_referrals_null_count,
    sum(case when tenure_in_months is null then 1 else 0 end) as tenure_in_months_null_count,
    sum(case when value_deal is null then 1 else 0 end) as value_deal_null_count,
    sum(case when phone_service is null then 1 else 0 end) as phone_service_null_count,
    sum(case when multiple_lines is null then 1 else 0 end) as multiple_lines_null_count,
    sum(case when internet_service is null then 1 else 0 end) as internet_service_null_count,
    sum(case when internet_type is null then 1 else 0 end) as internet_type_null_count,
    sum(case when online_security is null then 1 else 0 end) as online_security_null_count,
    sum(case when online_backup is null then 1 else 0 end) as online_backup_null_count,
    sum(case when device_protection_plan is null then 1 else 0 end) as device_protection_plan_null_count,
    sum(case when premium_support is null then 1 else 0 end) as premium_support_null_count,
    sum(case when streaming_tv is null then 1 else 0 end) as streaming_tv_null_count,
    sum(case when streaming_movies is null then 1 else 0 end) as streaming_movies_null_count,
    sum(case when streaming_music is null then 1 else 0 end) as streaming_music_null_count,
    sum(case when unlimited_data is null then 1 else 0 end) as unlimited_data_null_count,
    sum(case when contract is null then 1 else 0 end) as contract_null_count,
    sum(case when paperless_billing is null then 1 else 0 end) as paperless_billing_null_count,
    sum(case when payment_method is null then 1 else 0 end) as payment_method_null_count,
    sum(case when monthly_charge is null then 1 else 0 end) as monthly_charge_null_count,
    sum(case when total_charges is null then 1 else 0 end) as total_charges_null_count,
    sum(case when total_refunds is null then 1 else 0 end) as total_refunds_null_count,
    sum(case when total_extra_data_charges is null then 1 else 0 end) as total_extra_data_charges_null_count,
    sum(case when total_long_distance_charges is null then 1 else 0 end) as total_long_distance_charges_null_count,
    sum(case when total_revenue is null then 1 else 0 end) as total_revenue_null_count,
    sum(case when customer_status is null then 1 else 0 end) as customer_status_null_count,
    sum(case when churn_category is null then 1 else 0 end) as churn_category_null_count,
    sum(case when churn_reason is null then 1 else 0 end) as churn_reason_null_count
from customer_data;
-- Remove null and insert the new data into Prod table
create table prod_churn as
select 
    customer_id,
    gender,
    age,
    married,
    state,
    number_of_referrals,
    tenure_in_months,
    ifnull(value_deal, 'none') as value_deal,
    phone_service,
    ifnull(multiple_lines, 'no') as multiple_lines,
    internet_service,
    ifnull(internet_type, 'none') as internet_type,
    ifnull(online_security, 'no') as online_security,
    ifnull(online_backup, 'no') as online_backup,
    ifnull(device_protection_plan, 'no') as device_protection_plan,
    ifnull(premium_support, 'no') as premium_support,
    ifnull(streaming_tv, 'no') as streaming_tv,
    ifnull(streaming_movies, 'no') as streaming_movies,
    ifnull(streaming_music, 'no') as streaming_music,
    ifnull(unlimited_data, 'no') as unlimited_data,
    contract,
    paperless_billing,
    payment_method,
    monthly_charge,
    total_charges,
    total_refunds,
    total_extra_data_charges,
    total_long_distance_charges,
    total_revenue,
    customer_status,
     case 
        when churn_category is null or churn_category = '' then 'others'
        else churn_category
    end as churn_category,
    case 
        when churn_reason is null or churn_reason = '' then 'others'
        else churn_reason
    end as churn_reason
from customer_data;
-- Create View for Power BI
Create View vw_ChurnData as
	select * from prod_Churn where Customer_Status In ('Churned', 'Stayed')


Create View vw_JoinData as
	select * from prod_Churn where Customer_Status = 'Joined'
