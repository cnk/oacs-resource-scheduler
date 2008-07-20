<master>
<property name="title">PubMed Web Service</property>
<h2>PubMed Web Service - Analysis of the XML Schema</h2>
<hr>
<h3>I. Introduction</h3>
CTRL has over 10000 publications in the new Faculty Database (FDB).  Most of these publications
were imported from the old Faculty Editor database. Currently, the only way to verify the accuracy
of these publications is to do it manually. The NCBI PubMed Database, however, has most of these 10000
publications in its database. The publications in the PubMed database are checked against journals
for accuracy, so we can consider them to be reliable.
<br><br>

<h3>II. Importing PubMed Publications</h3>
PubMed provides a Web Service to allow external sites to grab the publications from the PubMed database.
We will use this XML API to verify as many of FDB's 10000 publications as we can. We will also use the PubMed
XML API to import any new publications for UCLA Health Sciences faculty into the FDB.
There are a few steps in making sure the transfer of data happens accurately:

<ul>
<li>We first need to determine a method for matching existing publications in the FDB with a publication
	in the PubMed database. Here is a proposed solution:
	<ul>
	<li>Exact Match on inst_publications.publication_title in FDB and ArticleTitle in PubMed
	</ul>
	<br>
	I am not sure if this will be too strict and perhaps will result in few matches? 
	This should be very accurate though as two articles with the exact same name should be very rare.
	<br><br>
<li> The next step is to write a TCL script which does the following:
	<ul>
	<li>For each publication in inst_publications in FDB, pass the publications title and
		faculty name to the PubMed search script.
	<li>If the search results in exactly one publication, we can assume this publication has a
		match in PubMed.
	<li>For each publication in FDB that has exactly one match in PubMed, update the FDB database
		with the publicatition information from PubMed. Make sure to import the unique PubMed ID and XML
		so we know the publication information has been imported from PubMed and so we can update the 
		publication in the future.
	<li>For each publication in FDB that has more than one match in PubMed, insert the publication
		into a temporary table in the FDB database called inst_publications_many_pubmed_matches.
		Also insert the unique PubMed IDs of all the publications from PubMed that were found
		as a match with this publication.
		These publications will have to be examined manually to see if there is a match in PubMed.
	<li>For each publication in FDB that has no matches in PubMed, insert the publication
		into a temporary table in the FDB database called inst_publications_no_matches.
		These publications will have to be examined manually to see if there is a match in PubMed.
	</ul>
	<br>
	This script will only be run once to take care of existing publications in FDB.
	<br><br>
<li> The final step is to write a set of pages which allow a user to search for publications in the PubMed
	Database and import selected publications into the FDB.

	<br><br>
</ul>

