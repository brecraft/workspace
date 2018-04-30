## Unpaid Commissions List

SELECT
	venues.*
	, vg.commission
FROM
	(SELECT
		za.businessid
		,za.accountname
		, zo.opportunityowner
		, COALESCE(vd.department, 'Other') AS department
		, za.newreferraltype AS billAmt
		, za.plan
		, DATE(za.dateboarded) AS dateboarded
		, IF(za.numdaysofenrollmentpromotion <= 0, NULL, za.numdaysofenrollmentpromotion) AS promoDays
		, IF(za.prepaydiscountpercent IS NULL, 'monthly', IF(za.prepaydiscountpercent = 7.5, 'preSix', 'preYear')) AS terms
		, IF(za.opsapprovedvertical = 'quick serve', 'qsr', 'rest') AS vertical
		, cp.comment
	FROM
		fakedb.accounts za LEFT JOIN
			fakedb.commissionpayouts cp ON za.businessid = cp.businessid
		, fakedb.opportunities zo LEFT JOIN
			fakedb.variabledepartment vd ON zo.opportunityowner = vd.opportunityowner
	WHERE
		1
		# Joining tables
		AND za.accountid = zo.accountid
		AND zo.opssetupcomplete = 'yes'
		# Setting criteria
		AND za.variableconversiondate IS NULL
		AND za.referraltype = 'flat rate'
		AND za.plan IS NOT NULL
		AND (cp.earnedamount > 0 OR cp.earnedamount IS NULL)
		AND (cp.amountpayed = 0
			OR cp.amountpayed IS NULL)
		GROUP BY za.businessid
	) venues LEFT JOIN
		fakedb.variableguide vg ON venues.department = vg.department
					  AND venues.billamt = vg.billamt
					  AND venues.terms = vg.terms
WHERE NOT EXISTS
	(SELECT
		cp.businessid
	FROM 
		fakedb.commissionpayouts cp
	WHERE
		venues.businessid = cp.businessid
		AND cp.amountpayed > 0)
	
;




