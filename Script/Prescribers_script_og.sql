-- ## Prescribers Database

-- For this exericse, you'll be working with a database derived from the [Medicare Part D Prescriber Public Use File]
	--(https://www.hhs.gov/guidance/document/medicare-provider-utilization-and-payment-data-part-d-prescriber-0). 
	--More information about the data is contained in the Methodology PDF file. See also the included entity-relationship diagram.

-- 1. 
--     a. Which prescriber had the highest total number of claims (totaled over all drugs)? Report the npi and the total number of claims.
-- SELECT npi, SUM(total_claim_count) AS total_claims
-- FROM prescriber
-- INNER JOIN prescription 
-- USING (NPI)
-- WHERE total_claim_count IS NOT NULL
-- 	GROUP BY npi
-- ORDER BY SUM(total_claim_count) DESC;

--ANSWER: NPI - 1881634483, Total claims - 99,707
   
--     b. Repeat the above, but this time report the nppes_provider_first_name, nppes_provider_last_org_name,  specialty_description, 
		--	and the total number of claims.
-- SELECT CONCAT(nppes_provider_last_org_name,',',' ',nppes_provider_first_name) AS nnpes_provider_name, specialty_description,
-- 		 SUM(total_claim_count) AS total_claims
-- FROM prescriber
-- INNER JOIN prescription 
-- USING (NPI)
-- WHERE total_claim_count IS NOT NULL
-- GROUP BY nnpes_provider_name, specialty_description
-- ORDER BY SUM(total_claim_count) DESC;

--ANSWER: Bruce Pendley Specialty - Family Practice, NPI - 1881634483, Total claims - 99,707

-- 2. 
--     a. Which specialty had the most total number of claims (totaled over all drugs)?
-- SELECT prescriber.specialty_description, SUM(prescription.total_claim_count) AS total_claims
-- FROM prescriber
-- INNER JOIN prescription
-- USING(NPI)
-- 	GROUP BY prescriber.specialty_description
-- ORDER BY SUM(prescription.total_claim_count) DESC;

--ANSWER: Familty Practic - 9,752,347

-- --     b. Which specialty had the most total number of claims for opioids?

-- SELECT prescriber.specialty_description, SUM(prescription.total_claim_count)
-- FROM prescriber
-- INNER JOIN prescription
-- USING(NPI)
-- INNER JOIN drug
-- USING(drug_name)
-- WHERE opioid_drug_flag = 'Y'
-- GROUP BY prescriber.specialty_description
-- ORDER BY SUM(total_claim_count) DESC;

--ANSWER: Nurse Practitioners - 900,845

--     c. **Challenge Question:** Are there any specialties that appear in the prescriber table that have no associated prescriptions in the 
		--prescription table?

-- SELECT specialty_description, COUNT(total_claim_count)
-- FROM prescriber
-- FULL JOIN prescription
-- USING(NPI)
-- GROUP BY specialty_description
-- EXCEPT
-- 	(SELECT specialty_description, COUNT(total_claim_count)
-- 	FROM prescriber
-- 	FULL JOIN prescription
-- 	USING(npi)
-- 	GROUP BY specialty_description
-- 	HAVING COUNT(total_claim_count) > 0);

-- SELECT DISTINCT(specialty_description), COUNT(total_claim_count)
-- FROM prescriber
-- LEFT JOIN prescription
-- USING(NPI)
-- GROUP BY specialty_description
-- HAVING COUNT(total_claim_count) = 0,


--     d. **Difficult Bonus:** *Do not attempt until you have solved all other problems!* For each specialty, report the percentage of total claims 	
		--by that specialty which are for opioids. Which specialties have a high percentage of opioids?

SELECT specialty_description, 
	SUM (CASE WHEN drug.opioid_drug_flag = 'Y' THEN total_claim_count
		ELSE 0 END) AS opioid_claims,
	SUM (total_claim_count) as total_claims,	
	SUM (CASE WHEN drug.opioid_drug_flag = 'Y' THEN total_claim_count
		ELSE 0 END) * 100 / SUM(total_claim_count) AS percentage
FROM prescriber
INNER JOIN prescription
USING(npi)
INNER JOIN drug
USING (drug_name)
GROUP BY specialty_Description
ORDER BY percentage DESC;
	

-- 3. 
--     a. Which drug (generic_name) had the highest total drug cost?

-- SELECT generic_name, SUM(total_drug_cost):: money
-- FROM prescription
-- INNER JOIN drug
-- USING (drug_name)
-- GROUP BY generic_name
-- ORDER BY SUM(total_drug_cost) DESC;

--ANSWER: Insulin Glargine, HUM. RC. ANLOG - $104,264,066.35

--     b. Which drug (generic_name) has the hightest total cost per day? **Bonus: Round your cost per day column to 2 decimal places. 
		-- Google ROUND to see how this works.**
-- SELECT generic_name, ROUND(SUM(total_drug_cost)/ SUM(total_day_supply), 2):: money AS cost_per_day
-- FROM prescription
-- INNER JOIN drug
-- USING (drug_name)
-- GROUP BY generic_name
-- ORDER BY cost_per_day DESC
-- LIMIT 1;

--ANSWER: "C1 ESTERASE INHIBITOR" -"$3,495.22"

-- 4. 
--     a. For each drug in the drug table, return the drug name and then a column named 'drug_type' which says 'opioid' for drugs which have 
		--opioid_drug_flag = 'Y', says 'antibiotic' for those drugs which have antibiotic_drug_flag = 'Y', and says 'neither' for all other drugs. 
		--**Hint:** You may want to use a CASE expression for this. See https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-case/
-- SELECT drug_name, 
-- 		CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
-- 		WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
-- 		ELSE 'neither' END AS  drug_type
-- FROM drug;
		

--     b. Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) on opioids or on antibiotics. 
		-- Hint: Format the total costs as MONEY for easier comparision.

