/*
    User Requirement 1: The system will allow customers to add orders, verify orders status, cancel orders.
*/

-- adding order
--    userid          : logged user into the system
--    driver          : driver selected to deliver the order
--    payment_method  : preferred payment method
--    deliver_to      : delirable address
--    created         : System timestamp(SELECT NOW())   
--    status          : 'created'
INSERT INTO `order`(userid, driver, payment_method, deliver_to, created, status) VALUES (:userid, driver, :payment_method, :deliver_to, NOW(), 'created');

-- adding order items
--    order_id        : order_id previous created
--    menu_item       : item added from menu
--    quantity        : quantity
--    total           : order total
INSERT INTO `order_item`(order_id, menu_item, quantity, total) VALUES (:order_id, :menu_item, :quantity, :total);

-- canceling order
--    id              : order_id
--    canceled        : System timestamp(SELECT NOW())
--    status          : canceled
-- 
UPDATE `order` SET canceled = NOW(), status= 'canceled' WHERE id = :order_id

-- verify order status
SELECT status FROM `order` WHERE id = :order_id

/*
    User Requirement 2: The system will allow drivers to pick orders from a queue and delivering to customers.
*/    
SELECT o.id, a.street, a.city, a.state, a.zipcode, a.latitude, a.longitude
  FROM `order` o, address a
     WHERE o.status='created'
       AND o.deliver_to = a.id
ORDER BY o.created
LIMIT 1;

/*
    User Requirement 3: The system will allow customers to create favorite orders.

    Favorite orders functionally will be added on phase 2. 
*/    


/*
    User Requirement 4: The system will provide a global address catalog to avoid duplicate records added to the system. The address catalog will also provide latitude and longitude coordinates to be used in data visualizations.

*/
SELECT a.street, a.city, a.state, a.zipcode, a.latitude, a.longitude FROM address a;


/*
    User Requirement 5: The system will allow the restaurants to specify the operation hours of the business, select a local manager, 
                        and implement the use of the global address catalog. A restaurant must also have a feature to enable or disable 
                        the ordering system as a whole.

*/

 -- Operation
 --      type of food : Type of restaurant (Restaurant_Type)
 --      day_of_week  : #1 = Sunday, 2 = Monday, 4 = Tuesday, 8 = Wednesday, 16 = Thursday, 32 = Friday, 64 = Saturday (Bitwise)
 --      manager      : an employee record (Employee table)
 --      address      : Valid address (Address Table)
 --      status       : open,closed
 --      open, close  : hours of operation (hh:mm:ss)
 INSERT INTO restaurant(type, manager, address, name, phone, website, status, open, close, day_of_week) 
                VALUES (:type, :manager, :address, :name, :phone, :website, :status, :open, :close, :day_of_week);


/*
	User Requirement 7: The system will allow customers to evaluate orders and deliveries.
*/  
-- Order review
--    rate           : poor, fair, average, good, excellent
--    comments       : additional comments
INSERT INTO `order_review`(order_id, rate, comments) VALUES (:order_id, :rate, :comments);

INSERT INTO `delivery_review`(order_id, rate, comments) VALUES (:order_id, :rate, :comments);

/*
    Functional Requirement 12: Restaurants will be able to build their menu offering while listing calories, prices, size, promotions, and food category of their food and drink offering. 
*/

-- add menu
--restaurant_id:	Restaurant id that is associated with the menu
--title:		The title or name of the menu
--content:		The content description
--enabled:		Whether the menu has been enabled for restaurant 

INSERT INTO `menu`(restaurant_id, title, content, enabled) VALUES (:restaurant_id, :title, :content, :enabled);

-- adding menu_items
--    	menu_id	: the menu_id that is associated with the Restaurant	
--	ingredient_id	: the ingredient_id of the ingredients that will be added

INSERT INTO `menu_items`(menu_id, ingredient_id) VALUES (:menu_id, :ingredient_id);

-- adding ingredients
--  	allergen 	: the allergen associated with the ingredient
-- 	diet_adherence_tag	: any ingredients that are diet concerns 
--	name		:	 name of the ingredient
--	price		:	The price of the item ingredient
--	size	:		The of the item ingredients 
--	calories	:	The calorie of the ingredient item 
--	promotion_tag:		The promotion that the ingredient item is tied with
--	units	:		The units of the ingredient item

INSERT INTO `ingredients`(allergen, diet_adherence_tag, name, price, size, calories, promotion_tag,unit) VALUES (:allergen, :diet_adherence_tag, :name, :price, :size, :calories, :promotion_tag,unit);

-- apply promotion price

UPDATE 'ingredients' SET price= :price where promotion_tag = :promotion_tag;

/*Functional Requirement 13: Restaurants will have the ability to list the ingredients of each food and tag with special dietary and/or common food allergens. 
*/

