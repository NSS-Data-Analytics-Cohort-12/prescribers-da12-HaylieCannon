-- 1. How many npi numbers appear in the prescriber table but not in the prescription table?
-- SELECT COUNT(prescriber.npi)
-- FROM prescriber
-- LEFT JOIN prescription
-- USING (npi)
-- WHERE prescription.npi IS NULL

	

--ANSWER: 4458

-- 2.
--     a. Find the top five drugs (generic_name) prescribed by prescribers with the specialty of Family Practice.
-- SELECT generic_name, SUM(total_claim_count)
-- FROM drug
-- LEFT jOIN prescription
-- USING (drug_name)
-- LEFT JOIN prescriber
-- using(npi)
-- WHERE specialty_Description = 'Family Practice'
-- GROUP BY generic_name
-- ORDER BY SUM(total_claim_count) DESC
-- LIMIT 5;

-- ANSWER: "LEVOTHYROXINE SODIUM", "LISINOPRIL", "ATORVASTATIN CALCIUM", "AMLODIPINE BESYLATE", "OMEPRAZOLE"

--     b. Find the top five drugs (generic_name) prescribed by prescribers with the specialty of Cardiology.
-- SELECT distinct(generic_name), SUM(total_claim_count)
-- FROM drug
-- LEFT jOIN prescription
-- USING (drug_name)
-- LEFT JOIN prescriber
-- using(npi)
-- WHERE specialty_Description = 'Cardiology'
-- GROUP BY generic_name
-- ORDER BY SUM(total_claim_count) DESC
-- LIMIT 5;

-- ANSWER: "ATORVASTATIN CALCIUM", "CARVEDILOL", "METOPROLOL TARTRATE", "CLOPIDOGREL BISULFATE", "AMLODIPINE BESYLATE"

--     c. Which drugs are in the top five prescribed by Family Practice prescribers and Cardiologists? Combine what you did for parts a and b into a single
		-- query to answer this question.
-- SELECT *
-- FROM (SELECT distinct(generic_name), SUM(total_claim_count)
-- 	FROM drug
-- 	INNER JOIN prescription
-- 	USING (drug_name)
-- 	INNER JOIN prescriber
-- 	USING(npi)
-- 	WHERE specialty_description = 'Cardiology' 
-- 	GROUP BY generic_name
-- 	ORDER BY SUM(total_claim_count) DESC
-- 	LIMIT 5)
-- INNER JOIN (SELECT generic_name, SUM(total_claim_count)
-- 	FROM drug
-- 	INNER jOIN prescription
-- 	USING (drug_name)
-- 	INNER JOIN prescriber
-- 	USING(npi)
-- 	WHERE specialty_Description = 'Family Practice'
-- 	GROUP BY generic_name
-- 	ORDER BY SUM(total_claim_count) DESC
-- 	LIMIT 5)
-- USING (generic_name);


--ANSWER: "ATORVASTATIN CALCIUM" and "AMLODIPINE BESYLATE"

-- 3. Your goal in this question is to generate a list of the top prescribers in each of the major metropolitan areas of Tennessee.
--     a. First, write a query that finds the top 5 prescribers in Nashville in terms of the total number of claims (total_claim_count) across all drugs. 
		--Report the npi, the total number of claims, and include a column showing the city.

-- SELECT CONCAT(nppes_provider_first_name,' ',nppes_provider_last_org_name) AS nnpes_provider_name, npi,  nppes_provider_city, SUM(total_claim_count)
-- FROM prescriber
-- LEFT JOIN prescription
-- USING(npi)
-- WHERE nppes_provider_city = 'NASHVILLE' AND total_claim_count IS NOT NULL
-- GROUP BY nnpes_provider_name, npi, nppes_provider_city
-- ORDER BY SUM(total_claim_count) DESC
-- LIMIT 5;

-- ANSWER: "JOHN WILLIAMS", "ERNEST JOHNSON", "DAVID EWART", "RICHARD GARMAN", "DAVID HEUSINKVELD"

--     b. Now, report the same for Memphis.
-- SELECT CONCAT(nppes_provider_first_name,' ',nppes_provider_last_org_name) AS nnpes_provider_name, npi, nppes_provider_city, SUM(total_claim_count)
-- FROM prescriber
-- LEFT JOIN prescription
-- USING(npi)
-- WHERE nppes_provider_city = 'MEMPHIS' AND total_claim_count IS NOT NULL
-- GROUP BY nnpes_provider_name, npi, nppes_provider_city
-- ORDER BY SUM(total_claim_count) DESC
-- LIMIT 5;

--ANSWER: "DANA NASH", "JEFFERY WARREN", "ELBERT HINES", "ROBERT BURNS", "ANGELA WATSON"
    
--     c. Combine your results from a and b, along with the results for Knoxville and Chattanooga.
-- SELECT CONCAT(nppes_provider_first_name,' ',nppes_provider_last_org_name) AS provider_name, npi, nppes_provider_city, SUM(total_claim_count) AS total_claims
-- FROM prescriber
-- INNER JOIN prescription
-- USING(npi)
-- WHERE nppes_provider_city = 'MEMPHIS' 
-- 	OR nppes_provider_city = 'NASHVILLE'
-- 	OR nppes_provider_city = 'KNOXVILLE'
-- 	OR nppes_provider_city = 'CHATTANOOGA'
-- 	AND total_claim_count IS NOT NULL
-- GROUP BY provider_name, npi, nppes_provider_city
-- ORDER BY total_claims DESC
-- LIMIT 5;

-- SELECT CONCAT(nppes_provider_first_name,' ',nppes_provider_last_org_name) AS provider_name, npi, nppes_provider_city, SUM(total_claim_count) AS total_claims
-- FROM prescriber
-- INNER JOIN prescription
-- USING(npi)
-- WHERE nppes_provider_city IN ('MEMPHIS', 'NASHVILLE', 'KNOXVILLE', 'CHATTANOOGA')
-- 	AND total_claim_count IS NOT NULL
-- GROUP BY provider_name, npi, nppes_provider_city
-- ORDER BY total_claims DESC
-- LIMIT 5;

--ANSWER: "DANA NASH", "JEFFERY WARREN", "JOHN WILLIAMS", "ELBERT HINES", "ROBERT BURNS"

-- 4. Find all counties which had an above-average number of overdose deaths. Report the county name and number of overdose deaths.
--?????
-- SELECT county, AVG(overdose_deaths) AS avg_overdose_death
-- fROM fips_county
-- INNER JOIN overdose_deaths
-- USING (fipscounty)
-- WHERE avg_overdose_death > (Select AVG(overdose_deaths)
-- 							FROM overdose_deaths) AS overall_avg

-- 5.
--     a. Write a query that finds the total population of Tennessee.
-- SELECT SUM(population)
-- FROM population
-- INNER JOIN fips_county
-- USING (fipscounty)
-- WHERE state = 'TN';

-- ANSWER: 6,597,381

    
--     b. Build off of the query that you wrote in part a to write a query that returns for each county that county's name, its population, and 
		--the percentage of the total population of Tennessee that is contained in that county.
-- WITH s AS (
-- 	SELECT SUM(population)
-- 	FROM population
-- 	INNER JOIN fips_county
-- 	USING (fipscounty)
-- 	WHERE state = 'TN';
-- )
-- SELECT country, s.population, AVG(CASE WHEN state = 'TN' AND AVG())
	
