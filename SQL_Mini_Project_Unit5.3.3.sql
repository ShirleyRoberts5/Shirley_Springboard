/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */
SELECT name FROM `Facilities` WHERE membercost <> 0




/* Q2: How many facilities do not charge a fee to members? */
SELECT count(*) FROM `Facilities` WHERE membercost = 0




/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */
SELECT facid,
       name,
       membercost,
       monthlymaintenance

FROM `Facilities`

WHERE (membercost>0) and (membercost<(20/100*monthlymaintenance))





/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */
SELECT *

FROM `Facilities`

WHERE facid in (1,5)





/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */
SELECT name,
       monthlymaintenance,
       case when monthlymaintenance <= 100 then 'cheap'
            else 'expensive' end as type

FROM `Facilities`
ORDER BY 2,3



/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */
SELECT firstname,
       surname

FROM   Members

WHERE  memid=(select max(memid) from Members)




/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */
SELECT distinct concat(mem.firstname,' ',mem.surname, '-' , fac.name) AS 'Member-TennisCourtUsed'
       
FROM (Bookings bk join Facilities fac on bk.facid = fac.facid) join Members mem on bk.memid = mem.memid

WHERE  fac.facid in (0,1)

ORDER BY 1

        



/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */
SELECT concat(fac.name,' - ', mem.firstname, ' ', mem.surname) as FacilityAndMember,
       case when bk.memid = 0 then (bk.slots*fac.guestcost) else (bk.slots*fac.membercost) end as TotalCostOfSlots

FROM   (Bookings bk join Facilities fac on bk.facid=fac.facid) join Members mem on bk.memid = mem.memid 
WHERE  starttime like '2012-09-14%'
HAVING TotalCostOfSlots >30
ORDER BY 2 desc
       





/* Q9: This time, produce the same result as in Q8, but using a subquery. */


select concat(facy.name,' - ', memb.firstname, ' ', memb.surname) as FacilityAndMember,
       subqry.TotalCostOfSlots
FROM  (SELECT bk.memid,
             fac.facid,
             case when bk.memid = 0 then (bk.slots*fac.guestcost) else (bk.slots*fac.membercost) end as TotalCostOfSlots
       FROM Bookings bk join Facilities fac on bk.facid=fac.facid
       WHERE bk.starttime like '2012-09-14%'
       HAVING TotalCostOfSlots > 30
       ORDER BY 3 desc) as subqry

      
       JOIN Members memb on subqry.memid = memb.memid

       JOIN Facilities facy on subqry.facid=facy.facid
      


/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

SELECT sub.name as FacilityName,
       SUM( sub.TotalCostOfSlots ) AS FacilityTotalRevenue
FROM ( SELECT fac.name,
              CASE WHEN bk.memid =0 THEN (bk.slots * fac.guestcost) ELSE (bk.slots * fac.membercost) END AS TotalCostOfSlots
       FROM Bookings bk JOIN Facilities fac) AS sub

GROUP BY 1
HAVING FacilityTotalRevenue < 1000 -- <-Zero output rows due to this line, without it we see Revenues By Facility-Names
ORDER BY 2 DESC