--adding ingredients
--	ingredients_id	: id of the ingredients
--	allergen	: known allergen of ingredient
--	ingredients_name: name of ingredient
--	diet_addherence_tag:what type of diet does this break

INSERT INTO `ingredients`(ingredients_id, allergen, ingredients_name, diet_adherence_tag) VALUES (:ingredients_id, :allergen, :ingredients_name, :diet_adherence_tag);

-- check allergy of item

select i.name, i.allergen fROM menu_items m, ingredients i Where m.menu_id = menu_id AND  m.allergen = allergen;
		
-- search for items that do adhere to user diet 

select i.name, i.diet_adherence_tag fROM menu_items m, ingredients i Where m.menu_id = menu_id AND  m.allergen != diet_adherence_tag;
		
/*Functional Requirement 14: Customers will be able to save preferred payment options of credit/debit cards (with billing address), paypal, and/or google pay. 
*/

-- adding payment_method
--	user_id	:user_id associated with the pyament method
--	credit_card_id	:id of the credit card
--	paypal_id	:id of the paypal
--	google_pay_id	:id of google pay

INSERT INTO `payment_method`(user_id,credit_card_id,paypal_id,google_pay_id) VALUES (:user_id,:credit_card_id,:paypal_id,:google_pay_id);

-- adding credit_card
--	branch		:merchant type of the credit card
--	expiration_month:month that the credit card expires
--	expiration_year: year of the credit card expiration

INSERT INTO `credit_card`(branch,expiration_month,expiration_year) VALUES (:branch,:expiration_month,:expiration_year);

-- adding paypal
--	comments:comments
--	u_id	:user id
--	
INSERT INTO `paypal`(comments,u_id) VALUES (:comments,:u_id);

-- adding google_pay
--	comments:comments
--	u_id	:user id
--	
INSERT INTO `google_pay`(comments,u_id) VALUES (:comments,:u_id);

/* Functional Requirement 16: The system will allow customers/restaurants/drivers to input and store their credentials, password, and role. */

-- adding credentials
-- 	user_id	:unique id of the credential
--	password	: password of the user
--	employee_id	: id of the employee
--	driver_id	: id of the driver
--	customer_id	:id of the customer
--	role		:role of the credential

INSERT INTO `credentials`(password,employee_id,driver_id,customer_id,role) VALUES (:password,:employee_id,:driver_id,:customer_id,:role);

/* User Requirement 17: The system will allow customers/restaurants/drivers to view their past orders and transaction receipts.

Implemented in Phase 2.  
*/
		

/* 
    Driver Dashboad
*/

-- Driver Selection
SELECT CONCAT(CONCAT(id,'-'), CONCAT(CONCAT(firstname, ' '),lastname)) name  from driver


-- Ready to Pickup
--     driver     : Selected driver
--     date range : start,end date when the order was created.
SELECT COUNT(1) FROM `order` WHERE driver='${driver}' AND status='created' AND created BETWEEN FROM_UNIXTIME(:start) AND FROM_UNIXTIME(:end)

-- In Progress
SELECT COUNT(1) FROM `order` WHERE driver='${driver}' AND status='in-progress' AND created BETWEEN FROM_UNIXTIME(:start) AND FROM_UNIXTIME(:end)

-- Delivered
SELECT COUNT(1) FROM `order` WHERE driver='${driver}' AND status='delivered' AND created BETWEEN FROM_UNIXTIME(:start) AND FROM_UNIXTIME(:end)

-- Canceled
SELECT COUNT(1) FROM `order` WHERE driver='${driver}' AND status='canceled' AND created BETWEEN FROM_UNIXTIME(:start) AND FROM_UNIXTIME(:end)

-- Pickup Activity Map
SELECT a.latitude, a.longitude, 
       CONCAT(CONCAT(cu.firstname, ' '),cu.lastname) name,
       TIMESTAMPDIFF(MINUTE,NOW(), o.created) value 
  FROM `order` o, address a, credentials c, customer cu
     WHERE o.driver=:driver
       AND o.status='created'  
       AND o.deliver_to = a.id  
       AND o.userid = c.userid  
       AND c.customer_id = cu.id   
       AND created BETWEEN FROM_UNIXTIME(:start) AND FROM_UNIXTIME(:end)
  
-- Poor Service Evaluation
SELECT COUNT(1)
  FROM `delivery_review` dr, `order` o
     WHERE dr.order_id = o.id
       AND dr.rate   = 'poor'
       AND o.driver    = :driver
       AND o.created BETWEEN FROM_UNIXTIME(:start) AND FROM_UNIXTIME(:end)

-- Fair Service Evaluation
SELECT COUNT(1)
  FROM `delivery_review` dr, `order` o
     WHERE dr.order_id = o.id
       AND dr.rate   = 'fair'
       AND o.driver    = :driver
       AND o.created BETWEEN FROM_UNIXTIME(:start) AND FROM_UNIXTIME(:end)       

