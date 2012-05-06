<?php
// PHP Mail Spam v.2 Beta
// Created by Imzers Crew [BugCLones and nababan]
// Info and Support: http://www.imzers.org
$email = $_POST['to'];
$mail_message = $_POST['message'];
$senders_name = $_POST['name'];
$senders_email = $_POST['email'];
$mail_subject = $_POST['subject'];

$senders_name = preg_replace("/[^a-zA-Z0-9s]/", " ", $senders_name);
$senders_email = preg_replace("/[^a-zA-Z0-9s.@-_]/", " ", $senders_email);
$mail_message = stripslashes($mail_message);
$headers = "From: $senders_name <$senders_email>
";
$headers .= "Hallo...";
$jumlah = $_POST['jumlah'];
$i=0;
if ($_SERVER["REQUEST_METHOD"]=="POST")
{
if ($jumlah > 2)
{
$mail_subject++;
$mail_subject = $mail_subject++;
}
{
do
{
$i++;
mail($email, $mail_subject, $mail_message, $headers);
}
while ($i < $jumlah);
echo "email was sent sebanyak $jumlah!<br/>";
exit;
}

}
?>
<form action="<?=$_SERVER['PHP_SELF']?>?" method="post">
<div>Dari Nama:<br/>
<input type="text" name="name" size="40" /><br/>
Dari Email:<br/>
<input type="text" name="email" size="40" /><br/>
Kepada:<br/>
<input type="text" name="to" size="40" /><br/>
Judul:<br/>
<input type="text" name="subject" size="40" /><br/>
<br/>Message:<br/><textarea name="message" rows="20" cols="40"></textarea><br/>
<br/>Jumlah:<br/>
<input type="text" name="jumlah" size="12" /><br/>
<input type="submit" value="Kirim!" name="post" />
</div></form>
