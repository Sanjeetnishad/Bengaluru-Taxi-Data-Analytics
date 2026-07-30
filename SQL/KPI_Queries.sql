select * from bangalore_taxi_data;

--Demand KPIs


--Which wards have the highest and lowest customer demand (Searches)?
--highest
select ward, sum(searches) as total_searches 
from bangalore_taxi_data
group by ward
order by total_searches desc
limit 10;
 
--lowest
select ward, sum(searches) as total_searches
from bangalore_taxi_data
group by ward
order by total_searches asc
limit 10;


--Which wards need more drivers based on search volume?
select ward,
sum(searches)as searches,
sum(completed_trips)as completed_trip,
sum(searches)- sum(completed_trips)as  drivers_gap
from bangalore_taxi_data
group by ward
order by drivers_gap desc;





--Which wards have high demand but low completed trips?
SELECT
    ward,
    SUM(searches) AS total_searches,
    SUM(completed_trips) AS total_completed_trips
FROM bangalore_taxi_data
GROUP BY ward
HAVING SUM(searches) > SUM(completed_trips)
ORDER BY total_searches DESC, total_completed_trips ASC;


--Booking KPIs
--Which wards have the highest booking rate?
select ward,
round (sum(bookings)*100.0/sum(searches),2 )as highest_booking
from bangalore_taxi_data
group by ward
order by highest_booking desc;



--Which wards have the lowest booking rate?
select ward,
round (sum(bookings)*100.0/sum(searches),2)as lowest_booking
from bangalore_taxi_data
group by ward
order by lowest_booking asc;


--Why are bookings low despite high search volume in some wards?
select ward,
sum (searches)as searches,
sum(bookings)as bookings,
round(sum(bookings)*100.0/sum(searches),2)as booking_rate
from bangalore_taxi_data
group by ward
order by booking_rate asc;




--Conversion KPIs
--Which wards have the highest conversion rate?
select ward,
round(sum(completed_trips)*100.0/sum(searches), 2) as highest_conversion
from bangalore_taxi_data
group by ward
order by highest_conversion desc;


--Which wards have the lowest conversion rate?
select ward,
round(sum(completed_trips)*100.0/sum(searches),2) as lowest_rate
from bangalore_taxi_data
group by ward
order by lowest_rate asc;


--Which stage of the customer journey has the biggest drop-off (Search → Estimate → Quote → Booking → Trip)?
select
sum(searches) as searches,
sum(searches_which_got_estimate)as estimate,
sum(searches_for_quotes)as quotes,
sum(bookings) as bookings,
sum(completed_trips)as trip
from bangalore_taxi_data;
--Cancellation KPIs
--Which wards have the highest booking cancellation rate?
select ward,
round(((sum(bookings)-sum(completed_trips))*100.0)/sum(bookings), 2) as cancellation_rate
from bangalore_taxi_data
group by ward
order by cancellation_rate desc;
--What is causing high cancellations in specific wards?
select ward,
sum(bookings)-sum(completed_trips)as cancellation
from bangalore_taxi_data
group by ward
order by cancellation desc;
--Which wards should be prioritized to reduce cancellations? 
select ward,
sum(bookings)as bookings,
sum(completed_trips) as completed_trips,
sum(bookings)-sum(completed_trips)as cancellation
from bangalore_taxi_data
group by ward
order by cancellation desc;



--Revenue KPIs
--Which wards generate the highest driver earnings?
select ward,
sum(drivers_earnings) as highest_driver_earnings
from bangalore_taxi_data
group by ward
order by highest_driver_earnings desc;

--Which wards generate the lowest driver earnings?
select ward,
sum(drivers_earnings)as lowest_earnings
from bangalore_taxi_data
group by ward
order by lowest_earnings asc;


--Which wards have high demand but low earnings?
select ward,
sum(searches)as searches,
sum(drivers_earnings)as earnings
from bangalore_taxi_data
group by ward
order by searches desc, earnings asc;

SELECT
    ward,
    SUM(searches) AS total_searches,
    SUM(drivers_earnings) AS total_earnings
FROM bangalore_taxi_data
GROUP BY ward
HAVING
    SUM(searches) > (
        SELECT AVG(total_searches)
        FROM (
            SELECT SUM(searches) AS total_searches
            FROM bangalore_taxi_data
            GROUP BY ward
        ) s
    )
    AND
    SUM(drivers_earnings) < (
        SELECT AVG(total_earnings)
        FROM (
            SELECT SUM(drivers_earnings) AS total_earnings
            FROM bangalore_taxi_data
            GROUP BY ward
        ) e
    )
ORDER BY total_searches asc;



--Fare KPIs
--Which wards have the highest average fare per trip?
select ward,
round(avg(average_fare_per_trip),2) as avg_trip
from bangalore_taxi_data
group by ward
order by avg_trip desc;




--Does a higher average fare affect booking or conversion rates?
select ward,
round(avg(average_fare_per_trip),2) as avg_trip,
round((sum(bookings)*100)/sum(searches) ,2) as booking_rate,
round(avg(conversion_rate),2) as conversion_rate
from bangalore_taxi_data
group by ward
order by avg_trip desc;

--Which wards have low fares but high trip volumes?
select ward,
round(avg(average_fare_per_trip),2) as avg_trip,
sum(completed_trips) as completed_trip
from bangalore_taxi_data
group by ward
order by completed_trip desc;
--Distance KPIs
--Which wards have the highest average trip distance?
select ward,
round(avg(distance_travelled_km),2) as avg_distance
from bangalore_taxi_data
group by ward
order by avg_distance desc;
--Which wards contribute the most total distance travelled? 
select ward,
 sum(distance_travelled_km) as total_distance
 from bangalore_taxi_data
group by ward
order by total_distance desc;


--Performance KPIs
--Which wards are the top-performing overall?
select ward,
sum(completed_trips) as trip,
sum(drivers_earnings) as earnings,
round(sum(completed_trips)*100/sum(searches),2) as top_performing
from bangalore_taxi_data
group by ward
order by earnings desc;

--Which wards are underperforming and require business attention?
select ward,
sum(searches) as searches,
sum(completed_trips) as trip,
sum(drivers_earnings) as earning
from bangalore_taxi_data
group by ward
order by earning asc;



--Which wards should receive marketing investment?
select ward,
sum(searches) as searches,
sum(bookings)as booking
from bangalore_taxi_data
group by ward
order by searches asc;



--Which wards should receive more drivers?
select ward,
sum(searches)as seaches,
sum(completed_trips) as completed_trips,
sum(searches) - sum(completed_trips)as more_drivers
from bangalore_taxi_data
group by ward
order by more_drivers desc;
--Which wards have the greatest opportunity to improve revenue and customer experience?
SELECT ward,
SUM(searches) AS searches,
SUM(completed_trips) AS completed_trips,
SUM(drivers_earnings) AS earnings,
ROUND((SUM(completed_trips)*100.0)/SUM(searches),2) AS conversion_rate
FROM bangalore_taxi_data
GROUP BY ward
ORDER BY searches DESC, conversion_rate ASC;

 