<h3>III. PubMed Web Service</h3>
Let us now look at the PubMed Web Service in detail and what each field in the XML API corresponds to in the
Faculty Database.
<br><br>
Here is an example of the XML we will receive from PubMed for one publication.
<pre>
&lt;PubmedArticle&gt;
    &lt;MedlineCitation Owner="NLM" Status="Publisher"&gt;
        &lt;PMID&gt;16039604&lt;/PMID&gt;
        &lt;DateCreated&gt;
            &lt;Year&gt;2005&lt;/Year&gt;
            &lt;Month&gt;7&lt;/Month&gt;
            &lt;Day&gt;25&lt;/Day&gt;
        &lt;/DateCreated&gt;
        &lt;Article PubModel="Print-Electronic"&gt;
            &lt;Journal&gt;
                &lt;ISSN&gt;0005-7967&lt;/ISSN&gt;
                &lt;JournalIssue&gt;
                    &lt;PubDate&gt;
                        &lt;Year&gt;2005&lt;/Year&gt;
                        &lt;Month&gt;Jul&lt;/Month&gt;
                        &lt;Day&gt;20&lt;/Day&gt;
                    &lt;/PubDate&gt;
                &lt;/JournalIssue&gt;
            &lt;/Journal&gt;
            &lt;ArticleTitle&gt;Cognitive therapy for irritable bowel syndrome is associated with reduced limbic
			activity, GI symptoms, and anxiety.
	    &lt;/ArticleTitle&gt;
            &lt;Pagination&gt;
                &lt;MedlinePgn/&gt;
            &lt;/Pagination&gt;
            &lt;Abstract&gt;
                &lt;AbstractText&gt;
		This study sought to identify brain regions that underlie symptom changes
		in severely affected IBS patients undergoing cognitive therapy (CT). Five healthy controls and 6 Rome
		II diagnosed IBS patients underwent psychological testing followed by rectal balloon distention while
		brain neural activity was measured with O-15 water positron emission tomography (PET) before and after
		a brief regimen of CT. Pre-treatment resting state scans, without distention, were compared to post-treatment
		scans using statistical parametric mapping (SPM). Neural activity in the parahippocampal gyrus and inferior
		portion of the right cortex cingulate were reduced in the post-treatment scan, compared to pre-treatment
		(x, y, z coordinates in MNI standard space were -30, -12, -30, P=0.017; 6, 34, -8, P=0.023, respectively).
		Blood flow values at these two sites in the controls were intermediate between those in the pre- and
		post-treatment IBS patients. Limbic activity changes were accompanied by significant improvements in
		GI symptoms (e.g., pain, bowel dysfunction) and psychological functioning (e.g., anxiety, worry). The
		left pons (-2, -26, -28, P=0.04) showed decreased neural activity which was correlated with post-treatment
		anxiety scores. Changes in neural activity of cortical-limbic regions that subserve hypervigilance and
		emotion regulation may represent biologically oriented change mechanisms that mediate symptom improvement
		of CT for IBS.
		&lt;/AbstractText&gt;
            &lt;/Abstract&gt;
            &lt;Affiliation&gt;Department of Medicine, Division of Gastroenterology, Behavioral Medicine Clinic,
		University at Buffalo School of Medicine, SUNY, ECMC, 462 Grider Street, Buffalo, NY 14215, USA.
	    &lt;/Affiliation&gt;
            &lt;AuthorList&gt;
                &lt;Author&gt;
                    &lt;LastName&gt;Lackner&lt;/LastName&gt;
                    &lt;FirstName&gt;Jeffrey M&lt;/FirstName&gt;
                    &lt;Initials&gt;JM&lt;/Initials&gt;
                &lt;/Author&gt;
                &lt;Author&gt;
                    &lt;LastName&gt;Lou Coad&lt;/LastName&gt;
                    &lt;FirstName&gt;Mary&lt;/FirstName&gt;
                    &lt;Initials&gt;M&lt;/Initials&gt;
                &lt;/Author&gt;
                &lt;Author&gt;
                    &lt;LastName&gt;Mertz&lt;/LastName&gt;
                    &lt;FirstName&gt;Howard R&lt;/FirstName&gt;
                    &lt;Initials&gt;HR&lt;/Initials&gt;
                &lt;/Author&gt;
                &lt;Author&gt;
                    &lt;LastName&gt;Wack&lt;/LastName&gt;
                    &lt;FirstName&gt;David S&lt;/FirstName&gt;
                    &lt;Initials&gt;DS&lt;/Initials&gt;
                &lt;/Author&gt;
                &lt;Author&gt;
                    &lt;LastName&gt;Katz&lt;/LastName&gt;
                    &lt;FirstName&gt;Leonard A&lt;/FirstName&gt;
                    &lt;Initials&gt;LA&lt;/Initials&gt;
                &lt;/Author&gt;
                &lt;Author&gt;
                    &lt;LastName&gt;Krasner&lt;/LastName&gt;
                    &lt;FirstName&gt;Susan S&lt;/FirstName&gt;
                    &lt;Initials&gt;SS&lt;/Initials&gt;
                &lt;/Author&gt;
                &lt;Author&gt;
                    &lt;LastName&gt;Firth&lt;/LastName&gt;
                    &lt;FirstName&gt;Rebecca&lt;/FirstName&gt;
                    &lt;Initials&gt;R&lt;/Initials&gt;
                &lt;/Author&gt;
                &lt;Author&gt;
                    &lt;LastName&gt;Mahl&lt;/LastName&gt;
                    &lt;FirstName&gt;Thomas C&lt;/FirstName&gt;
                    &lt;Initials&gt;TC&lt;/Initials&gt;
                &lt;/Author&gt;
                &lt;Author&gt;
                    &lt;LastName&gt;Lockwood&lt;/LastName&gt;
                    &lt;FirstName&gt;Alan H&lt;/FirstName&gt;
                    &lt;Initials&gt;AH&lt;/Initials&gt;
                &lt;/Author&gt;
            &lt;/AuthorList&gt;
            &lt;Language&gt;ENG&lt;/Language&gt;
            &lt;PublicationTypeList&gt;
                &lt;PublicationType&gt;JOURNAL ARTICLE&lt;/PublicationType&gt;
            &lt;/PublicationTypeList&gt;
            &lt;ArticleDate DateType="Electronic"&gt;
                &lt;Year&gt;2005&lt;/Year&gt;
                &lt;Month&gt;7&lt;/Month&gt;
                &lt;Day&gt;20&lt;/Day&gt;
            &lt;/ArticleDate&gt;
        &lt;/Article&gt;
        &lt;MedlineJournalInfo&gt;
            &lt;MedlineTA&gt;Behav Res Ther&lt;/MedlineTA&gt;
            &lt;NlmUniqueID&gt;0372477&lt;/NlmUniqueID&gt;
        &lt;/MedlineJournalInfo&gt;
    &lt;/MedlineCitation&gt;
    &lt;PubmedData&gt;
        &lt;History&gt;
            &lt;PubMedPubDate PubStatus="received"&gt;
                &lt;Year&gt;2004&lt;/Year&gt;
                &lt;Month&gt;9&lt;/Month&gt;
                &lt;Day&gt;22&lt;/Day&gt;
            &lt;/PubMedPubDate&gt;
            &lt;PubMedPubDate PubStatus="revised"&gt;
                &lt;Year&gt;2005&lt;/Year&gt;
                &lt;Month&gt;5&lt;/Month&gt;
                &lt;Day&gt;6&lt;/Day&gt;
            &lt;/PubMedPubDate&gt;
            &lt;PubMedPubDate PubStatus="accepted"&gt;
                &lt;Year&gt;2005&lt;/Year&gt;
                &lt;Month&gt;5&lt;/Month&gt;
                &lt;Day&gt;13&lt;/Day&gt;
            &lt;/PubMedPubDate&gt;
            &lt;PubMedPubDate PubStatus="pubmed"&gt;
                &lt;Year&gt;2005&lt;/Year&gt;
                &lt;Month&gt;7&lt;/Month&gt;
                &lt;Day&gt;26&lt;/Day&gt;
                &lt;Hour&gt;9&lt;/Hour&gt;
                &lt;Minute&gt;0&lt;/Minute&gt;
            &lt;/PubMedPubDate&gt;
            &lt;PubMedPubDate PubStatus="medline"&gt;
                &lt;Year&gt;2005&lt;/Year&gt;
                &lt;Month&gt;7&lt;/Month&gt;
                &lt;Day&gt;26&lt;/Day&gt;
                &lt;Hour&gt;9&lt;/Hour&gt;
                &lt;Minute&gt;0&lt;/Minute&gt;
            &lt;/PubMedPubDate&gt;
        &lt;/History&gt;
        &lt;PublicationStatus&gt;aheadofprint&lt;/PublicationStatus&gt;
        &lt;ArticleIdList&gt;
            &lt;ArticleId IdType="pii"&gt;S0005-7967(05)00122-1&lt;/ArticleId&gt;
            &lt;ArticleId IdType="doi"&gt;10.1016/j.brat.2005.05.002&lt;/ArticleId&gt;
            &lt;ArticleId IdType="pubmed"&gt;16039604&lt;/ArticleId&gt;
        &lt;/ArticleIdList&gt;
    &lt;/PubmedData&gt;
