<?php
	$error = "";
	$msg = "";

	$fileElementName = $_GET['image'];
	
		
$imagedir = str_replace("../", "",$_COOKIE["userdir"]);
$imagedir = str_replace("/","\\",$imagedir);
$currentdir = str_replace("app","",dirname(__FILE__));
$uploadDir = $currentdir . $imagedir . '\\';
$ran = rand()*rand();
$randfile = $ran.".jpg";
$uploadFile = $uploadDir . $randfile;
$randfiletn = $ran."_tn.jpg";
$uploadFiletn = $uploadDir . $randfiletn;
//basename($_FILES[$fileElementName]['name']);


	//'fileToUpload';
	

	if(!empty($_FILES[$fileElementName]['error']))
	{
	
	
	switch($_FILES[$fileElementName]['error'])
		{

			case '1':
				$error = 'The uploaded file exceeds the upload_max_filesize directive in php.ini';
				break;
			case '2':
				$error = 'The uploaded file exceeds the MAX_FILE_SIZE directive that was specified in the HTML form';
				break;
			case '3':
				$error = 'The uploaded file was only partially uploaded';
				break;
			case '4':
				$error = 'No file was uploadedc.';
				break;

			case '6':
				$error = 'Missing a temporary folder';
				break;
			case '7':
				$error = 'Failed to write file to disk';
				break;
			case '8':
				$error = 'File upload stopped by extension';
				break;
			case '999':
			default:
				$error = 'No error code avaiable';
		}
	}elseif(empty($_FILES[$fileElementName]['tmp_name']) || $_FILES[$fileElementName]['tmp_name'] == 'none')
	{
		$error = 'חלה בעיה בעת העלאת התמונה';
	}
	
	if (!($_FILES[$fileElementName]['type'] =="image/pjpeg" OR $_FILES[$fileElementName]['type']=="image/jpeg"))
	{
		$error = " Jpeg ניתן להעלות אך ורק קבצים מסוג";
	}else
	{
	
			$msg = $randfile;
			$ftmp = $_FILES[$fileElementName]['tmp_name'];
			$fname = $uploadFile;
			$fnametn = $uploadFiletn;
			move_uploaded_file($ftmp, $fname);

            $imagepath = $imagename;
            $save = $fname;
            $file = $fname;
 
              list($width, $height) = getimagesize($file) ; 
 
              $modwidth = 500; 
 
              $diff = $width / $modwidth;
 
              $modheight = $height / $diff; 
              $tn = imagecreatetruecolor($modwidth, $modheight) ; 
              $image = imagecreatefromjpeg($file) ; 
              imagecopyresampled($tn, $image, 0, 0, 0, 0, $modwidth, $modheight, $width, $height) ; 
 
              imagejpeg($tn, $save, 70) ; 
 // remove all the // from the next lines to create a thumbnail after uploading.
//              $save = $fnametn;
//              $file = $fname;
//		list($width, $height) = getimagesize($file) ; 
//              $modwidth = 80; 
//             $diff = $width / $modwidth;
//              $modheight = $height / $diff; 
//              $tn = imagecreatetruecolor($modwidth, $modheight) ; 
//              $image = imagecreatefromjpeg($file) ; 
//              imagecopyresampled($tn, $image, 0, 0, 0, 0, $modwidth, $modheight, $width, $height) ; 
//              imagejpeg($tn, $save, 100) ; 
	}		
	echo "{";
	echo				"error: '" . $error . "',\n";
	echo				"msg: '" . $msg . "'\n";
	echo "}";
?>