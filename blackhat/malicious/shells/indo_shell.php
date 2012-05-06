#!/usr/bin/php
<?php
/*
*    this script find some shell like
*    c99, c100, r57, erne, Safe_Over
*    and try to find some of unknow shell searching specific words this can be
*    not safe
*
*      how to use:
*      the script don't need no-one of these parameter thay are facoltative
*      -e Y/N enable disable eusristic mode (default is enable)
*      -p a number 1-100 , it's the percentual of word that must be find into the file to warm the euristic mode
*      -f check a single file
*     -d check a single dir (normaly the program is recursive chek ALL file )
*        powered by Dr. nefasto
*/
$euristic__ = array("fopen", "file(", "file_get_contents", "sql", "opendir", "perms", "port", "eval", "system", "exec", "rename", "copy", "delete", "hack", "(\$_", "phpinfo", "uname", "glob", "is_writable", "is_readable", "get_magic_quotes_gpc()", "move_uploaded_file", "\$dir", "& 00", "get");
$word__ = array(
            "c99" => array("c999shexit();", "setcookie(\"c999sh_surl\");", "c999_buff_prepare();"),
            "c100" => array("\$back_connect_c=\"f0VMRgEBAQA", "function myshellexec(\$command) {", "tEY87ExcilDfgAMhwqM74s6o"),
            "r57" => array("if(strpos(ex(\"echo abcr57\"),\"r57\")!=3)", "function ex(\$cfe)", "\$port_bind_bd_c=\"I2luY2x1ZGUg"),
            "erne"=> array("function unix2DosTime(\$unixtime = 0)", "eh(\$errno, \$er", "\$mtime=@date(\"Y-m-d H:i:s\",@filemti"),
            "Safe_Over" => array("function walkArray(\$array){", "function printpagelink(\$a, \$b, \$link = \"\")", "if (\$cmd != \"downl\")"),
            "cmd_asp" => array("   ' -- Read th", "ll oFileSys.D", "Author: Maceo")
        );
//the script work
$euristic_active = true;
$euristic_sens = 40;
for ($i = 1; $i < $argc; $i++)
{
    if ($argv[$i] == "-h")
        help($argv[0]);
    elseif($argv[$i] == "-e")
    {
        if ($argv[$i+1] == "Y") $euristic_active = true;
        if ($argv[$i+1] == "N") $euristic_active = false;
    }
    elseif($argv[$i] == "-p")
        $euristic_sens = $argv[$i+1];
    elseif($argv[$i] == "-d")
    {
        dir_scan($argv[$i+1]);    
        exit;
    }
    elseif($argv[$i] == "-f")
    {
        a($argv[$i+1]);    
        exit;
    }
}
dir_scan(".");
function dir_scan($name)
{
    if (!is_dir($name))
        echo "$name is not a dir\n";
    if ($o = @opendir($name))
    {
        while(false !== ($file = readdir($o)))
        {
            if ($file == '.' or $file == '..' or $file == basename(__file__)){    continue;}
            else if (is_dir($name."/".$file)){dir_scan($name."/".$file);}
            else
                a($name."/".$file);
        }
        closedir($o);
    }
    else
        echo "i can't open $name dir\n";
}
function a($file)
{
    global $euristic_active;
    global $euristic_sens;
    if ($l = file_get_contents($file))
    {
        if ( $shell = check($l))
        {
            echo "[DANGER] word_list > ".$file."\tprobably ".$shell." shell\n";
        }
        else if ($euristic_active)
            if ($t = check_euristic($l)   and $t > $euristic_sens)
            {    
                echo "[_ALERT] euristic $t%> ".$file."\tprobably is a shell\n";
            }
    }
    else
    {
        echo "i can't open $file file\n";
    }
}
function check($string)
{
    $check = 0;
    global $word__;
    foreach($word__ as $shell => $code)
        foreach($code as $microcode)
            if (stripos($string, $microcode) !== false)
            {
                $check ++;
                if ($check == 3) return $shell;
            }
    return false;
}
function check_euristic($string)
{
    global $euristic__;
    $check = 0;
    foreach($euristic__ as $code)
        if (stripos($string, $code) !== false)
            $check++;
    return intval(($check * 100) / count($euristic__));
}
function help($me)
{
    echo     "indonesianhacker shell scanner\n".
        "$me {-e [euristic method default = Y] Y/N   -p [[0-100] euristic sensibility fewer == most feeble ]   [-d [directory] / -f [file] ]}\n".
        "exemple: $me -e N -d /tmp\n"
        ;
    exit;
}
?>