-- Average Service Evaluation
SELECT COUNT(1)
  FROM `delivery_review` dr, `order` o
     WHERE dr.order_id = o.id
       AND dr.rate   = 'average'
       AND o.driver    = :driver
       AND o.created BETWEEN FROM_UNIXTIME(:start) AND FROM_UNIXTIME(:end)            

-- Good Service Evaluation
SELECT COUNT(1)
  FROM `delivery_review` dr, `order` o
     WHERE dr.order_id = o.id
       AND dr.rate   = 'good'
       AND o.driver    = :driver
       AND o.created BETWEEN FROM_UNIXTIME(:start) AND FROM_UNIXTIME(:end)       

-- Excellent Service Evaluation
SELECT COUNT(1)
  FROM `delivery_review` dr, `order` o
     WHERE dr.order_id = o.id
       AND dr.rate   = 'excellent'
       AND o.driver    = :driver
       AND o.created BETWEEN FROM_UNIXTIME(:start) AND FROM_UNIXTIME(:end)                   

/* 
    Manager Dashboad
*/

-- Order Amount Summary Statistics

-- minimum
SELECT MIN(total) as minimum
   FROM `order`
      WHERE status = 'delivered'
        AND created BETWEEN FROM_UNIXTIME(:start) AND FROM_UNIXTIME(:end)


-- average
SELECT AVG(total) as average
   FROM `order`
      WHERE status = 'delivered'
        AND created BETWEEN FROM_UNIXTIME(:start) AND FROM_UNIXTIME(:end)

-- total
SELECT SUM(total) as total
   FROM `order`
      WHERE status = 'delivered'
        AND created BETWEEN FROM_UNIXTIME(:start) AND FROM_UNIXTIME(:end)

-- maximum
SELECT MAX(total) as maximum
   FROM `order`
      WHERE status = 'delivered'
        AND created BETWEEN FROM_UNIXTIME(:start) AND FROM_UNIXTIME(:end)        

-- stddev
SELECT STDDEV(total) as stddev
   FROM `order`
      WHERE status = 'delivered'
        AND created BETWEEN FROM_UNIXTIME(:start) AND FROM_UNIXTIME(:end)           

-- Profit x Loss
SELECT (profit - loss)
FROM (SELECT SUM(total) profit
        FROM `order`
          WHERE status='delivered'
            AND created BETWEEN FROM_UNIXTIME(:start) AND FROM_UNIXTIME(:end)  
     ) as a,
     (SELECT SUM(total) loss
        FROM `order`
           WHERE status='canceled'
             AND created BETWEEN FROM_UNIXTIME(:start) AND FROM_UNIXTIME(:end)  
     ) as b
       
-- Total Sales
SELECT COUNT(1) FROM `order` WHERE status='delivered' AND created BETWEEN FROM_UNIXTIME(:start) AND FROM_UNIXTIME(:end)

-- Total Loss
SELECT COUNT(1) FROM `order` WHERE status='canceled' AND created BETWEEN FROM_UNIXTIME(:start) AND FROM_UNIXTIME(:end)

-- Preferred Payment Method
SELECT UNIX_TIMESTAMP(NOW()) as 'time_sec', a.*, b.*, c.*
FROM (SELECT COUNT(1) as 'Credit Card'
        FROM `order` o, payment_method p
           WHERE o.payment_method = p.id 
             AND p.credit_card_id IS NOT NULL
             AND created BETWEEN FROM_UNIXTIME(:start) AND FROM_UNIXTIME(:end)
	 ) as a,
     (SELECT COUNT(1) as 'Google Pay'
        FROM `order` o, payment_method p
          WHERE o.payment_method = p.id 
            AND p.google_pay_id IS NOT NULL
            AND created BETWEEN FROM_UNIXTIME(:start) AND FROM_UNIXTIME(:end)
	 ) as b, 
     (SELECT COUNT(1) as 'PayPal'
        FROM `order` o, payment_method p
          WHERE o.payment_method = p.id 
            AND p.paypal_id IS NOT NULL 
            AND created BETWEEN FROM_UNIXTIME(:start) AND FROM_UNIXTIME(:end)
 	 ) as c

-- Order Activity
SELECT o.id as `#Order`, CONCAT(CONCAT(cu.firstname, ' '), cu.lastname) as Customer, 
       CONCAT(CONCAT(d.firstname, ' '), d.lastname) as Driver, Status, Total
   FROM `order` o, credentials c, customer cu, driver d
      WHERE o.userid = c.userid
        AND c.customer_id = cu.id
        AND o.driver = d.id
         AND created BETWEEN FROM_UNIXTIME(:start) AND FROM_UNIXTIME(:end)