&lt;/PubmedArticle&gt;
</pre>
<br>
<h3>IV. How PubMed XML Elements match up with existing FDB tables and columns.</h3>
This is how the above PubMed XML elements correspond to tables and columns in the FDB.
We need to decide which of the elements that are missing in FDB we want to add to the FDB Database.
<br><br>
<table border="1" cellpadding="2" cellspacing="0">
<tr><th width="30%">PubMed XML Element</th><th>Corresponding FDB Table and Column</th><th>Notes / Example (if needed)</th></tr>
<tr><td>MedLineCitation Owner</td><td><i>n/a</i></td><td>NLM</td></tr>
<tr><td>MedLineCitation Status</td><td><i>n/a</i></td><td>Publisher</td></tr>
<tr><td>PMID</td><td><i>n/a</i></td><td>16039604</td></tr>
<tr><td>DateCreated</td><td><i>n/a</i></td><td></td></tr>
<tr><td>Article PubModel</td><td><i>n/a</i></td><td>Print-Electronic</td></tr>
<tr><td>Journal ISSN</td><td><i>n/a</i></td><td>0005-7967</td></tr>
<tr><td>Journal Publication Date</td><td><i>n/a</i></td><td></td></tr>
<tr><td>ArticleTitle</td><td>inst_publications.title</td><td></td></tr>
<tr><td>Abstract AbstractText</td><td><i>n/a</i></td><td></td></tr>
<tr><td>Affiliation</td><td><i>n/a</i></td><td>Department of Medicine, Division of Gastroenterology, Behavioral Medicine Clinic,
                University at Buffalo School of Medicine, SUNY, ECMC, 462 Grider Street, Buffalo, NY 14215, USA.
	</td></tr>
