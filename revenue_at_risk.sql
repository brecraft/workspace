## Revenue at Risk (Mogl Revenue)
SELECT	
	atrisk.region,
	revenue.monthly,
	atrisk.CountofVenuesNotSaved,
	atrisk.Revenue,
	ROUND(atrisk.revenue / (SUM(revenue.revenue)) * 100, 2) AS 'Percent_of_Rev_at_Risk',
	2.17 AS goal,
	revenue.revenue AS 'Last_months_revenue',
	ROUND(atrisk.Revenue - ((revenue.revenue)*(2.17/100)),2) AS 'Rev_Needs_To_Be_Saved_To_Meet_Goal',
	ROUND((revenue.revenue)*(2.17/100),2) AS 'Rev_Goal'
	
	
	
	
FROM
	(SELECT #Revenue
		detail.region,
		detail.monthly
		, ROUND(SUM(IF(detail.billingtype = 1, detail.flatfee, detail.referralfee)), 2) AS revenue
	FROM
		(SELECT
			za.region,
			tx.businessid
			, DATE_FORMAT(DATE_ADD(tx.dateadded, INTERVAL 1 MONTH), '%Y-%m') AS monthly
			, IF(MAX(tx.matchedofferid) > 0, 1, 0) AS billingType #1 = Variable, 0 = Old
			, SUM(tx.referralfee - tx.cashbackbilled / tx.discountpercent * .01) AS referralFee
			, za.newreferraltype AS flatFee
		FROM
			fakedb.transactions tx
			, fakedb.accounts za
			, fakedb.opportunities zo
		WHERE
			1
			# Joining tables
			AND tx.businessid = za.businessid
			AND za.accountid = zo.accountid
			AND zo.opssetupcomplete = 'yes'
			# Setting criteria
			AND DATE_FORMAT(tx.dateadded, '%Y-%m') = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m')
		GROUP BY
			tx.businessid
			, monthly
			,region
		) detail
	GROUP BY
		detail.monthly,
		detail. region
	) revenue
	, (SELECT #At Risk
	COUNT(DISTINCT detail.businessid) AS 'CountofVenuesNotSaved',
	detail.monthly,
	ROUND(SUM(IF(detail.termdate = detail.monthly, IF(detail.billingtype = 1, detail.flatfee
	, detail.referralfee), 0)), 2) AS revenue,
	detail.region
	FROM
		(SELECT
			tx.businessid,
			za.region
			, DATE_FORMAT(DATE_ADD(tx.dateadded, INTERVAL 1 MONTH), '%Y-%m') AS monthly
			, IF(MAX(tx.matchedofferid) > 0, 1, 0) AS billingType #1 = Variable, 0 = Old
			, SUM(tx.referralfee - tx.cashbackbilled / tx.discountpercent * .01) AS referralFee
			, za.newreferraltype AS flatFee
			, DATE_FORMAT(IF(DAY(za.daterequestedtoterminate) BETWEEN 16 AND 31, DATE_ADD(
				za.daterequestedtoterminate, INTERVAL 1 MONTH), za.daterequestedtoterminate)
				, '%Y-%m') AS termDate
		FROM
			fakedb.transactions tx
			, fakedb.accounts za
			, fakedb.opportunities zo
		WHERE
			1
			# Joining tables
			AND tx.businessid = za.businessid
			AND za.accountid = zo.accountid
			AND zo.opssetupcomplete = 'yes'
			# Setting criteria
			AND DATE_FORMAT(tx.dateadded, '%Y-%m') = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m')
			AND za.daterequestedtoterminate IS NOT NULL
		GROUP BY
			tx.businessid
			, monthly
			,region
			
		HAVING termdate = DATE_FORMAT(CURDATE(), '%Y-%m')
		) detail
	GROUP BY
		monthly,
		region
	) atrisk
WHERE
	1
	# Joining tables
	AND revenue.monthly = atrisk.monthly
	AND revenue.region = atrisk.region
	

GROUP BY atrisk.region