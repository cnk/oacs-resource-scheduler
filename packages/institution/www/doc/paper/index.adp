<master>
<property name="title" value="UCLA David Geffen School of Medicine Faculty Database (Paper Outline)"></property>
<h2>UCLA David Geffen School of Medicine Faculty Database (Paper Outline)</h2>
<hr>
<big>
<ol style="list-style-type: upper-roman">
	<li>Introduction
		<ul><li>Purpose of the faculty database</li>
			<li>What the database accomplishes</li>
		</ul>
	</li>
	<li>Background
		<ul><li>How the faculty database came about</li>
			<li>Lenny Rome's vision</li>
			<li>The old faculty editor</li>
		</ul>
	</li>
	<li>Technology Selection
		<ul><li>Framework - OpenACS / AOLServer</li>
			<li>DB - Oracle</li>
		</ul>
	</li>
	<li>Subsites
		<ul><li>Giving a different look and feel to the same data set</li>
			<li>The possible choices a client can have</li>
			<li>Diagram of PPlus Enterpise</li>
			<li>The ability to build subsites and integrate with other campus sites</li>
			<li>Case Studies
				(Choose 3 or 4, representative of the different levels of work
				needed and the types of customizations typically requested):
				<ul><li>Biological Chemistry</li>
					<li>Blood & Platelet Center</li>
					<li>CNSI</li>
					<li>DGSOM / Research</li>
					<li>Healthcare</li>
					<li>JCCC</li>
					<li>NPI</li>
					<li>Neuroscience</li>
					<li>OBGYN</li>
					<li>Pharmacology</li>
					<li>Radiation Oncology</li>
				</ul>
			</li>
		</ul>
	</li>
	<li>UI - Functionality
		<ul><li>Steps in Updating Data
				<ul><li>Step 1: Basic Information</li>
					<li>Step 2: Contact Information</li>
					<li>Step 3: Research Information</li>
					<li>Step 4: Publications</li>
				</ul>
			</li>
			<li>Protocol for Updating Data
				<ul><li>Certifications</li>
					<li>Titles
						<ul><li>Workflow &amp; Diagram</li></ul>
					</li>
				</ul>
			</li>
			<li>Detail Description of User Roles and Functions
				<ul><li>FDB Administrator</li>
					<li>FDB Contact</li>
					<li>Faculty Member</li>
					<li>Public User	</li>
					<li>Site Wide Administrator</li>
				</ul>
			</li>
		</ul>
	</li>
	<li>FDB Datamodel
		<ul><li>Design considerations</li>
			<li>Diagram of datamodel</li>
			<li>Personnel</li>
			<li>Groups</li>
			<li>Titles (Personnel-Group Mapping)</li>
			<li>Certifications</li>
			<li>Addresses, Phones, Email, URLs, Other Contact Info</li>
			<li>Languages</li>
			<li>Research Interests</li>
		</ul>
	</li>
	<li>External Packages Used
		<ul><li>OpenACS Permissions and Community Model</li>
			<li>Categories</li>
			<li>Countries, States, Zip Codes</li>
		</ul>
	</li>
	<li>Resumes
		<ul><li>Design</li>
			<li>NIH Biosketch Builder</li>
			<li>Public Request of Resume</li>
		</ul>
	</li>
	<li>Publications
		<ul><li>Design</li>
			<li>EndNote Data Feed</li>
			<li>PubMed API Interface & Integration</li>
			<li>Public Request of CV Application</li>
		</ul>
	</li>
	<li>External Data Sources
		<ul><li>Morrissey Imports
				<ul><li>DTS</li>
					<li>Fundamental Requirements</li>
					<li>Design of the scripts</li>
				</ul>
			</li>
			<li>QDB/ADB Imports</li>
		</ul>
	</li>
	<li>Lessons Learned
		<ul><li>Integrating fine-grained permissions</li>
			<li>Planning for the Future in the Design</li>
			<li>Balancing Flexibility vs. Transparency of Design
			<ul><li>The continuum of tradeoffs between data-driven and code-driven behavior.
							<p>Often cited mantra that less code is better cannot be blindly followed.
							Abstractions can get too deep to be maintainable -- disconnect between
								behavior code implements and overall goals of the site.
							Managing the data which drives behavior itself becomes a problem requiring
								new code.
							</p>
					</li>
					<li>Readability, Validity of References, Magic Numbers and a
						changing Domain
					</li>
					<li>Examples:
						<ul><li>Certifications</li>
							<li>Specialties</li>
						</ul>
					</li>
				</ul>
			</li>
			<li>Managing growing hierarchies: scaling the user interface</li>
			<li>Tuning the subsite development process</li>
			<li>Balancing Opposing Interests (Politics)</li>
		</ul>
	<li>Future Improvements
		<ul><li>Future Features</li>
		</ul>
	</li>
</ol>
</big>