-- SELECT 	case when opioid_drug_flag = 'Y' THEN 'opioid'
-- 		when antibiotic_drug_flag = 'Y' THEN 'antibiotic'
-- 		else 'neither' END AS  drug_type, SUM(total_drug_cost)::money AS total_cost_per_category
-- FROM drug
-- INNER JOIN prescription
-- USING(drug_name)
-- GROUP BY drug_type
-- ORDER BY total_cost_per_category DESC;

-- ANSWER: More money was spent on opioids

-- 5. 
--     a. How many CBSAs are in Tennessee? **Warning:** The cbsa table contains information for all states, not just Tennessee.
-- SELECT count(cbsa)
-- FROM cbsa
-- left join fips_county
-- using (fipscounty)
-- WHERE state = 'TN';

--ANSWER: 42 CBSAs in Tennessee

--     b. Which cbsa has the largest combined population? Which has the smallest? Report the CBSA name and total population.
-- SELECT cbsa, cbsaname, SUM(population)
-- FROM cbsa
-- INNER JOIN fips_county
-- USING(fipscounty)
-- INNER JOIN population
-- USING(fipscounty)
-- 	GROUP BY cbsa, cbsaname
-- ORDER BY sum(population) DESC;

-- ANSWER: "34980"	"Nashville-Davidson--Murfreesboro--Franklin, TN"	1830410

--     c. What is the largest (in terms of population) county which is not included in a CBSA? Report the county name and population.
-- SELECT county, population
-- FROM population
-- left JOIN fips_county
-- USING(fipscounty)
-- left JOIN CBSA
-- USING(fipscounty)
-- WHERE CBSA IS NULL
-- ORDER BY population DESC;

-- ANSWER: Sevier - population: 95523

-- 6. 
--     a. Find all rows in the prescription table where total_claims is at least 3000. Report the drug_name and the total_claim_count.
-- SELECT drug_name, total_claim_count
-- FROM prescription
-- WHERE total_claim_count >= 3000
-- ORDER BY total_claim_count DESC;

--     b. For each instance that you found in part a, add a column that indicates whether the drug is an opioid.
-- SELECT drug_name, total_claim_count, opioid_drug_flag
-- FROM prescription
-- INNER JOIN drug
-- USING (drug_name)
-- WHERE total_claim_count >= 3000 AND opioid_drug_flag = 'Y'
-- ORDER BY total_claim_count DESC;

--     c. Add another column to you answer from the previous part which gives the prescriber first and last name associated with each row.
-- SELECT drug_name, total_claim_count, opioid_drug_flag, CONCAT(nppes_provider_first_name,' ',nppes_provider_last_org_name) AS nnpes_provider_name
-- FROM prescription
-- INNER JOIN drug
-- USING (drug_name)
-- INNER JOIN prescriber
-- USING(npi)
-- WHERE total_claim_count >= 3000 AND opioid_drug_flag ='Y'
-- ORDER BY total_claim_count DESC;

-- 7. The goal of this exercise is to generate a full list of all pain management specialists in Nashville and the number of claims they had for 
		-- each opioid. **Hint:** The results from all 3 parts will have 637 rows.

--     a. First, create a list of all npi/drug_name combinations for pain management specialists (specialty_description = 'Pain Management) 
		-- in the city of Nashville (nppes_provider_city = 'NASHVILLE'), where the drug is an opioid (opioid_drug_flag = 'Y'). 
		-- **Warning:** Double-check your query before running it. You will only need to use the prescriber and drug tables since you don't 
		-- need the claims numbers yet.
-- SELECT prescriber.specialty_description, npi, prescriber.nppes_provider_city, drug.opioid_drug_flag
-- FROM prescriber
-- CROSS JOIN drug
-- WHERE specialty_description = 'Pain Management'
-- 	AND nppes_provider_city = 'NASHVILLE'
-- 	AND opioid_drug_flag = 'Y';


--     b. Next, report the number of claims per drug per prescriber. Be sure to include all combinations, whether or not the prescriber had any claims. 
		-- You should report the npi, the drug name, and the number of claims (total_claim_count).
-- SELECT npi, drug_name, total_claim_count
-- FROM prescriber
-- CROSS JOIN drug
-- LEFT JOIN prescription
-- USING (npi, drug_name)
-- WHERE specialty_description = 'Pain Management'
-- 	AND nppes_provider_city = 'NASHVILLE'
-- 	AND opioid_drug_flag = 'Y'
-- ORDER BY total_claim_count;
    
--     c. Finally, if you have not done so already, fill in any missing values for total_claim_count with 0. Hint - Google the COALESCE function.
-- SELECT npi, drug_name, COALESCE(total_claim_count,0) AS total_claim_coalesce
-- FROM prescriber
-- CROSS JOIN drug
-- LEFT JOIN prescription
-- USING (npi, drug_name)
-- WHERE specialty_description = 'Pain Management'
-- 	AND nppes_provider_city = 'NASHVILLE'
-- 	AND opioid_drug_flag = 'Y'
-- ORDER BY total_claim_coalesce DESC;
    
