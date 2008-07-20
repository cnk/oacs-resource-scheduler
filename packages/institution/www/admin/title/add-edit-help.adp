<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>
<master>
<property name="title">Manipulating Titles</property>

<style type="text/css">
ul.questions-and-answers > li {
	margin:		1em;
}

li.question {
}

li.answer {
	margin-bottom:		1em;
}
</style>
<script type="text/javascript" language="JavaScript1.2"><!--
	function selectCorrespondingQandA(link) {
		var lookingFor = link.hash.substring(1);
		for(var i = 0; i < document.anchors.length; i++) {
			var a = document.anchors[i];
			if(a.name == lookingFor) {
				a.parentNode.style.background	= "skyblue";
				a.style.background				= "gold";
				if(a.nextSibling && a.nextSibling.nextSibling) {
					var q = a.nextSibling.nextSibling;
					q.style.background			= "gold";
				}
			} else {
				a.parentNode.style.background	= "inherit";
				a.style.background				= "inherit";
				if(a.nextSibling && a.nextSibling.nextSibling) {
					var q = a.nextSibling.nextSibling;
					q.style.background			= "inherit";
				}
			}
		}
	}
//-->
</script>

<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr><td><ul class="questions">
				<li><a href="#login" onClick="selectCorrespondingQandA(this)"><b>How do I log in?</b></a></li>
				<li><a href="#put-in-group" onClick="selectCorrespondingQandA(this)"><b>How Put Someone in a Group?</b></a></li>
			</ul>
			<hr/>
			<ul class="questions-and-answers">
				<li><a name="login"></a>
					<b>How do I log in?</b>
					<ol><li>Step 1 of Answer</li>
						<li>Step 2 of Answer</li>
					</ol>
				</li>
				<li><a name="put-in-group"></a>
					<b>How Put Someone in a Group?</b>
					<ol><li>Step 1 of Answer</li>
						<li>Step 2 of Answer</li>
					</ol>
				</li>
			</ul>
		</td>
	</tr>
</table>