<tr><td>AuthorList.Author</td><td>inst_publications.authors</td><td>Note: There can be multiple Author Elements. The FDB only keeps an Authors text field while PubMed has element for each Author</td></tr>
<tr><td>Language</td><td><i>n/a</i></td><td>ENG</td></tr>
<tr><td>PublicationTypeList PublicationType</td><td>inst_publications.publication_type</td><td>JOURNAL ARTICLE</td></tr>
<tr><td>ArticleDate DateType</td><td><i>n/a</i></td><td>Electronic</td></tr>
<tr><td>ArticleDate Year / Month / Day</td><td>inst_publications.publish_date</td><td></td></tr>
<tr><td>MedlineJournalInfo Medline</td><td>inst_publications.publication_name</td><td>Behav Res Ther</td></tr>
<tr><td>MedlineJournalInfo NlmUniqueID</td><td><i>n/a</i></td><td>0372477</td></tr>
<tr><td>PubMedPubDate Date received</td><td><i>n/a</i></td><td></td></tr>
<tr><td>PubMedPubDate Date revised</td><td><i>n/a</i></td><td></td></tr>
<tr><td>PubMedPubDate Date accepted</td><td><i>n/a</i></td><td></td></tr>
<tr><td>PubMedPubDate Date pubmed</td><td><i>n/a</i></td><td></td></tr>
<tr><td>PubMedPubDate date medline</td><td><i>n/a</i></td><td></td></tr>
<tr><td>PublicationStatus</td><td><i>n/a</i></td><td>aheadofprint</td></tr>
<tr><td>ArticleIdList ArticleId IDType="pii"</td><td><i>n/a</i></td><td>S0005-7967(05)00122-1</td></tr>
<tr><td>ArticleIdList ArticleId IDType="doi"</td><td><i>n/a</i></td><td>10.1016/j.brat.2005.05.002</td></tr>
<tr><td>ArticleIdList ArticleId IDType="pubmed"</td><td><i>n/a</i></td><td>16039604</td></tr>
</table>
<br>
<h3>V. Fields in the FDB publications table that do not exist in PubMed</h3>
The following fields are in the FDB publications table but not kept in PubMed.
<br><br>
<table border=1 cellpadding=2 cellspacing=0>
<tr><th>FDB Table and Column</th><th>Notes</th></tr>
<tr><td>inst_publications.url</td><td></td></tr>
<tr><td>inst_publications.volume</td><td></td></tr>
<tr><td>inst_publications.issue</td><td>There is issue date in PubMed but not the issue number</td></tr>
<tr><td>inst_publications.page_ranges</td><td></td></tr>
</table>
<br>
<h3>VI. Revision History</h3>
<blockquote>
	<table border="1" cellpadding="2">
		<tr>
			<th>Document Revision #</th>
			<th>Action Taken, Notes</th>
			<th>When?</th>
			<th>By Whom?</th>
		</tr>
		<tr>
			<td>1.0</td>
			<td>Initial</td>
			<td>2005/07/26</td>
			<td>Avni Khatri</td>
		</tr>
		<tr>
			<td>1.1</td>
			<td>Modified final step, so that there is no second script. Instead user will search for publications
				on pubmed and import into FDB.</td>
			<td>2005/08/16</td>
			<td>Avni Khatri</td>
		</tr>
	</table>
</blockquote>
<br><br>