ORDER BY 1              

-- Order Frequency
SELECT
  UNIX_TIMESTAMP(created) DIV 3600 * 3600 AS "time",
  count(id) AS "id"
FROM `order`
WHERE
  created BETWEEN FROM_UNIXTIME(:start) AND FROM_UNIXTIME(:end)
GROUP BY 1
ORDER BY UNIX_TIMESTAMP(created) DIV 3600 * 3600




/* User requirement 01: Insert Employee information to the table, it has ISA relation with seasonal, parttime and fulltime. The method we used to this database for ISA relation is disjoint and complete. Every 			employee is either parttime, fulltime or seasonal and nobody is both. This functionality shows Employees information and their type uusing FK.

	Insertion to the Employee table:
		id : employee id
		firstname : employee's firstname
		lastname : employee's lastname
		ssn : social security number
		holiday_status : column shows that if anyone is on holiday or not
		phone : employee's phone number
		address : contains address id from Address table
		supervisor : employees id whom are also supervisor
	*/

		INSERT INTO `employee` (id, firstname, lastname, ssn, holiday_status, phone, address, supervisor) VALUES (id, firstname, lastname, 'on', phone, address, supervisor);

	/*Insertion to any (Seasonal/Part-time/Full-time) table: 
		employee_id : id from employee table
		start_date : the day and time when they started
		end_date : the day and time when they will end
		hourly_wage : hourly rate
		weekly_hours : total hours per week
	*/

		INSERT INTO `fulltime` (employee_id, start_date, end_date, hourly_wage, weekly_hours) VALUES (employee_id, "2020-11-24 00:00:00", "2021-11-24 00:00:00", hourly_wage, weekly_hours);	

	/* Update any table: (employee & fulltime) */

		UPDATE employee, fulltime
		SET firstname = firstname, hourly_wage = hourly_wage
		WHERE id = employee_id AND employee_id = id ;


	/* Find information of an Employee using FK: using aliasas and FK, we can find employees whom are seasonal or parttime or fulltime and otherinformation */

		SELECT employee_id AS Seasonal_ID, firstname AS FirstName, id AS Employee_ID, holiday_status AS Holiday, supervisor AS Manager_ID,         hourly_wage AS Wage
        	FROM employee, seasonal
      	 	WHERE id = employee_id;

	/* Insert Employee Productivity info : 
	Pro_id : auto increment, PK
	employee_id : id of an employee (FK)
	clocked_in : SELECT NOW() / we can define any given time
	clocked_out : SEELCT NOW() / we can define any given time
	date : changed the coulumn name into work_date
	*/
	 
		INSERT INTO employee_productivity SET employee_id = 1, clocked_in = time , clocked_out = time , work_date = date, assigned_hours = assigned_hours, hours_earned = TIMESTAMPDIFF(HOUR, 		clocked_in, clocked_out),
		goal = CASE WHEN TIMESTAMPDIFF(HOUR, clocked_in, clocked_out) < assigned_hours THEN 0
		WHEN  TIMESTAMPDIFF(HOUR, clocked_in, clocked_out) > assigned_hours THEN 2
		ELSE 1 END;

	/* Find employees goal using their id. Result table will show employees name and their goal */

	SELECT firstname AS NameOfEmp, goal 
        FROM employee, employee_productivity
        WHERE id = employee_id;

   
/* User requirement 02 : Insert Customer info and get info about the customers who has same address
	
	cid : customer's id (PK)
	firstname : name
        lastname : name
        phone : customer's phone
	email : customer's email
	address : contains address id from Address table (FK)
*/
	
	INSERT INTO customer SET firstname = firstname, lastname = lastname, email = email, phone = phone, address = address;
	
	/*Find the customers who has same address */
	
	SELECT firstname, lastname, phone
  	FROM customer
	WHERE address = address;
	

/*User requirement 03 : Find potential customer from their total amount and add 5% Discount 
	
	changed the table name from order to orderr as 'order' is a reserved name in SQL
	changed the column name id to oid as order_item has the same column name id, because working with both the tables containing same column name 	create an error.
	*/
	
	SELECT total AS BeforeDiscount, total-(total*5/100) As AfterDiscount, id
	FROM order_item, orderr
	WHERE  total > 100 AND id = order_id; 


/*User requirement 04 : Lucky Day Discount [if the current date is divided by 5 and the result is greater than 5 and total > 100 then the customer 			gets extra 4% discount] 
			*/

	SELECT total AS BeforeDiscount, total-(total*5/100) As AfterDiscount, (total-(total*5/100))-((total-(total*5/100))*4/100) As LuckyDiscount, 		id AS OrderID
	FROM order_item, orderr
	WHERE dayofmonth(curdate())/5 > 5 AND total > 100 AND id = order_id;  